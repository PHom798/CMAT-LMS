import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';

/// Who the learner is and what they want. Always complete: it only exists
/// once onboarding has collected every answer.
///
/// This is the app-level entity other features (dashboard, lessons) read.
/// They depend on this file, never on the onboarding feature.
@immutable
class LearnerProfile {
  const LearnerProfile({
    required this.name,
    required this.examTimeframe,
    required this.dailyGoal,
    required this.onboardingXp,
    this.diagnostic,
  });

  final String name;
  final ExamTimeframe examTimeframe;
  final DailyGoal dailyGoal;

  /// XP earned in the onboarding diagnostic. Lifetime XP is calculated from
  /// this plus lesson history (see ProgressCalculator), never stored.
  final int onboardingXp;

  /// Baseline per exam section, or null if the learner skipped the diagnostic.
  final DiagnosticResult? diagnostic;

  @override
  bool operator ==(Object other) =>
      other is LearnerProfile &&
      other.name == name &&
      other.examTimeframe == examTimeframe &&
      other.dailyGoal == dailyGoal &&
      other.onboardingXp == onboardingXp &&
      other.diagnostic == diagnostic;

  @override
  int get hashCode => Object.hash(name, examTimeframe, dailyGoal, onboardingXp, diagnostic);
}
