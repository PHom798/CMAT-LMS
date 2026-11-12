import 'package:flutter/foundation.dart';

/// The official exam structure, loaded from content (not hardcoded), so a
/// change by the exam board only needs a content update.
@immutable
class ExamPattern {
  const ExamPattern({
    required this.id,
    required this.title,
    required this.fullTitle,
    required this.conductedBy,
    required this.durationMinutes,
    required this.totalQuestions,
    required this.passPercent,
    required this.negativeMarking,
    required this.sections,
  });

  final String id;
  final String title;
  final String fullTitle;
  final String conductedBy;
  final int durationMinutes;
  final int totalQuestions;
  final int passPercent;
  final bool negativeMarking;
  final List<ExamSection> sections;

  /// Average time available per question in the real exam.
  int get secondsPerQuestion => totalQuestions == 0 ? 0 : durationMinutes * 60 ~/ totalQuestions;

  ExamSection? sectionById(String id) {
    for (final section in sections) {
      if (section.id == id) return section;
    }
    return null;
  }
}

@immutable
class ExamSection {
  const ExamSection({
    required this.id,
    required this.title,
    required this.shortLabel,
    required this.description,
    required this.questionCount,
    required this.iconKey,
  });

  final String id;
  final String title;

  /// Fits in a small bubble, e.g. "Eng".
  final String shortLabel;
  final String description;

  /// Questions in this section of the real exam.
  final int questionCount;
  final String iconKey;
}
