/// XP rules for lessons. Kept in one place so they are easy to tune.
abstract final class LessonScoring {
  static const completionXp = 10;
  static const firstTryCorrectXp = 2;
  static const perfectBonusXp = 5;

  /// Replays earn half, so practice is rewarded but not farmable.
  static int xpFor({
    required int firstTryCorrect,
    required int questionCount,
    required bool isReplay,
  }) {
    var xp = completionXp + firstTryCorrect * firstTryCorrectXp;
    if (questionCount > 0 && firstTryCorrect == questionCount) xp += perfectBonusXp;
    return isReplay ? xp ~/ 2 : xp;
  }

  static int maxXpFor({required int questionCount, required bool isReplay}) => xpFor(
        firstTryCorrect: questionCount,
        questionCount: questionCount,
        isReplay: isReplay,
      );
}
