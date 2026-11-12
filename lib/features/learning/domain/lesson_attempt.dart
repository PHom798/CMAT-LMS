import 'package:flutter/foundation.dart';

/// A finished lesson. Attempts are append-only history: XP, streaks, quests
/// and course progress are all calculated from them (see ProgressCalculator),
/// so there is a single source of truth and nothing to keep in sync.
@immutable
class LessonAttempt {
  const LessonAttempt({
    required this.lessonId,
    required this.courseId,
    required this.completedAt,
    required this.questionCount,
    required this.firstTryCorrect,
    required this.xpEarned,
    required this.duration,
    required this.estimatedMinutes,
  });

  final String lessonId;
  final String courseId;
  final DateTime completedAt;
  final int questionCount;

  /// Questions answered correctly on the first try.
  final int firstTryCorrect;
  final int xpEarned;

  /// Real time spent in the lesson.
  final Duration duration;

  /// The lesson's estimated length when completed; counts toward the daily goal.
  final int estimatedMinutes;

  bool get isPerfect => questionCount > 0 && firstTryCorrect == questionCount;

  @override
  bool operator ==(Object other) =>
      other is LessonAttempt &&
      other.lessonId == lessonId &&
      other.courseId == courseId &&
      other.completedAt == completedAt &&
      other.questionCount == questionCount &&
      other.firstTryCorrect == firstTryCorrect &&
      other.xpEarned == xpEarned &&
      other.duration == duration &&
      other.estimatedMinutes == estimatedMinutes;

  @override
  int get hashCode => Object.hash(lessonId, courseId, completedAt, questionCount,
      firstTryCorrect, xpEarned, duration, estimatedMinutes);
}
