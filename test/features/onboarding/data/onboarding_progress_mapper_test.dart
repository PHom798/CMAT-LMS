import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_progress_mapper.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_progress_record.dart';
import 'package:w3_lms/features/onboarding/domain/diagnostic_status.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_draft.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_progress.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';

import '../../../helpers/test_data.dart';

void main() {
  test('round-trips a draft with a completed diagnostic', () {
    final progress = OnboardingProgress(
      currentStep: OnboardingStep.dailyGoal,
      draft: const OnboardingDraft(
        name: 'Hom',
        examTimeframe: ExamTimeframe.underOneMonth,
        dailyGoal: DailyGoal.casual,
      ).withDiagnosticCompleted(weakInQuant),
    );
    expect(progress.toRecord().toDomain(), progress);
  });

  test('an unknown saved step restarts at welcome', () {
    final record = OnboardingProgressRecord()..currentStepName = 'deleted_step';
    expect(record.toDomain().currentStep, OnboardingStep.welcome);
  });

  test('a "completed" diagnostic without scores is retaken', () {
    final record = OnboardingProgressRecord()
      ..diagnosticStatusName = 'completed'
      ..earnedXp = 21;
    final draft = record.toDomain().draft;
    expect(draft.diagnosticStatus, DiagnosticStatus.notTaken);
    expect(draft.earnedXp, 0);
  });
}
