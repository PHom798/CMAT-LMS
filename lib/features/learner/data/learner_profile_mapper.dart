import 'package:w3_lms/features/learner/data/learner_profile_record.dart';
import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/learner/domain/learner_profile.dart';

/// Conversions between the storage record and the domain entity.
extension LearnerProfileRecordMapper on LearnerProfileRecord {
  /// Returns null if the stored data is incomplete or unrecognised, so a bad
  /// record sends the learner back through onboarding instead of crashing.
  LearnerProfile? toDomain() {
    final timeframe = ExamTimeframe.fromKey(examTimeframeKey);
    final daily = DailyGoal.fromMinutes(dailyGoalMinutes);
    if (timeframe == null || daily == null || name.trim().isEmpty) return null;
    return LearnerProfile(
      name: name,
      examTimeframe: timeframe,
      dailyGoal: daily,
      onboardingXp: onboardingXp,
      diagnostic: DiagnosticResult.fromColumns(diagnosticSectionIds, diagnosticCorrect, diagnosticTotals),
    );
  }
}

extension LearnerProfileToRecord on LearnerProfile {
  /// [existing] keeps fields that are not part of the domain (e.g. createdAt).
  LearnerProfileRecord toRecord({LearnerProfileRecord? existing}) {
    return (existing ?? LearnerProfileRecord())
      ..name = name
      ..examTimeframeKey = examTimeframe.key
      ..dailyGoalMinutes = dailyGoal.minutes
      ..onboardingXp = onboardingXp
      ..diagnosticSectionIds = diagnostic?.sectionIds ?? []
      ..diagnosticCorrect = diagnostic?.correctColumn ?? []
      ..diagnosticTotals = diagnostic?.totalColumn ?? []
      ..updatedAt = DateTime.now();
  }
}
