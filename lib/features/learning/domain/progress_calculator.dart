import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/learning/domain/achievement.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/daily_quest.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learner_level.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

/// Turns raw lesson history into a [LearningSummary]. Pure and deterministic
/// ([now] is passed in), so every rule here is covered by unit tests.
///
/// Total XP = onboarding XP + lesson attempts + checkpoint passes + fixed
/// mistakes + daily quests completed on any day + earned achievements.
abstract final class ProgressCalculator {
  static LearningSummary summarize({
    required LearnerProfile profile,
    required List<Course> courses,
    required LearningHistory history,
    required DateTime now,
  }) {
    final attempts = history.attempts;
    final byDay = <DateTime, List<LessonAttempt>>{};
    for (final attempt in attempts) {
      byDay.putIfAbsent(dayOf(attempt.completedAt), () => []).add(attempt);
    }

    final lessonXp = attempts.fold(0, (sum, a) => sum + a.xpEarned);
    var questXp = 0;
    for (final dayAttempts in byDay.values) {
      for (final quest in DailyQuest.forDay(dayAttempts: dayAttempts, dailyGoal: profile.dailyGoal)) {
        if (quest.isComplete) questXp += quest.rewardXp;
      }
    }
    final activeDays = byDay.keys.toSet();
    final achievements = AchievementRules.evaluate(
      courses: courses,
      attempts: attempts,
      longestStreak: _longestStreak(activeDays),
      checkpointsPassed: history.passedTopicIds.length,
    );
    final achievementXp = [for (final a in achievements) if (a.isEarned) a.rewardXp].fold(0, (x, y) => x + y);
    final checkpointXp = history.checkpoints.fold(0, (sum, c) => sum + c.xpEarned);
    final reviewXp = history.answers
            .where((a) => a.source == AnswerSource.review && a.isCorrect)
            .length *
        PracticeScoring.reviewFixXp;
    final totalXp = profile.onboardingXp + lessonXp + checkpointXp + reviewXp + questXp + achievementXp;

    final completedIds = history.completedLessonIds;
    final courseProgress = [
      for (final course in courses)
        CourseProgress(journey: JourneyBuilder.build(course, history), completedLessonIds: completedIds),
    ];
    final knownQuestions = {
      for (final course in courses)
        for (final topic in course.topics) ...topic.questionIds,
    };

    final today = dayOf(now);
    return LearningSummary(
      totalXp: totalXp,
      level: LearnerLevel.fromXp(totalXp),
      streak: _streak(activeDays, today),
      completedLessonCount: courses
          .expand((c) => c.lessons)
          .where((lesson) => completedIds.contains(lesson.id))
          .length,
      courseProgress: courseProgress,
      todayQuests: DailyQuest.forDay(dayAttempts: byDay[today] ?? const [], dailyGoal: profile.dailyGoal),
      continueCourse: _continueCourse(courseProgress, attempts, profile),
      achievements: achievements,
      mistakeCount: history.mistakeQuestionIds.where(knownQuestions.contains).length,
      week: [
        for (var offset = 6; offset >= 0; offset--)
          _dayActivity(DateTime(today.year, today.month, today.day - offset), activeDays, today),
      ],
    );
  }

  static DayActivity _dayActivity(DateTime day, Set<DateTime> activeDays, DateTime today) =>
      DayActivity(day: day, isActive: activeDays.contains(day), isToday: day == today);

  /// Longest run of consecutive active days ever (for the streak achievement).
  static int _longestStreak(Set<DateTime> activeDays) {
    var longest = 0;
    for (final day in activeDays) {
      // Only start counting at the first day of a run.
      if (activeDays.contains(_previousDay(day))) continue;
      var length = 1;
      var next = DateTime(day.year, day.month, day.day + 1);
      while (activeDays.contains(next)) {
        length++;
        next = DateTime(next.year, next.month, next.day + 1);
      }
      if (length > longest) longest = length;
    }
    return longest;
  }

  /// Local calendar day (time stripped).
  static DateTime dayOf(DateTime moment) => DateTime(moment.year, moment.month, moment.day);

  static StreakStatus _streak(Set<DateTime> activeDays, DateTime today) {
    final isActiveToday = activeDays.contains(today);
    // A streak survives until the end of today, so count back from today if
    // active, otherwise from yesterday.
    var day = isActiveToday ? today : _previousDay(today);
    var days = 0;
    while (activeDays.contains(day)) {
      days++;
      day = _previousDay(day);
    }
    return StreakStatus(days: days, isActiveToday: isActiveToday);
  }

  // Built from calendar fields so daylight-saving changes can't skip a day.
  static DateTime _previousDay(DateTime day) => DateTime(day.year, day.month, day.day - 1);

  static CourseProgress? _continueCourse(
    List<CourseProgress> courses,
    List<LessonAttempt> attempts,
    LearnerProfile profile,
  ) {
    final unfinished = courses.where((p) => !p.isComplete).toList();
    if (unfinished.isEmpty) return null;

    // 1. The course the learner touched most recently, if unfinished.
    if (attempts.isNotEmpty) {
      final latest = attempts.reduce((a, b) => a.completedAt.isAfter(b.completedAt) ? a : b);
      for (final progress in unfinished) {
        if (progress.course.id == latest.courseId) return progress;
      }
    }
    // 2. The section the diagnostic showed is weakest.
    final weakest = profile.diagnostic?.weakest;
    if (weakest != null) {
      for (final progress in unfinished) {
        if (progress.course.sectionId == weakest.sectionId) return progress;
      }
    }
    // 3. Anything unfinished.
    return unfinished.first;
  }
}
