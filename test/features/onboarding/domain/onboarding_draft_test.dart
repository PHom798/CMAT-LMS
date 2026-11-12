import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/onboarding/domain/diagnostic_status.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_draft.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';

import '../../../helpers/test_data.dart';

void main() {
  const answered = OnboardingDraft(
    name: 'Hom',
    examTimeframe: ExamTimeframe.oneToThreeMonths,
    dailyGoal: DailyGoal.serious,
  );

  test('firstName trims and takes the first word', () {
    expect(const OnboardingDraft(name: '  Hom Bahadur ').firstName, 'Hom');
    expect(const OnboardingDraft(name: '   ').firstName, '');
  });

  test('step requirements', () {
    const empty = OnboardingDraft();
    expect(empty.hasAnswered(OnboardingStep.welcome), isTrue);
    expect(empty.hasAnswered(OnboardingStep.name), isFalse);
    expect(empty.hasAnswered(OnboardingStep.examTimeframe), isFalse);
    expect(empty.hasAnswered(OnboardingStep.diagnostic), isFalse);
    expect(empty.hasAnswered(OnboardingStep.dailyGoal), isFalse);
    expect(empty.withDiagnosticSkipped().hasAnswered(OnboardingStep.diagnostic), isTrue);
  });

  test('completing the diagnostic stores the result and its XP', () {
    final draft = answered.withDiagnosticCompleted(weakInQuant);
    expect(draft.diagnosticStatus, DiagnosticStatus.completed);
    expect(draft.diagnosticResult!.weakest!.sectionId, 'quant');
    expect(draft.earnedXp, DiagnosticScoring.xpFor(5));
  });

  test('skipping clears any result and XP', () {
    final draft = answered.withDiagnosticCompleted(weakInQuant).withDiagnosticSkipped();
    expect(draft.diagnosticResult, isNull);
    expect(draft.earnedXp, 0);
  });

  test('toLearnerProfile requires a complete draft', () {
    expect(() => answered.toLearnerProfile(), throwsStateError, reason: 'diagnostic not done');

    final profile = answered.withDiagnosticCompleted(weakInQuant).toLearnerProfile();
    expect(profile.name, 'Hom');
    expect(profile.examTimeframe, ExamTimeframe.oneToThreeMonths);
    expect(profile.diagnostic, weakInQuant);
    expect(profile.onboardingXp, DiagnosticScoring.xpFor(5));
  });
}
