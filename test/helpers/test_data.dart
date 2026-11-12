import 'dart:io';

import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/learning/data/bundled_content_repository.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

/// A fixed "now" so day-based rules (streaks, quests) are deterministic.
final testNow = DateTime(2026, 11, 10, 9, 30);

/// The real bundled content, read from disk (tests run from the project root).
BundledContentRepository testContentRepository() =>
    BundledContentRepository((path) => File(path).readAsString());

/// Diagnostic where Quantitative Ability is clearly the weakest section.
const weakInQuant = DiagnosticResult([
  SectionScore(sectionId: 'verbal', correct: 2, total: 2),
  SectionScore(sectionId: 'quant', correct: 0, total: 2),
  SectionScore(sectionId: 'logical', correct: 1, total: 2),
  SectionScore(sectionId: 'general', correct: 2, total: 2),
]);

LearnerProfile testProfile({
  DailyGoal dailyGoal = DailyGoal.regular,
  int onboardingXp = 10,
  DiagnosticResult? diagnostic,
}) {
  return LearnerProfile(
    name: 'Hom',
    examTimeframe: ExamTimeframe.oneToThreeMonths,
    dailyGoal: dailyGoal,
    onboardingXp: onboardingXp,
    diagnostic: diagnostic,
  );
}

LessonAttempt testAttempt({
  String lessonId = 'cmat-verbal-1',
  String courseId = 'cmat-verbal',
  DateTime? at,
  int questionCount = 3,
  int firstTryCorrect = 3,
  int xp = 21,
  int minutes = 5,
}) {
  return LessonAttempt(
    lessonId: lessonId,
    courseId: courseId,
    completedAt: at ?? testNow,
    questionCount: questionCount,
    firstTryCorrect: firstTryCorrect,
    xpEarned: xp,
    duration: const Duration(minutes: 2),
    estimatedMinutes: minutes,
  );
}
