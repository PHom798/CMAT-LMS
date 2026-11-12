import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/multiple_choice_question.dart';

/// Turns content JSON (see docs/CONTENT.md) into domain objects.
///
/// Every error names the exact place in the file, e.g.
/// `lessons[0].activities[3].correctIndex: is out of range`, so content
/// writers can fix mistakes without reading Dart.
abstract final class ContentParser {
  static ExamPattern examPattern(Map<String, dynamic> json) {
    final r = _Reader(json, 'exam');
    return ExamPattern(
      id: r.string('id'),
      title: r.string('title'),
      fullTitle: r.string('fullTitle'),
      conductedBy: r.string('conductedBy'),
      durationMinutes: r.integer('durationMinutes'),
      totalQuestions: r.integer('totalQuestions'),
      passPercent: r.integer('passPercent'),
      negativeMarking: r.boolean('negativeMarking'),
      sections: [
        for (final (i, section) in r.objects('sections').indexed)
          _section(_Reader(section, 'sections[$i]')),
      ],
    );
  }

  /// Asset paths of the course files listed in the exam file, in order.
  static List<String> courseFiles(Map<String, dynamic> examJson) {
    final r = _Reader(examJson, 'exam');
    return [
      for (final (i, section) in r.objects('sections').indexed)
        _Reader(section, 'sections[$i]').string('courseFile'),
    ];
  }

  static ExamSection _section(_Reader r) => ExamSection(
        id: r.string('id'),
        title: r.string('title'),
        shortLabel: r.string('shortLabel'),
        description: r.string('description'),
        questionCount: r.integer('questionCount'),
        iconKey: r.string('icon'),
      );

  static Course course(Map<String, dynamic> json, {String path = 'course'}) {
    final r = _Reader(json, path);
    final courseId = r.string('id');
    final sectionId = r.string('sectionId');
    return Course(
      id: courseId,
      sectionId: sectionId,
      title: r.string('title'),
      description: r.string('description'),
      iconKey: r.string('icon'),
      topics: [
        for (final (i, topic) in r.objects('topics').indexed)
          _topic(_Reader(topic, '$path.topics[$i]'), courseId, sectionId),
      ],
    );
  }

  static Topic _topic(_Reader r, String courseId, String sectionId) {
    final topicId = r.string('id');
    final checkpointJson = r.optionalObject('checkpoint');
    return Topic(
      id: topicId,
      courseId: courseId,
      title: r.string('title'),
      description: r.string('description'),
      lessons: [
        for (final (i, lesson) in r.objects('lessons').indexed)
          _lesson(_Reader(lesson, '${r.path}.lessons[$i]'), courseId),
      ],
      checkpoint: checkpointJson == null
          ? null
          : _checkpoint(_Reader(checkpointJson, '${r.path}.checkpoint'), topicId, sectionId),
    );
  }
  static Lesson _lesson(_Reader r, String courseId) {
    final activities = [
      for (final (i, activity) in r.objects('activities').indexed)
        activityFrom(activity, path: '${r.path}.activities[$i]'),
    ];
    if (activities.isEmpty) {
      throw FormatException('${r.path}.activities: must not be empty');
    }
    return Lesson(
      id: r.string('id'),
      courseId: courseId,
      title: r.string('title'),
      estimatedMinutes: r.integer('estimatedMinutes'),
      activities: activities, objective: '',
    );
  }

  static Checkpoint _checkpoint(_Reader r, String topicId, String sectionId) {
    final questions = [
      for (final (i, question) in r.objects('questions').indexed)
        _question(question, '${r.path}.questions[$i]', sectionId),
    ];
    if (questions.isEmpty) throw FormatException('${r.path}.questions: must not be empty');
    return Checkpoint(topicId: topicId, passPercent: r.integer('passPercent'), questions: questions);
  }

  static List<AssessmentQuestion> diagnostic(Map<String, dynamic> json) {
    final r = _Reader(json, 'diagnostic');
    return [
      for (final (i, question) in r.objects('questions').indexed)
        _assessmentQuestion(question, 'diagnostic.questions[$i]'),
    ];
  }

