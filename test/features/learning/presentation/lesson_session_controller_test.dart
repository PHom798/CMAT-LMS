import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/domain/daily_quest.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/test_data.dart';

void main() {
  late FakeLearningProgressRepository progress;
  late FakeLearnerProfileRepository learner;
  late DateTime now;

  Future<LessonSessionController> createController({
    String lessonId = 'cmat-verbal-1',
    FakeLearningProgressRepository? history,
  }) async {
    progress = history ?? FakeLearningProgressRepository();
    learner = FakeLearnerProfileRepository()..profile = testProfile();
    now = testNow;
    final controller = LessonSessionController(
      lessonId: lessonId,
      contentRepository: testContentRepository(),
      progressRepository: progress,
      learnerProfileRepository: learner,
      clock: () => now,
    );
    await controller.load();
    return controller;
  }

  /// Plays to the end. Misses the first question once if [missFirst].
  Future<void> playThrough(LessonSessionController c, {bool missFirst = false}) async {
    var missed = false;
    while (c.phase == LessonPhase.playing) {
      final activity = c.run.current;
      if (activity is QuestionActivity) {
        final wrong = (activity.correctIndex + 1) % activity.choices.length;
        final pickWrong = missFirst && !missed;
        c.selectChoice(pickWrong ? wrong : activity.correctIndex);
        c.checkAnswer();
        missed = missed || pickWrong;
      }
      now = now.add(const Duration(seconds: 20));
      await c.advance();
    }
  }

  test('loads the lesson into the intro phase', () async {
    final c = await createController();
    expect(c.phase, LessonPhase.intro);
    expect(c.lesson.title, 'Subject-verb agreement');
    expect(c.isReplay, isFalse);
    expect(c.maxXp, 21);
  });

  test('unknown lesson id shows the unavailable state', () async {
    final c = await createController(lessonId: 'nope');
    expect(c.phase, LessonPhase.unavailable);
  });

  test('check is disabled until a choice is selected', () async {
    final c = await createController()..start();
    while (c.run.current is! QuestionActivity) {
      await c.advance();
    }
    expect(c.primaryAction, LessonPrimaryAction.check);
    expect(c.canPerformPrimaryAction, isFalse);
    c.selectChoice(0);
    expect(c.canPerformPrimaryAction, isTrue);
  });

  test('a perfect run saves the attempt and reports what it unlocked', () async {
    final c = await createController()..start();
    await playThrough(c);

    expect(c.phase, LessonPhase.complete);
    expect(progress.history.attempts, hasLength(1));
    final attempt = progress.history.attempts.single;
    expect(progress.history.answers, hasLength(3), reason: 'one first-try answer per question');
    expect(progress.history.answers.every((a) => a.isCorrect), isTrue);
    expect(attempt.lessonId, 'cmat-verbal-1');
    expect(attempt.firstTryCorrect, 3);
    expect(attempt.xpEarned, 21);
    expect(attempt.duration, greaterThan(Duration.zero));

    final completion = c.completion!;
    expect(completion.totalXpGained, 81, reason: '21 lesson + 10 quest + 50 achievements');
    expect(completion.questsCompletedNow.map((q) => q.type), [DailyQuestType.completeLesson]);
    expect(
      completion.achievementsUnlockedNow.map((a) => a.id),
      containsAll(['first_lesson', 'perfect_lesson', 'section_master:verbal']),
    );
    expect(completion.startedStreakToday, isTrue);
  });

  test('a wrong answer is retried and costs only its first-try XP', () async {
    final c = await createController()..start();
    await playThrough(c, missFirst: true);

    final attempt = progress.history.attempts.single;
    expect(attempt.firstTryCorrect, 2);
    expect(progress.history.answers.where((a) => !a.isCorrect), hasLength(1));
    expect(attempt.xpEarned, 14, reason: '10 + 2×2, no perfect bonus');
    expect(c.wrongAnswers, 1);
  });

  test('replaying a finished lesson earns half XP', () async {
    final c = await createController(
      history: FakeLearningProgressRepository(LearningHistory(attempts: [testAttempt()])),
    );
    expect(c.isReplay, isTrue);
    c.start();
    await playThrough(c);
    expect(progress.history.attempts.last.xpEarned, 10);
  });

  test('a failed save can be retried without losing the result', () async {
    final c = await createController()..start();
    progress.failWrites = true;
    await playThrough(c);
    expect(c.phase, LessonPhase.saveFailed);
    expect(c.primaryAction, LessonPrimaryAction.retrySave);

    progress.failWrites = false;
    await c.retrySave();
    expect(c.phase, LessonPhase.complete);
    expect(progress.history.attempts, hasLength(1));
  });

  test('exit needs confirmation only while playing', () async {
    final c = await createController();
    expect(c.shouldConfirmExit, isFalse);
    c.start();
    expect(c.shouldConfirmExit, isTrue);
    expect(c.run.status, AnswerStatus.unanswered);
  });
}
