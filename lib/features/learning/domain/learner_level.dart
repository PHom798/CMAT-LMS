import 'package:flutter/foundation.dart';

/// Level derived from total XP. Each level needs 50 XP more than the last:
/// L2 at 50, L3 at 150, L4 at 300, L5 at 500…
@immutable
class LearnerLevel {
  const LearnerLevel._(this.level, this.levelStartXp, this.nextLevelXp, this.totalXp);

  factory LearnerLevel.fromXp(int totalXp) {
    final xp = totalXp < 0 ? 0 : totalXp;
    var level = 1;
    while (xp >= xpRequiredFor(level + 1)) {
      level++;
    }
    return LearnerLevel._(level, xpRequiredFor(level), xpRequiredFor(level + 1), xp);
  }

  /// Total XP needed to reach [level].
  static int xpRequiredFor(int level) => 25 * level * (level - 1);

  final int level;
  final int levelStartXp;
  final int nextLevelXp;
  final int totalXp;

  int get xpIntoLevel => totalXp - levelStartXp;
  int get xpToNextLevel => nextLevelXp - totalXp;
  double get fraction => xpIntoLevel / (nextLevelXp - levelStartXp);

  @override
  bool operator ==(Object other) => other is LearnerLevel && other.totalXp == totalXp;

  @override
  int get hashCode => totalXp.hashCode;
}
