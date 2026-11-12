import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/onboarding/domain/diagnostic_status.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_draft.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_progress.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/test_data.dart';

void main() {
  late FakeOnboardingRepository onboardingRepository;
  late FakeLearnerProfileRepository learnerRepository;
  late OnboardingController controller;

  Future<OnboardingController> createController({OnboardingProgress? saved, bool failReads = false}) async {
    onboardingRepository = FakeOnboardingRepository(initial: saved, failReads: failReads);
    learnerRepository = FakeLearnerProfileRepository();
    final c = OnboardingController(
      onboardingRepository: onboardingRepository,
      learnerProfileRepository: learnerRepository,
      contentRepository: testContentRepository(),
    );
    await c.restore();
    return c;
  }

  /// Answers the diagnostic. [missSection] gets every question wrong there.
  void playDiagnostic({String? missSection}) {
    controller.startDiagnostic();
    while (controller.diagnosticPhase == DiagnosticPhase.running) {
      final run = controller.diagnosticRun!;
      final question = run.current;
      final wrong = (question.activity.correctIndex + 1) % question.activity.choices.length;
      controller.selectDiagnosticAnswer(
        question.sectionId == missSection ? wrong : question.activity.correctIndex,
      );
      controller.checkDiagnosticAnswer();
      controller.nextDiagnosticQuestion();
    }
  }

  /// Walks to [target] with valid answers. Skips the diagnostic unless [takeDiagnostic].
  Future<void> advanceTo(OnboardingStep target, {bool takeDiagnostic = false}) async {
    while (controller.step != target) {
      switch (controller.step) {
        case OnboardingStep.name:
          controller.updateName('Hom');
        case OnboardingStep.examTimeframe:
          controller.selectExamTimeframe(ExamTimeframe.oneToThreeMonths);
        case OnboardingStep.diagnostic:
          if (takeDiagnostic) {
            playDiagnostic(missSection: 'quant');
          } else {
            controller.skipDiagnostic();
            continue; // skipping already moved on
          }
        case OnboardingStep.dailyGoal:
          controller.selectDailyGoal(DailyGoal.serious);
        case OnboardingStep.welcome || OnboardingStep.ready:
          break;
      }
      controller.goNext();
    }
    await controller.saveCheckpoint();
  }

  group('restore', () {
    test('fresh install starts at welcome with content loaded', () async {
      controller = await createController();
      expect(controller.loadStatus, OnboardingLoadStatus.ready);
      expect(controller.step, OnboardingStep.welcome);
      expect(controller.exam.title, 'CMAT');
      expect(controller.diagnosticQuestionCount, 8);
    });

    test('resumes at the saved step with saved answers', () async {
      controller = await createController(
        saved: const OnboardingProgress(
          currentStep: OnboardingStep.diagnostic,
          draft: OnboardingDraft(name: 'Hom', examTimeframe: ExamTimeframe.notSure),
        ),
      );
      expect(controller.step, OnboardingStep.diagnostic);
      expect(controller.diagnosticPhase, DiagnosticPhase.intro);
      expect(controller.draft.firstName, 'Hom');
    });

    test('falls back to the first unanswered step if data is missing', () async {
      controller = await createController(
        saved: const OnboardingProgress(
          currentStep: OnboardingStep.ready,
          draft: OnboardingDraft(name: 'Hom'),
        ),
      );
      expect(controller.step, OnboardingStep.examTimeframe);
    });

    test('storage failure exposes the failure state', () async {
      controller = await createController(failReads: true);
      expect(controller.loadStatus, OnboardingLoadStatus.failure);
    });
  });

  group('navigation', () {
    setUp(() async => controller = await createController());

    test('cannot leave a step until it is answered', () {
      controller.goNext(); // welcome -> name
      expect(controller.canPerformPrimaryAction, isFalse);
      controller.goNext();
      expect(controller.step, OnboardingStep.name);

      controller.updateName('Hom');
      controller.goNext();
      expect(controller.step, OnboardingStep.examTimeframe);
      controller.goNext();
      expect(controller.step, OnboardingStep.examTimeframe);
    });

    test('back keeps answers; going back mid-diagnostic restarts it', () async {
      await advanceTo(OnboardingStep.diagnostic);
      controller.startDiagnostic();
      expect(controller.diagnosticPhase, DiagnosticPhase.running);

      controller.goBack();
      expect(controller.step, OnboardingStep.examTimeframe);
      expect(controller.draft.examTimeframe, ExamTimeframe.oneToThreeMonths);

      controller.goNext();
      expect(controller.diagnosticPhase, DiagnosticPhase.intro);
    });
  });

  group('diagnostic', () {
    setUp(() async {
      controller = await createController();
      await advanceTo(OnboardingStep.diagnostic);
    });

    test('primary action walks start -> check -> next question', () {
      expect(controller.primaryAction, OnboardingPrimaryAction.startDiagnostic);
      expect(controller.canSkipDiagnostic, isTrue);

      controller.startDiagnostic();
      expect(controller.primaryAction, OnboardingPrimaryAction.checkAnswer);
      expect(controller.canPerformPrimaryAction, isFalse);
      expect(controller.canSkipDiagnostic, isFalse);

      controller.selectDiagnosticAnswer(0);
      expect(controller.canPerformPrimaryAction, isTrue);
      controller.checkDiagnosticAnswer();
      expect(controller.primaryAction, OnboardingPrimaryAction.nextQuestion);
    });

    test('a finished diagnostic scores each section and picks the weakest', () {
      final ticks = controller.celebrationTick;
      playDiagnostic(missSection: 'quant');

      expect(controller.diagnosticPhase, DiagnosticPhase.done);
      final result = controller.draft.diagnosticResult!;
      expect(result.correct, 6);
      expect(result.scoreFor('quant')!.correct, 0);
      expect(controller.focusSection.id, 'quant');
      expect(controller.focusCourse!.id, 'cmat-quant');
      expect(controller.draft.earnedXp, DiagnosticScoring.xpFor(6));
      expect(controller.celebrationTick, ticks + 1);
      expect(controller.wrongAnswers, 2);
    });

    test('skipping moves on with no result and no XP', () {
      controller.skipDiagnostic();
      expect(controller.step, OnboardingStep.dailyGoal);
      expect(controller.draft.diagnosticStatus, DiagnosticStatus.skipped);
      expect(controller.draft.earnedXp, 0);
      expect(controller.focusSection.id, 'verbal', reason: 'starts from the first section');
    });
  });

  group('completion', () {
    setUp(() async => controller = await createController());

    test('saves the learner profile and marks onboarding completed', () async {
      await advanceTo(OnboardingStep.ready, takeDiagnostic: true);
      expect(controller.primaryAction, OnboardingPrimaryAction.finish);

      final saved = await controller.completeOnboarding();

      expect(saved, isTrue);
      expect(await onboardingRepository.isCompleted(), isTrue);
      final profile = learnerRepository.profile!;
      expect(profile.name, 'Hom');
      expect(profile.examTimeframe, ExamTimeframe.oneToThreeMonths);
      expect(profile.dailyGoal, DailyGoal.serious);
      expect(profile.diagnostic!.weakest!.sectionId, 'quant');
      expect(profile.onboardingXp, DiagnosticScoring.xpFor(6));
    });

    test('a failed save reports false and does not mark completion', () async {
      await advanceTo(OnboardingStep.ready);
      learnerRepository.failWrites = true;

      expect(await controller.completeOnboarding(), isFalse);
      expect(await onboardingRepository.isCompleted(), isFalse);
      expect(controller.isCompleting, isFalse);
    });
  });

  test('checking without a selection does nothing', () async {
    controller = await createController();
    await advanceTo(OnboardingStep.diagnostic);
    controller.startDiagnostic();
    expect(controller.checkDiagnosticAnswer(), AnswerStatus.unanswered);
  });
}
