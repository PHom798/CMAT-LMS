import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/domain/multiple_choice_question.dart';

void main() {
  const lesson = Lesson(
    id: 'test-1',
    courseId: 'test',
    title: 'Test',
    objective: 'Test',
    estimatedMinutes: 3,
    activities: [
      ConceptActivity(title: 'Idea', body: 'Body'),
      MultipleChoiceActivity(
        MultipleChoiceQuestion(id: 'q1', prompt: 'Q', options: ['a', 'b', 'c'], correctIndex: 1, explanation: 'e'),
      ),
      FillInBlankActivity(
        id: 'q2',
        prompt: 'Fill',
        textBefore: 'She ',
        textAfter: ' home.',
        choices: ['p', 'x'],
        correctIndex: 0,
        explanation: 'e',
      ),
    ],
  );

  test('concepts advance without an answer; questions need a check first', () {
    final run = LessonRun(lesson);
    expect(run.canCheck, isFalse);
    expect(run.canAdvance, isTrue);
    run.advance();

    expect(run.current, isA<MultipleChoiceActivity>());
    expect(run.canAdvance, isFalse);
    run.select(1);
    expect(run.canCheck, isTrue);
  });

  test('a missed question returns at the end and only first tries count', () {
    final run = LessonRun(lesson)..advance(); // past the concept
    expect(run.progress, closeTo(1 / 3, 0.001));

    run.select(0);
    expect(run.check(), AnswerStatus.incorrect);
    run.advance();
    expect(run.current, isA<FillInBlankActivity>(), reason: 'missed question moved to the back');
    expect(run.progress, closeTo(1 / 3, 0.001), reason: 'a miss does not add progress');

    run
      ..select(0)
      ..check()
      ..advance();
    expect(run.current, isA<MultipleChoiceActivity>());
    expect(run.isReview, isTrue);

    run
      ..select(1)
      ..check()
      ..advance();
    expect(run.isFinished, isTrue);
    expect(run.progress, 1);
    expect(run.questionCount, 2);
    expect(run.firstTryCorrect, 1);
    expect(run.firstTryResults, {'q1': false, 'q2': true});
  });

  test('answers are locked once checked', () {
    final run = LessonRun(lesson)
      ..advance()
      ..select(1)
      ..check();
    run.select(0);
    expect(run.selectedChoice, 1);
  });
}
