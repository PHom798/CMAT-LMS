import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/data/learning_mappers.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';

import '../../../helpers/test_data.dart';

void main() {
  test('lesson attempts round-trip', () {
    final attempt = testAttempt(firstTryCorrect: 2, xp: 14);
    expect(attempt.toRecord().toDomain(), attempt);
  });

  test('answers round-trip, including their source', () {
    final answer = AnswerEntry(
      questionId: 'quant-percentages-q1',
      isCorrect: false,
      answeredAt: testNow,
      source: AnswerSource.review,
    );
    expect(answer.toRecord().toDomain(), answer);
  });

  test('checkpoint results round-trip', () {
    final result = CheckpointResult(
      topicId: 'quant-percentages',
      correct: 2,
      total: 3,
      passed: true,
      xpEarned: 20,
      completedAt: testNow,
    );
    expect(result.toRecord().toDomain(), result);
  });
}
