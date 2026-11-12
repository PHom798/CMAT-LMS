import 'package:w3_lms/core/mascot/fox_line.dart';
import 'package:w3_lms/core/mascot/fox_mascot.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_controller.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';

// Kit has a job in each part of Home:
// * on the mission card he says what to do next and reacts to progress,
// * on the quests band he narrates today's quests,
// * on the streak strip he explains why tomorrow matters.

/// Exam tips Kit shares when tapped. Built from the exam pattern, so they
/// stay correct if the pattern changes.
List<String> _tips(DashboardController c) {
  final exam = c.exam;
  return [
    if (!exam.negativeMarking)
      'Tip: ${exam.title} has no negative marking. Never leave a question blank!',
    'Tip: ${exam.totalQuestions} questions in ${exam.durationMinutes} minutes is about '
        '${exam.secondsPerQuestion} seconds each.',
    'Tip: you need ${exam.passPercent}% to pass. Strong sections can carry weaker ones.',
    'Five focused minutes a day beats one long cram session.',
  ];
}

/// What Kit says on the mission card, based on real progress.
FoxLine missionKitLine(DashboardController c) {
  final summary = c.summary;
  final profile = c.profile;
  final achievement = c.recentAchievement;
  final gain = c.recentXpGain;

  if (achievement != null) {
    return FoxLine(FoxMood.cheer, 'Achievement unlocked: ${achievement.title}! +${achievement.rewardXp} XP');
  }
  if (gain != null) return FoxLine(FoxMood.cheer, 'Great work! You earned $gain XP.');
  if (c.kitPokes > 0) {
    final tips = _tips(c);
    return FoxLine(FoxMood.idea, tips[(c.kitPokes - 1) % tips.length]);
  }
  if (summary.everythingComplete) {
    return FoxLine(FoxMood.cheer, "You've finished every lesson so far, ${profile.name}. Legendary!");
  }
  final focus = summary.continueCourse?.course.title;
  final next = summary.continueCourse?.nextStep;
  if (summary.completedLessonCount == 0) {
    return FoxLine(FoxMood.wave, "Hi ${profile.name}! Let's start with ${focus ?? 'your first lesson'}.");
  }
  if (next is CheckpointStep) {
    return FoxLine(FoxMood.idea, 'Checkpoint time! Pass it to master ${next.topic.title}.');
  }
  if (summary.mistakeCount >= 3) {
    return FoxLine(FoxMood.curious, '${summary.mistakeCount} mistakes are waiting. Fixing them is the fastest way up!');
  }
  if (summary.streak.isAtRisk) {
    return FoxLine(FoxMood.oops, 'One lesson today saves your ${summary.streak.days}-day streak!');
  }
  if (profile.examTimeframe == ExamTimeframe.underOneMonth) {
    return FoxLine(FoxMood.curious, 'Exam is close! ${focus ?? 'Your weakest section'} needs you most.');
  }
  return FoxLine(FoxMood.idea, 'Next up: ${focus ?? 'a new lesson'}. Tap me for an exam tip!');
}

/// Kit's line above today's quests.
String questsKitLine(LearningSummary summary) {
  final quests = summary.todayQuests;
  final done = summary.completedQuestCount;
  final xpLeft = summary.questXpLeftToday;
  if (done == quests.length) return 'All quests done! New ones arrive at midnight.';
  if (done == 0) return '${quests.length} quests today, worth $xpLeft XP. One lesson gets you started.';
  return '$done of ${quests.length} done. $xpLeft XP is still waiting for you!';
}

/// Why today and tomorrow matter, under the week strip.
String streakMessage(LearningSummary summary) {
  final streak = summary.streak;
  if (streak.isActiveToday) {
    return "Done for today! Come back tomorrow to make it a ${streak.days + 1}-day streak.";
  }
  if (streak.isAtRisk) return 'Practice today to keep your ${streak.days}-day streak alive.';
  return 'Finish one lesson today to start a streak.';
}
