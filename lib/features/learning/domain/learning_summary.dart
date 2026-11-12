import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/achievement.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/daily_quest.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learner_level.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';

/// Progress through one course (exam section), built on its journey.
@immutable
class CourseProgress {
  const CourseProgress({required this.journey, required this.completedLessonIds});

  final SectionJourney journey;
  final Set<String> completedLessonIds;

  Course get course => journey.course;

  /// Lessons that exist and are done (checkpoints are counted separately).
  int get completedCount => course.lessons.where((l) => completedLessonIds.contains(l.id)).length;
  int get totalCount => course.lessons.length;
  bool get isStarted => completedCount > 0;
  bool get isComplete => journey.isComplete;
  double get mastery => journey.mastery;

  /// Share of all path steps (lessons and checkpoints) completed.
  double get fraction {
    final steps = journey.steps;
    return steps.isEmpty ? 0 : steps.where((s) => s.isCompleted).length / steps.length;
  }

  bool isLessonCompleted(Lesson lesson) => completedLessonIds.contains(lesson.id);

  /// The learner's next stop on this section's path, or null when done.
  JourneyStep? get nextStep => journey.nextStep;
}

/// Consecutive days with at least one completed lesson.
@immutable
class StreakStatus {
  const StreakStatus({required this.days, required this.isActiveToday});

  final int days;

  /// False means the streak (if any) will break unless a lesson is done today.
  final bool isActiveToday;

  bool get isAtRisk => days > 0 && !isActiveToday;
}

/// Whether the learner practiced on a given day.
@immutable
class DayActivity {
  const DayActivity({required this.day, required this.isActive, required this.isToday});

  final DateTime day;
  final bool isActive;
  final bool isToday;
}

/// Everything the dashboard, profile and lesson summary show, computed in
/// one place from persisted data (never stored, never hardcoded).
@immutable
class LearningSummary {
  const LearningSummary({
    required this.totalXp,
    required this.level,
    required this.streak,
    required this.completedLessonCount,
    required this.courseProgress,
    required this.todayQuests,
    required this.continueCourse,
    required this.achievements,
    required this.week,
    required this.mistakeCount,
  });

  final int totalXp;
  final LearnerLevel level;
  final StreakStatus streak;

  /// Distinct lessons completed at least once.
  final int completedLessonCount;

  /// In catalog order.
  final List<CourseProgress> courseProgress;
  final List<DailyQuest> todayQuests;

  /// The course to continue: most recently studied unfinished course, else
  /// the weakest diagnostic section, else the first unfinished one. Null
  /// when every course is complete. Its `nextStep` is the mission.
  final CourseProgress? continueCourse;

  /// Every achievement, earned or not, in display order.
  final List<Achievement> achievements;

  /// The last 7 days, oldest first, ending today.
  final List<DayActivity> week;

  /// Questions whose latest answer was wrong, ready for a review session.
  final int mistakeCount;

  List<Achievement> get earnedAchievements => [for (final a in achievements) if (a.isEarned) a];

  /// True when every available lesson and checkpoint is done.
  bool get everythingComplete => courseProgress.isNotEmpty && courseProgress.every((p) => p.isComplete);

  /// XP still available from today's unfinished quests.
  int get questXpLeftToday => [for (final q in todayQuests) if (!q.isComplete) q.rewardXp].fold(0, (a, b) => a + b);

  int get completedQuestCount => todayQuests.where((q) => q.isComplete).length;
  bool get allQuestsComplete => todayQuests.every((q) => q.isComplete);

  CourseProgress progressFor(String courseId) =>
      courseProgress.firstWhere((p) => p.course.id == courseId);

  /// Progress of the course for an exam section, if one exists.
  CourseProgress? progressForSection(String sectionId) {
    for (final progress in courseProgress) {
      if (progress.course.sectionId == sectionId) return progress;
    }
    return null;
  }
}
