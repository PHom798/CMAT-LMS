import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/daily_quest.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';
import 'package:w3_lms/features/learning/domain/progress_calculator.dart';

import '../../../helpers/test_data.dart';

void main() {
  late List<Course> courses;

  setUpAll(() async => courses = await testContentRepository().getCourses());

  LearningSummary summarize(List<LessonAttempt> attempts, {LearnerProfile? profile, List<Course>? catalog}) =>
      ProgressCalculator.summarize(
        profile: profile ?? testProfile(),
        courses: catalog ?? courses,
        history: LearningHistory(attempts: attempts),
        now: testNow,
      );

  test('a new learner has only onboarding XP and nothing completed', () {
    final summary = summarize(const []);
    expect(summary.totalXp, 10);
    expect(summary.level.level, 1);
    expect(summary.completedLessonCount, 0);
    expect(summary.streak.days, 0);
    expect(summary.todayQuests.every((q) => !q.isComplete), isTrue);
  });

  test('XP = onboarding + lessons + quest rewards + achievements', () {
    // 10 onboarding + 21 lesson + 10 "complete a lesson" quest
    // + achievements: first step 10, flawless 15, Verbal Ability master 25
    expect(summarize([testAttempt()]).totalXp, 91);

    final two = summarize([
      testAttempt(),
      testAttempt(lessonId: 'cmat-quant-1', courseId: 'cmat-quant'),
    ]);
    // 10 + 42 + quests (10 + 10 + 15) + achievements (10 + 15 + 25 + 25)
    expect(two.totalXp, 162);
    expect(two.level.level, 3);
    expect(two.allQuestsComplete, isTrue);
  });

  test('quests from earlier days still count toward XP but not today', () {
    final summary = summarize([testAttempt(at: testNow.subtract(const Duration(days: 1)))]);
    expect(summary.totalXp, 91);
    expect(summary.todayQuests.first.type, DailyQuestType.completeLesson);
    expect(summary.todayQuests.first.isComplete, isFalse);
  });

  test('replays do not double count completed lessons', () {
    final summary = summarize([testAttempt(), testAttempt()]);
    expect(summary.completedLessonCount, 1);
    expect(summary.progressForSection('verbal')!.completedCount, 1);
  });

  group('achievements', () {
    test('nothing is earned on day one', () {
      expect(summarize(const []).earnedAchievements, isEmpty);
    });

    test('perfect lessons, section mastery and all-rounder unlock from history', () {
      final summary = summarize([
        for (final course in courses)
          for (final lesson in course.lessons)
            testAttempt(lessonId: lesson.id, courseId: course.id, firstTryCorrect: 2),
      ]);
      final earned = {for (final a in summary.earnedAchievements) a.id};
      expect(earned, containsAll(['first_lesson', 'all_rounder', 'section_master:quant']));
      expect(earned, isNot(contains('perfect_lesson')), reason: 'no lesson was perfect');
      expect(summary.everythingComplete, isFalse, reason: 'checkpoints not passed yet');
    });

    test('the streak achievement uses the longest streak ever', () {
      final summary = summarize([
        for (final daysAgo in [10, 9, 8]) testAttempt(at: testNow.subtract(Duration(days: daysAgo))),
      ]);
      expect(summary.streak.days, 0, reason: 'the current streak is broken');
      expect(summary.achievements.firstWhere((a) => a.id == 'streak_3').isEarned, isTrue);
    });
  });

  test('checkpoint passes and fixed mistakes add XP; mistakes are counted', () {
    final history = LearningHistory(
      attempts: [testAttempt()],
      answers: [
        AnswerEntry(questionId: 'verbal-tenses-agreement-q1', isCorrect: false, answeredAt: testNow, source: AnswerSource.lesson),
        AnswerEntry(questionId: 'verbal-tenses-agreement-q2', isCorrect: false, answeredAt: testNow, source: AnswerSource.lesson),
        AnswerEntry(
          questionId: 'verbal-tenses-agreement-q2',
          isCorrect: true,
          answeredAt: testNow.add(const Duration(minutes: 5)),
          source: AnswerSource.review,
        ),
      ],
      checkpoints: [
        CheckpointResult(
          topicId: 'verbal-tenses-agreement',
          correct: 2,
          total: 3,
          passed: true,
          xpEarned: PracticeScoring.checkpointPassXp,
          completedAt: testNow,
        ),
      ],
    );
    final summary = ProgressCalculator.summarize(profile: testProfile(), courses: courses, history: history, now: testNow);
    // 91 (one perfect lesson, see above) + 20 checkpoint + 2 review fix + 20 "Topic master"
    expect(summary.totalXp, 133);
    expect(summary.mistakeCount, 1);
    expect(summary.progressForSection('verbal')!.isComplete, isTrue);
  });

  test('week shows the last 7 days ending today', () {
    final summary = summarize([testAttempt(at: testNow.subtract(const Duration(days: 2)))]);
    expect(summary.week, hasLength(7));
    expect(summary.week.last.isToday, isTrue);
    expect(summary.week.last.isActive, isFalse);
    expect(summary.week[4].isActive, isTrue);
  });

  group('streak', () {
    test('counts consecutive active days ending today', () {
      final summary = summarize([
        testAttempt(at: testNow),
        testAttempt(at: testNow.subtract(const Duration(days: 1))),
        testAttempt(at: testNow.subtract(const Duration(days: 3))),
      ]);
      expect(summary.streak.days, 2);
      expect(summary.streak.isActiveToday, isTrue);
    });

    test('is at risk (not broken) when the last lesson was yesterday', () {
      final summary = summarize([testAttempt(at: testNow.subtract(const Duration(days: 1)))]);
      expect(summary.streak.days, 1);
      expect(summary.streak.isAtRisk, isTrue);
    });

    test('is broken after a missed day', () {
      final summary = summarize([testAttempt(at: testNow.subtract(const Duration(days: 2)))]);
      expect(summary.streak.days, 0);
    });
  });

  group('continue learning', () {
    test('without a diagnostic, starts at the first section', () {
      expect(summarize(const []).continueCourse!.course.id, 'cmat-verbal');
    });

    test('with a diagnostic, starts at the weakest section', () {
      final summary = summarize(const [], profile: testProfile(diagnostic: weakInQuant));
      expect(summary.continueCourse!.course.id, 'cmat-quant');
    });

    test('moves on when that section is done, and is null when all are', () {
      final profile = testProfile(diagnostic: weakInQuant);
      // Lesson done but checkpoint not passed: the quant path continues.
      final quantLesson = [testAttempt(lessonId: 'cmat-quant-1', courseId: 'cmat-quant')];
      final afterLesson = summarize(quantLesson, profile: profile).continueCourse!;
      expect(afterLesson.course.id, 'cmat-quant');
      expect(afterLesson.nextStep, isA<CheckpointStep>());

      final everything = LearningHistory(
        attempts: [
          for (final course in courses)
            for (final lesson in course.lessons) testAttempt(lessonId: lesson.id, courseId: course.id),
        ],
        checkpoints: [
          for (final course in courses)
            for (final topic in course.availableTopics)
              CheckpointResult(
                topicId: topic.id,
                correct: 3,
                total: 3,
                passed: true,
                xpEarned: 20,
                completedAt: testNow,
              ),
        ],
      );
      final done = ProgressCalculator.summarize(profile: profile, courses: courses, history: everything, now: testNow);
      expect(done.continueCourse, isNull);
      expect(done.everythingComplete, isTrue);
    });

    test('prefers the unfinished course studied most recently', () {
      Lesson lesson(String id, String course) => Lesson(
            id: id,
            courseId: course,
            title: id,
            objective: 'o',
            estimatedMinutes: 5,
            activities: const [],
          );
      Course course(String id, String section) => Course(
            id: id,
            sectionId: section,
            title: id,
            description: 'd',
            iconKey: section,
            topics: [
              Topic(id: '$id-t', courseId: id, title: 't', description: 'd', lessons: [lesson('${id}1', id), lesson('${id}2', id)]),
            ],
          );
      final catalog = [course('a', 'verbal'), course('b', 'quant')];
      final summary = summarize(
        [testAttempt(lessonId: 'b1', courseId: 'b')],
        catalog: catalog,
        profile: testProfile(diagnostic: weakInQuant),
      );
      expect(summary.continueCourse!.course.id, 'b');
      expect((summary.continueCourse!.nextStep! as LessonStep).lesson.id, 'b2');
    });
  });
}
