import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';

/// A question that belongs to an exam section (diagnostic, checkpoints,
/// reviews, later mock tests).
@immutable
class AssessmentQuestion {
  const AssessmentQuestion({required this.sectionId, required this.activity});

  final String sectionId;
  final QuestionActivity activity;
}

/// Plays a fixed list of questions once each: no retries, one score per
/// section. Used by the onboarding diagnostic, topic checkpoints and mistake
/// reviews; Phase 5 mock tests will add a timer and hide feedback until the end.
class AssessmentRun {
  AssessmentRun(this.questions);

  final List<AssessmentQuestion> questions;
  final List<bool> _results = [];
  int? _selectedChoice;
  AnswerStatus _status = AnswerStatus.unanswered;

  int get index => _results.length;
  int get total => questions.length;
  bool get isFinished => index >= total;
  bool get isLastQuestion => index == total - 1;
  AssessmentQuestion get current => questions[index];

  int? get selectedChoice => _selectedChoice;
  AnswerStatus get status => _status;
  bool get canCheck => !isFinished && _selectedChoice != null && _status == AnswerStatus.unanswered;
  bool get canAdvance => !isFinished && _status != AnswerStatus.unanswered;

  void select(int choiceIndex) {
    if (isFinished || _status != AnswerStatus.unanswered) return;
    _selectedChoice = choiceIndex;
  }

  AnswerStatus check() {
    if (!canCheck) return _status;
    _status = current.activity.isCorrect(_selectedChoice!) ? AnswerStatus.correct : AnswerStatus.incorrect;
    return _status;
  }

  void advance() {
    if (!canAdvance) return;
    _results.add(_status == AnswerStatus.correct);
    _selectedChoice = null;
    _status = AnswerStatus.unanswered;
  }

  int get correctCount => _results.where((r) => r).length;

  /// Result of every question answered so far, by question id.
  Map<String, bool> get answersById => {
        for (var i = 0; i < _results.length; i++) questions[i].activity.id: _results[i],
      };

  /// Scores per section, in [sectionOrder].
  DiagnosticResult result(List<String> sectionOrder) {
    return DiagnosticResult([
      for (final sectionId in sectionOrder)
        SectionScore(
          sectionId: sectionId,
          correct: [
            for (var i = 0; i < _results.length; i++)
              if (questions[i].sectionId == sectionId && _results[i]) i,
          ].length,
          total: questions.where((q) => q.sectionId == sectionId).length,
        ),
    ]);
  }
}
