/// The ordered steps of onboarding. Reordering this enum reorders the flow.
///
/// Persisted by [name]. If a saved name no longer exists (e.g. a step was
/// removed in an update) the flow safely restarts at [welcome].
enum OnboardingStep {
  welcome,
  name,
  examTimeframe,
  diagnostic,
  dailyGoal,
  ready;

  bool get isFirst => this == values.first;
  bool get isLast => this == values.last;

  OnboardingStep? get next => isLast ? null : values[index + 1];
  OnboardingStep? get previous => isFirst ? null : values[index - 1];

  /// 0.0 on welcome, 1.0 on ready.
  double get progress => index / (values.length - 1);

  static OnboardingStep fromName(String? name) =>
      values.firstWhere((step) => step.name == name, orElse: () => welcome);
}