  static AssessmentQuestion _assessmentQuestion(Map<String, dynamic> json, String path) =>
      _question(json, path, _Reader(json, path).string('sectionId'));

  static AssessmentQuestion _question(Map<String, dynamic> json, String path, String sectionId) {
    final activity = activityFrom(json, path: path);
    if (activity is! QuestionActivity) {
      throw FormatException('$path.type: must be a question, not a concept');
    }
    return AssessmentQuestion(sectionId: sectionId, activity: activity);
  }

  static LessonActivity activityFrom(Map<String, dynamic> json, {required String path}) {
    final r = _Reader(json, path);
    final type = r.string('type');
    switch (type) {
      case 'concept':
        return ConceptActivity(
          title: r.string('title'),
          body: r.string('body'),
          example: r.optionalString('example'),
          exampleLabel: r.optionalString('exampleLabel'),
          exampleIsCode: r.optionalBool('exampleIsCode') ?? false,
        );
      case 'multipleChoice':
        final options = r.strings('options');
        return MultipleChoiceActivity(
          MultipleChoiceQuestion(
            id: r.string('id'),
            prompt: r.string('prompt'),
            options: options,
            correctIndex: r.index('correctIndex', options.length),
            explanation: r.string('explanation'),
            hint: r.optionalString('hint'),
            snippet: r.optionalString('snippet'),
            snippetLabel: r.optionalString('snippetLabel'),
            snippetIsCode: r.optionalBool('snippetIsCode') ?? false,
            optionsAreCode: r.optionalBool('optionsAreCode') ?? false,
          ),
        );
      case 'fillInBlank':
        final choices = r.strings('choices');
        return FillInBlankActivity(
          id: r.string('id'),
          prompt: r.string('prompt'),
          textBefore: r.string('textBefore', allowEmpty: true),
          textAfter: r.string('textAfter', allowEmpty: true),
          choices: choices,
          correctIndex: r.index('correctIndex', choices.length),
          explanation: r.string('explanation'),
          hint: r.optionalString('hint'),
          label: r.optionalString('label'),
          isCode: r.optionalBool('isCode') ?? false,
        );
      default:
        throw FormatException('$path.type: unknown activity type "$type"');
    }
  }
}

/// Small typed reader with precise error messages.
class _Reader {
  _Reader(this.json, this.path);

  final Map<String, dynamic> json;
  final String path;

  Never _fail(String key, String problem) => throw FormatException('$path.$key: $problem');

  String string(String key, {bool allowEmpty = false}) {
    final value = json[key];
    if (value is! String) _fail(key, 'must be text');
    if (!allowEmpty && value.trim().isEmpty) _fail(key, 'must not be empty');
    return value;
  }

  String? optionalString(String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is! String) _fail(key, 'must be text');
    return value;
  }

  int integer(String key) {
    final value = json[key];
    if (value is! int) _fail(key, 'must be a whole number');
    return value;
  }

  int index(String key, int length) {
    final value = integer(key);
    if (value < 0 || value >= length) _fail(key, 'is out of range (0 to ${length - 1})');
    return value;
  }

  bool boolean(String key) {
    final value = json[key];
    if (value is! bool) _fail(key, 'must be true or false');
    return value;
  }

  bool? optionalBool(String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is! bool) _fail(key, 'must be true or false');
    return value;
  }

  List<String> strings(String key) {
    final value = json[key];
    if (value is! List || value.length < 2 || value.any((e) => e is! String)) {
      _fail(key, 'must be a list of at least two texts');
    }
    return List<String>.unmodifiable(value);
  }

  Map<String, dynamic>? optionalObject(String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is! Map<String, dynamic>) _fail(key, 'must be an object');
    return value;
  }

  List<Map<String, dynamic>> objects(String key) {
    final value = json[key];
    if (value is! List || value.any((e) => e is! Map<String, dynamic>)) {
      _fail(key, 'must be a list of objects');
    }
    return value.cast<Map<String, dynamic>>();
  }
}
