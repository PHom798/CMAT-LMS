/// How many minutes a day the learner commits to.
/// Stored by [minutes], which doubles as its stable key.
enum DailyGoal {
  casual(5, 'Casual', 1),
  regular(10, 'Regular', 2),
  serious(15, 'Serious', 3),
  intense(20, 'Intense', 4);

  const DailyGoal(this.minutes, this.title, this.intensity);

  final int minutes;
  final String title;

  /// 1-4, drives the intensity bars in the UI.
  final int intensity;

  static DailyGoal? fromMinutes(int? minutes) {
    for (final goal in values) {
      if (goal.minutes == minutes) return goal;
    }
    return null;
  }
}
