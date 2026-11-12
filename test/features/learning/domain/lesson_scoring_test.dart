import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/domain/learner_level.dart';
import 'package:w3_lms/features/learning/domain/lesson_scoring.dart';

void main() {
  group('LessonScoring', () {
    test('perfect lesson earns completion + per-answer + perfect bonus', () {
      expect(LessonScoring.xpFor(firstTryCorrect: 3, questionCount: 3, isReplay: false), 21);
    });

    test('mistakes lose the per-answer XP and the bonus', () {
      expect(LessonScoring.xpFor(firstTryCorrect: 1, questionCount: 3, isReplay: false), 12);
    });

    test('replays earn half', () {
      expect(LessonScoring.xpFor(firstTryCorrect: 3, questionCount: 3, isReplay: true), 10);
    });
  });

  group('LearnerLevel', () {
    test('thresholds grow by 50 each level', () {
      expect(LearnerLevel.fromXp(0).level, 1);
      expect(LearnerLevel.fromXp(49).level, 1);
      expect(LearnerLevel.fromXp(50).level, 2);
      expect(LearnerLevel.fromXp(149).level, 2);
      expect(LearnerLevel.fromXp(150).level, 3);
    });

    test('reports progress into the current level', () {
      final level = LearnerLevel.fromXp(87);
      expect(level.level, 2);
      expect(level.xpIntoLevel, 37);
      expect(level.xpToNextLevel, 63);
      expect(level.fraction, closeTo(0.37, 0.001));
    });
  });
}
