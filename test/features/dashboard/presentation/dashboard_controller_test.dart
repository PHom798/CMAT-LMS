import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_controller.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/test_data.dart';

void main() {
  late FakeLearningProgressRepository progress;
  late FakeLearnerProfileRepository learner;

  DashboardController createController() {
    progress = FakeLearningProgressRepository();
    learner = FakeLearnerProfileRepository()..profile = testProfile();
    return DashboardController(
      learnerProfileRepository: learner,
      contentRepository: testContentRepository(),
      learningProgressRepository: progress,
      clock: () => testNow,
    );
  }

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('loads real progress from repositories', () async {
    final c = createController();
    await c.load();
    await settle();

    expect(c.status, DashboardStatus.ready);
    expect(c.summary.totalXp, 10);
    expect(c.summary.continueCourse!.course.id, 'cmat-verbal');
    expect(c.exam.title, 'CMAT');
    c.dispose();
  });

  test('updates automatically when a lesson is saved, then celebrates once', () async {
    final c = createController();
    await c.load();
    await settle();

    await progress.recordLesson(testAttempt(), const []);
    await settle();

    expect(c.summary.totalXp, 91);
    expect(c.summary.completedLessonCount, 1);
    expect(c.recentXpGain, isNull, reason: 'cheer waits until the learner is back');

    c.celebrateRecentProgress();
    expect(c.recentXpGain, 81);
    expect(c.recentAchievement, isNotNull);
    expect(c.celebrationTick, 1);

    c.celebrateRecentProgress();
    expect(c.celebrationTick, 1, reason: 'no second celebration without new XP');
    c.dispose();
  });

  test('missing profile shows the failure state', () async {
    final c = createController();
    learner.profile = null;
    await c.load();
    expect(c.status, DashboardStatus.failure);
    c.dispose();
  });
}
