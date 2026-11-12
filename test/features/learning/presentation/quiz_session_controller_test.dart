import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/quiz_request.dart';
import 'package:w3_lms/features/learning/presentation/state/quiz_session_controller.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/test_data.dart';

void main() {
  late FakeLearningProgressRepository progress;

  Future<QuizSessionController> createController(QuizRequest request, {LearningHistory? history}) async {
    progress = FakeLearningProgressRepository(history);
    final c = QuizSessionController(
      request: request,
      contentRepository: testContentRepository(),
      progressRepository: progress,
      clock: () => testNow,
    );
    await c.load();
    return c;
  }

  /// Answers every question; gets the first [wrong] questions wrong.
  Future<void> play(QuizSessionController c, {int wrong = 0}) async {
    c.start();
    var i = 0;
    while (c.phase == QuizPhase.playing) {
      final question = c.run.current.activity;
      final wrongChoice = (question.correctIndex + 1) % question.choices.length;
      c.selectChoice(i < wrong ? wrongChoice : question.correctIndex);
      c.checkAnswer();
      await c.next();
      i++;
    }
  }

  group('checkpoint', () {
    const request = CheckpointQuiz('quant-percentages');

    test('passing masters the topic and earns XP the first time only', () async {
      final c = await createController(request);
      expect(c.phase, QuizPhase.intro);
      expect(c.checkpoint!.passMark, 2);

      await play(c, wrong: 1);
      expect(c.phase, QuizPhase.complete);
      expect(c.outcome!.passed, isTrue);
      expect(c.outcome!.isNewlyMastered, isTrue);
      expect(c.outcome!.xpEarned, PracticeScoring.checkpointPassXp);
      expect(progress.history.passedTopicIds, contains('quant-percentages'));
      expect(progress.history.answers, hasLength(3));

      // A retake after passing is practice: no extra XP.
      await play(c);
      expect(c.outcome!.isNewlyMastered, isFalse);
      expect(c.outcome!.xpEarned, 0);
    });

    test('failing offers a retake and saves the mistakes', () async {
      final c = await createController(request);
      await play(c, wrong: 2);
      expect(c.outcome!.passed, isFalse);
      expect(c.primaryAction, QuizPrimaryAction.retake);
      expect(progress.history.mistakeQuestionIds, hasLength(2));
      expect(progress.history.passedTopicIds, isEmpty);
    });

    test('an unknown topic is unavailable', () async {
      final c = await createController(const CheckpointQuiz('missing'));
      expect(c.phase, QuizPhase.unavailable);
    });
  });

  group('mistake review', () {
    test('with no mistakes there is nothing to review', () async {
      final c = await createController(const MistakeReviewQuiz());
      expect(c.phase, QuizPhase.unavailable);
    });

    test('fixing mistakes removes them and earns XP', () async {
      final history = LearningHistory(
        answers: [
          AnswerEntry(questionId: 'quant-percentages-q1', isCorrect: false, answeredAt: testNow, source: AnswerSource.lesson),
          AnswerEntry(questionId: 'logical-series-q2', isCorrect: false, answeredAt: testNow, source: AnswerSource.lesson),
        ],
      );
      final c = await createController(const MistakeReviewQuiz(), history: history);
      expect(c.questionCount, 2);

      await play(c);
      expect(c.outcome!.correct, 2);
      expect(c.outcome!.xpEarned, 2 * PracticeScoring.reviewFixXp);
      expect(progress.history.mistakeQuestionIds, isEmpty);
    });
  });
}
