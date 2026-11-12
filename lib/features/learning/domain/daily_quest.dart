import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

enum DailyQuestType { completeLesson, correctAnswers, dailyGoalMinutes }

/// A small goal that resets every day. Progress is calculated from that
/// day's lesson attempts, so quests need no storage of their own.
@immutable
class DailyQuest {
  const DailyQuest({
    required this.type,
    required this.title,
    required this.target,
    required this.progress,
    required this.rewardXp,
  });

  final DailyQuestType type;
  final String title;
  final int target;

  /// Clamped to [target].
  final int progress;
  final int rewardXp;

  bool get isComplete => progress >= target;
  double get fraction => target == 0 ? 1 : progress / target;

  static const lessonsTarget = 1;
  static const correctAnswersTarget = 6;

  /// Today's (or any day's) quests from that day's attempts.
  static List<DailyQuest> forDay({
    required List<LessonAttempt> dayAttempts,
    required DailyGoal dailyGoal,
  }) {
    final correct = dayAttempts.fold(0, (sum, a) => sum + a.firstTryCorrect);
    final minutes = dayAttempts.fold(0, (sum, a) => sum + a.estimatedMinutes);
    return [
      DailyQuest(
        type: DailyQuestType.completeLesson,
        title: 'Complete a lesson',
        target: lessonsTarget,
        progress: _clamp(dayAttempts.length, lessonsTarget),
        rewardXp: 10,
      ),
      DailyQuest(
        type: DailyQuestType.correctAnswers,
        title: 'Get $correctAnswersTarget answers right first try',
        target: correctAnswersTarget,
        progress: _clamp(correct, correctAnswersTarget),
        rewardXp: 10,
      ),
      DailyQuest(
        type: DailyQuestType.dailyGoalMinutes,
        title: 'Reach your ${dailyGoal.minutes}-minute goal',
        target: dailyGoal.minutes,
        progress: _clamp(minutes, dailyGoal.minutes),
        rewardXp: 15,
      ),
    ];
  }

  static int _clamp(int value, int max) => value > max ? max : value;
}
