import 'package:flutter/foundation.dart';

/// What a quiz screen should run.
@immutable
sealed class QuizRequest {
  const QuizRequest();
}

/// The checkpoint at the end of a topic.
final class CheckpointQuiz extends QuizRequest {
  const CheckpointQuiz(this.topicId);

  final String topicId;
}

/// A session of the learner's current mistakes.
final class MistakeReviewQuiz extends QuizRequest {
  const MistakeReviewQuiz({this.maxQuestions = 10});

  final int maxQuestions;
}
