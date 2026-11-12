import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/data/content_parser.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';

import '../../../helpers/test_data.dart';

/// Guards the hand-written JSON content. Run after editing any content file.
void main() {
  final repository = testContentRepository();

  test('exam pattern matches the official CMAT structure', () async {
    final exam = await repository.getExamPattern();
    expect(exam.sections, hasLength(4));
    expect(exam.durationMinutes, 90);
    expect(exam.passPercent, 40);
    expect(exam.negativeMarking, isFalse);
    expect(exam.sections.fold(0, (sum, s) => sum + s.questionCount), exam.totalQuestions);
  });

  test('one course per section, in exam order', () async {
    final exam = await repository.getExamPattern();
    final courses = await repository.getCourses();
    expect(courses.map((c) => c.sectionId), exam.sections.map((s) => s.id));
  });

  test('ids are unique and every lesson has questions', () async {
    final courses = await repository.getCourses();
    final courseIds = courses.map((c) => c.id).toList();
    expect(courseIds.toSet(), hasLength(courseIds.length));
    final lessons = courses.expand((c) => c.lessons).toList();
    final lessonIds = lessons.map((l) => l.id).toList();
    expect(lessonIds.toSet(), hasLength(lessonIds.length));

    for (final course in courses) {
      for (final lesson in course.lessons) {
        expect(lesson.courseId, course.id, reason: lesson.id);
        expect(lesson.questionCount, greaterThan(0), reason: lesson.id);
        for (final question in lesson.activities.whereType<QuestionActivity>()) {
          expect(question.choices.toSet(), hasLength(question.choices.length),
              reason: '${lesson.id}: duplicate choices');
        }
      }
    }
    expect(await repository.getLesson(lessonIds.first), isNotNull);
    expect(await repository.getLesson('missing'), isNull);
  });

  test('the syllabus map has topics; available ones have a checkpoint', () async {
    final courses = await repository.getCourses();
    final topics = courses.expand((c) => c.topics).toList();
    expect(topics.map((t) => t.id).toSet(), hasLength(topics.length), reason: 'topic ids are unique');
    expect(topics.where((t) => t.isAvailable), isNotEmpty);
    for (final topic in topics.where((t) => t.isAvailable)) {
      final checkpoint = topic.checkpoint;
      expect(checkpoint, isNotNull, reason: topic.id);
      expect(checkpoint!.passMark, inInclusiveRange(1, checkpoint.questions.length), reason: topic.id);
      expect(await repository.getTopic(topic.id), same(topic));
    }
  });

  test('every question id is unique and can be looked up', () async {
    final courses = await repository.getCourses();
    final ids = [
      for (final course in courses)
        for (final topic in course.topics) ...topic.questionIds,
      for (final q in await repository.getDiagnosticQuestions()) q.activity.id,
    ];
    expect(ids.toSet(), hasLength(ids.length));
    final lessonAndCheckpointIds = [
      for (final course in courses)
        for (final topic in course.topics) ...topic.questionIds,
    ];
    final found = await repository.getQuestions([...lessonAndCheckpointIds, 'missing']);
    expect(found, hasLength(lessonAndCheckpointIds.length));
  });

  test('diagnostic covers every section equally', () async {
    final exam = await repository.getExamPattern();
    final questions = await repository.getDiagnosticQuestions();
    expect(questions, isNotEmpty);
    final perSection = questions.length ~/ exam.sections.length;
    for (final section in exam.sections) {
      expect(questions.where((q) => q.sectionId == section.id), hasLength(perSection), reason: section.id);
    }
  });

  test('parser errors point at the exact field', () {
    expect(
      () => ContentParser.activityFrom(
        {
          'id': 'q1',
          'type': 'multipleChoice',
          'prompt': 'Q',
          'options': ['a', 'b'],
          'correctIndex': 5,
          'explanation': 'e',
        },
        path: 'lessons[0].activities[2]',
      ),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('lessons[0].activities[2].correctIndex'),
        ),
      ),
    );
  });
}
