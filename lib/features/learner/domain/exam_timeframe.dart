import 'package:w3_lms/features/learner/domain/daily_goal.dart';

/// How far away the learner's exam is, picked during onboarding.
/// [key] is the stable identifier written to storage. Never change it.
enum ExamTimeframe {
  underOneMonth('under_1_month', 'Less than a month', 'Focus on high-impact practice', DailyGoal.intense),
  oneToThreeMonths('1_to_3_months', '1 to 3 months', 'Steady practice across every section', DailyGoal.serious),
  overThreeMonths('over_3_months', 'More than 3 months', 'Plenty of time to build strong basics', DailyGoal.regular),
  notSure('not_sure', 'Not sure yet', "We'll keep the pace comfortable", DailyGoal.regular);

  const ExamTimeframe(this.key, this.title, this.description, this.suggestedDailyGoal);

  final String key;
  final String title;
  final String description;

  /// Pre-highlighted on the daily goal step.
  final DailyGoal suggestedDailyGoal;

  static ExamTimeframe? fromKey(String? key) {
    for (final value in values) {
      if (value.key == key) return value;
    }
    return null;
  }
}
