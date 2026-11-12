import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/domain/multiple_choice_question.dart';

void main() {
  var counter = 0;
  AssessmentQuestion q(String section, int correct) => AssessmentQuestion(
        sectionId: section,
        activity: MultipleChoiceActivity(
          MultipleChoiceQuestion(
            id: 'q${counter++}',
            prompt: 'Q',
            options: const ['a', 'b', 'c'],
            correctIndex: correct,
            explanation: 'e',
          ),
        ),
      );

  test('each question is answered once, with no retry', () {
    final run = AssessmentRun([q('a', 0), q('b', 1)]);
    run.select(2);
    expect(run.check(), AnswerStatus.incorrect);
    run.select(0);
    expect(run.selectedChoice, 2, reason: 'locked after checking');
    run.advance();
    expect(run.index, 1);
    expect(run.isLastQuestion, isTrue);
  });

  test('scores per section in the requested order', () {
    final run = AssessmentRun([q('a', 0), q('b', 1), q('a', 2)]);
    for (final answer in [0, 0, 2]) {
      run
        ..select(answer)
        ..check()
        ..advance();
    }
    expect(run.isFinished, isTrue);
    expect(run.correctCount, 2);

    final result = run.result(['b', 'a']);
    expect(result.sections.map((s) => s.sectionId), ['b', 'a']);
    expect(result.scoreFor('a')!.correct, 2);
    expect(result.scoreFor('b')!.correct, 0);
    expect(result.weakest!.sectionId, 'b');
  });
}
