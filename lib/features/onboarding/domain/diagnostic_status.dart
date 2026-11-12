/// Whether the learner has done the onboarding diagnostic.
/// Persisted by [name].
enum DiagnosticStatus {
  notTaken,
  skipped,
  completed;

  static DiagnosticStatus fromName(String? name) =>
      values.firstWhere((s) => s.name == name, orElse: () => notTaken);
}

/// XP for finishing the diagnostic: a little for every right answer plus a
/// bonus for finishing, so skipping is allowed but taking it pays.
abstract final class DiagnosticScoring {
  static const completionXp = 5;
  static const perCorrectXp = 2;

  static int xpFor(int correctAnswers) => completionXp + correctAnswers * perCorrectXp;
}
