import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

enum AchievementKind { firstLesson, perfectLesson, checkpoint, sectionMaster, allRounder, streak }

/// A one-time milestone with an XP reward. Like everything else about
/// progress, achievements are calculated from lesson history, never stored,
/// so they can't drift out of sync and future sync needs nothing extra.
@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.rewardXp,
    required this.progress,
    required this.target,
    this.iconKey,
  });

  /// Stable id, e.g. `section_master:quant`.
  final String id;
  final AchievementKind kind;
  final String title;
  final String description;
  final int rewardXp;
  final int progress;
  final int target;

  /// Content icon key for section achievements.
  final String? iconKey;

  bool get isEarned => progress >= target;
  double get fraction => target == 0 ? 1 : progress / target;
}

/// The rules for every achievement. Rewards are kept modest so XP stays
/// meaningful as more content is added.
abstract final class AchievementRules {
  static const firstLessonXp = 10;
  static const perfectLessonXp = 15;
  static const sectionMasterXp = 25;
  static const allRounderXp = 100;
  static const streakXp = 30;
  static const checkpointXp = 20;
  static const streakTarget = 3;

  static List<Achievement> evaluate({
    required List<Course> courses,
    required List<LessonAttempt> attempts,
    required int longestStreak,
    required int checkpointsPassed,
  }) {
    final completedIds = {for (final a in attempts) a.lessonId};
    final startedSections = courses.where((c) => c.lessons.any((l) => completedIds.contains(l.id))).length;

    int done(Course course) => course.lessons.where((l) => completedIds.contains(l.id)).length;

    return [
      Achievement(
        id: 'first_lesson',
        kind: AchievementKind.firstLesson,
        title: 'First step',
        description: 'Complete your first lesson',
        rewardXp: firstLessonXp,
        progress: attempts.isEmpty ? 0 : 1,
        target: 1,
      ),
      Achievement(
        id: 'perfect_lesson',
        kind: AchievementKind.perfectLesson,
        title: 'Flawless',
        description: 'Finish a lesson with every answer right first try',
        rewardXp: perfectLessonXp,
        progress: attempts.any((a) => a.isPerfect) ? 1 : 0,
        target: 1,
      ),
      Achievement(
        id: 'first_checkpoint',
        kind: AchievementKind.checkpoint,
        title: 'Topic master',
        description: 'Pass your first topic checkpoint',
        rewardXp: checkpointXp,
        progress: checkpointsPassed > 0 ? 1 : 0,
        target: 1,
      ),
      Achievement(
        id: 'streak_$streakTarget',
        kind: AchievementKind.streak,
        title: 'On fire',
        description: 'Practice $streakTarget days in a row',
        rewardXp: streakXp,
        progress: longestStreak > streakTarget ? streakTarget : longestStreak,
        target: streakTarget,
      ),
      for (final course in courses)
        if (course.lessons.isNotEmpty)
          Achievement(
            id: 'section_master:${course.sectionId}',
            kind: AchievementKind.sectionMaster,
            title: '${course.title} master',
            description: 'Complete every ${course.title} lesson',
            rewardXp: sectionMasterXp,
            progress: done(course),
            target: course.lessons.length,
            iconKey: course.iconKey,
          ),
      if (courses.isNotEmpty)
        Achievement(
          id: 'all_rounder',
          kind: AchievementKind.allRounder,
          title: 'All-rounder',
          description: 'Complete a lesson in every section',
          rewardXp: allRounderXp,
          progress: startedSections,
          target: courses.length,
        ),
    ];
  }
}
