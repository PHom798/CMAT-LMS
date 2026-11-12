import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_progress_record.dart';
import 'package:w3_lms/features/onboarding/domain/diagnostic_status.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_draft.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_progress.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';

extension OnboardingProgressRecordMapper on OnboardingProgressRecord {
  /// Unknown keys (e.g. from an older app version) are dropped, never thrown.
  OnboardingProgress toDomain() {
    var status = DiagnosticStatus.fromName(diagnosticStatusName);
    final result = DiagnosticResult.fromColumns(diagnosticSectionIds, diagnosticCorrect, diagnosticTotals);
    // A "completed" diagnostic without scores can't be trusted: retake it.
    if (status == DiagnosticStatus.completed && result == null) status = DiagnosticStatus.notTaken;

    return OnboardingProgress(
      currentStep: OnboardingStep.fromName(currentStepName),
      isCompleted: isCompleted,
      draft: OnboardingDraft(
        name: name,
        examTimeframe: ExamTimeframe.fromKey(examTimeframeKey),
        dailyGoal: DailyGoal.fromMinutes(dailyGoalMinutes),
        diagnosticStatus: status,
        diagnosticResult: status == DiagnosticStatus.completed ? result : null,
        earnedXp: status == DiagnosticStatus.completed ? earnedXp : 0,
      ),
    );
  }
}

extension OnboardingProgressToRecord on OnboardingProgress {
  /// [existing] preserves fields the domain does not carry (completedAt).
  OnboardingProgressRecord toRecord({OnboardingProgressRecord? existing}) {
    final result = draft.diagnosticResult;
    return (existing ?? OnboardingProgressRecord())
      ..currentStepName = currentStep.name
      ..isCompleted = isCompleted
      ..name = draft.name
      ..examTimeframeKey = draft.examTimeframe?.key
      ..dailyGoalMinutes = draft.dailyGoal?.minutes
      ..diagnosticStatusName = draft.diagnosticStatus.name
      ..diagnosticSectionIds = result?.sectionIds ?? []
      ..diagnosticCorrect = result?.correctColumn ?? []
      ..diagnosticTotals = result?.totalColumn ?? []
      ..earnedXp = draft.earnedXp
      ..updatedAt = DateTime.now();
  }
}
