import 'dart:convert';

import 'package:w3_lms/features/learning/data/content_parser.dart';
import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';

/// Reads a text asset. In the app this is `rootBundle.loadString`; tests
/// pass a function that reads files from disk.
typedef ContentLoader = Future<String> Function(String assetPath);

/// Content shipped inside the app as JSON under `assets/content/`, so it
/// works fully offline and can be edited without touching Dart code.
///
/// Everything is parsed once, on first use, and kept in memory.
class BundledContentRepository implements ContentRepository {
  BundledContentRepository(this._load);

  static const examFile = 'assets/content/cmat/exam.json';
  static const diagnosticFile = 'assets/content/cmat/diagnostic.json';

  final ContentLoader _load;
  Future<_Content>? _content;

  /// Loads once and shares the result. A failed load is not cached, so a
  /// "Try again" button can actually retry.
  Future<_Content> get _loaded async {
    final cached = _content;
    if (cached != null) return cached;
    final loading = _loadAll();
    _content = loading;
    try {
      return await loading;
    } on Object {
      _content = null;
      rethrow;
    }
  }

  Future<_Content> _loadAll() async {
    final examJson = await _readJson(examFile);
    final courses = <Course>[];
    for (final file in ContentParser.courseFiles(examJson)) {
      courses.add(ContentParser.course(await _readJson(file), path: file));
    }
    return _Content(
      exam: ContentParser.examPattern(examJson),
      courses: List.unmodifiable(courses),
      diagnostic: List.unmodifiable(ContentParser.diagnostic(await _readJson(diagnosticFile))),
    );
  }

  Future<Map<String, dynamic>> _readJson(String path) async =>
      jsonDecode(await _load(path)) as Map<String, dynamic>;

  @override
  Future<ExamPattern> getExamPattern() async => (await _loaded).exam;

  @override
  Future<List<Course>> getCourses() async => (await _loaded).courses;

  @override
  Future<Course?> getCourse(String courseId) async {
    for (final course in (await _loaded).courses) {
      if (course.id == courseId) return course;
    }
    return null;
  }

  @override
  Future<Lesson?> getLesson(String lessonId) async {
    for (final course in (await _loaded).courses) {
      for (final lesson in course.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  @override
  Future<List<AssessmentQuestion>> getDiagnosticQuestions() async => (await _loaded).diagnostic;

  @override
  Future<Topic?> getTopic(String topicId) async {
    for (final course in (await _loaded).courses) {
      for (final topic in course.topics) {
        if (topic.id == topicId) return topic;
      }
    }
    return null;
  }

  @override
  Future<List<AssessmentQuestion>> getQuestions(Iterable<String> questionIds) async {
    final byId = (await _loaded).questionsById;
    return [
      for (final id in questionIds)
        if (byId[id] != null) byId[id]!,
    ];
  }
}

class _Content {
  _Content({required this.exam, required this.courses, required this.diagnostic})
      : questionsById = _indexQuestions(courses);

  final ExamPattern exam;
  final List<Course> courses;
  final List<AssessmentQuestion> diagnostic;

  /// Every lesson and checkpoint question, by id, tagged with its section.
  final Map<String, AssessmentQuestion> questionsById;

  static Map<String, AssessmentQuestion> _indexQuestions(List<Course> courses) {
    final byId = <String, AssessmentQuestion>{};
    for (final course in courses) {
      for (final topic in course.topics) {
        for (final lesson in topic.lessons) {
          for (final activity in lesson.activities.whereType<QuestionActivity>()) {
            byId[activity.id] = AssessmentQuestion(sectionId: course.sectionId, activity: activity);
          }
        }
        for (final question in topic.checkpoint?.questions ?? const <AssessmentQuestion>[]) {
          byId[question.activity.id] = question;
        }
      }
    }
    return byId;
  }
}
