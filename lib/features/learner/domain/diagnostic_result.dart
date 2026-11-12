import 'package:flutter/foundation.dart';

/// Correct answers out of total for one exam section.
@immutable
class SectionScore {
  const SectionScore({required this.sectionId, required this.correct, required this.total});

  final String sectionId;
  final int correct;
  final int total;

  double get fraction => total == 0 ? 0 : correct / total;

  @override
  bool operator ==(Object other) =>
      other is SectionScore && other.sectionId == sectionId && other.correct == correct && other.total == total;

  @override
  int get hashCode => Object.hash(sectionId, correct, total);
}

/// The learner's starting point from the onboarding diagnostic.
@immutable
class DiagnosticResult {
  const DiagnosticResult(this.sections);

  /// Rebuilds a result from three parallel lists (how Isar records store
  /// it). Returns null when the lists are empty (diagnostic skipped) or
  /// don't line up.
  static DiagnosticResult? fromColumns(List<String> sectionIds, List<int> correct, List<int> totals) {
    if (sectionIds.isEmpty || sectionIds.length != correct.length || sectionIds.length != totals.length) {
      return null;
    }
    return DiagnosticResult([
      for (var i = 0; i < sectionIds.length; i++)
        SectionScore(sectionId: sectionIds[i], correct: correct[i], total: totals[i]),
    ]);
  }

  /// In exam section order.
  final List<SectionScore> sections;

  List<String> get sectionIds => [for (final s in sections) s.sectionId];
  List<int> get correctColumn => [for (final s in sections) s.correct];
  List<int> get totalColumn => [for (final s in sections) s.total];

  int get correct => sections.fold(0, (sum, s) => sum + s.correct);
  int get total => sections.fold(0, (sum, s) => sum + s.total);

  SectionScore? scoreFor(String sectionId) {
    for (final score in sections) {
      if (score.sectionId == sectionId) return score;
    }
    return null;
  }

  /// Lowest-scoring section (first one wins a tie), or null if empty.
  SectionScore? get weakest {
    SectionScore? result;
    for (final score in sections) {
      if (result == null || score.fraction < result.fraction) result = score;
    }
    return result;
  }

  @override
  bool operator ==(Object other) => other is DiagnosticResult && listEquals(other.sections, sections);

  @override
  int get hashCode => Object.hashAll(sections);
}
