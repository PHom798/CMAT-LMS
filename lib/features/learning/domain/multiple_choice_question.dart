import 'package:flutter/foundation.dart';

/// A multiple-choice question used by lessons and the diagnostic.
@immutable
class MultipleChoiceQuestion {
  const MultipleChoiceQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.hint,
    this.snippet,
    this.snippetLabel,
    this.snippetIsCode = false,
    this.optionsAreCode = false,
  });

  /// Stable id: every answer is saved against it. Never change it once shipped.
  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;

  /// Shown after answering, whether right or wrong.
  final String explanation;

  /// Optional nudge for the learner.
  final String? hint;

  /// Optional extra text shown above the options: a number series, a
  /// passage, an equation or a code sample.
  final String? snippet;

  /// Small label above the snippet (e.g. "Python").
  final String? snippetLabel;

  /// Render the snippet as a dark code block instead of a light card.
  final bool snippetIsCode;

  /// Render options in the monospace face (e.g. `<h1>`).
  final bool optionsAreCode;

  String get correctAnswer => options[correctIndex];
}
