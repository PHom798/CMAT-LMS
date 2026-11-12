import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

/// Where an answer was given.
enum AnswerSource { lesson, checkpoint, review }

/// One answered question. Only the first try at a question counts in
/// lessons; checkpoints and reviews have one try each.
@immutable
class AnswerEntry {
  const AnswerEntry({
    required this.questionId,
    required this.isCorrect,
    required this.answeredAt,
    required this.source,
  });

  final String questionId;
  final bool isCorrect;
  final DateTime answeredAt;
  final AnswerSource source;

  @override
  bool operator ==(Object other) =>
      other is AnswerEntry &&
      other.questionId == questionId &&
      other.isCorrect == isCorrect &&
      other.answeredAt == answeredAt &&
      other.source == source;

  @override
  int get hashCode => Object.hash(questionId, isCorrect, answeredAt, source);
}

/// A finished topic checkpoint.
@immutable
class CheckpointResult {
  const CheckpointResult({
    required this.topicId,
    required this.correct,
    required this.total,
    required this.passed,
    required this.xpEarned,
    required this.completedAt,
  });

  final String topicId;
  final int correct;
  final int total;
  final bool passed;
  final int xpEarned;
  final DateTime completedAt;

  @override
  bool operator ==(Object other) =>
      other is CheckpointResult &&
      other.topicId == topicId &&
      other.correct == correct &&
      other.total == total &&
      other.passed == passed &&
      other.xpEarned == xpEarned &&
      other.completedAt == completedAt;

  @override
  int get hashCode => Object.hash(topicId, correct, total, passed, xpEarned, completedAt);
}

/// Everything the learner has done, as append-only lists. All progress
/// (XP, mastery, unlocks, mistakes) is calculated from this.
@immutable
class LearningHistory {
  const LearningHistory({
    this.attempts = const [],
    this.answers = const [],
    this.checkpoints = const [],
  });

  final List<LessonAttempt> attempts;
  final List<AnswerEntry> answers;
  final List<CheckpointResult> checkpoints;

  Set<String> get completedLessonIds => {for (final a in attempts) a.lessonId};
  Set<String> get passedTopicIds => {for (final c in checkpoints) if (c.passed) c.topicId};

  /// The most recent answer for each question id.
  Map<String, AnswerEntry> get latestAnswers {
    final latest = <String, AnswerEntry>{};
    for (final answer in answers) {
      final current = latest[answer.questionId];
      if (current == null || !answer.answeredAt.isBefore(current.answeredAt)) {
        latest[answer.questionId] = answer;
      }
    }
    return latest;
  }

  /// Questions whose most recent answer was wrong, oldest mistake first.
  List<String> get mistakeQuestionIds {
    final wrong = [for (final a in latestAnswers.values) if (!a.isCorrect) a]
      ..sort((a, b) => a.answeredAt.compareTo(b.answeredAt));
    return [for (final a in wrong) a.questionId];
  }
}

/// XP rules for checkpoints and reviews.
abstract final class PracticeScoring {
  /// Awarded the first time a topic's checkpoint is passed.
  static const checkpointPassXp = 20;

  /// Per mistake fixed in a review session.
  static const reviewFixXp = 2;
}
