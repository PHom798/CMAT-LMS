import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';

import '../../../helpers/test_data.dart';

AnswerEntry _a(String id, bool correct, int minute) => AnswerEntry(
      questionId: id,
      isCorrect: correct,
      answeredAt: testNow.add(Duration(minutes: minute)),
      source: AnswerSource.lesson,
    );

void main() {
  test('a question stays a mistake until its latest answer is right', () {
    final history = LearningHistory(answers: [_a('x', false, 0), _a('y', false, 1), _a('x', true, 2)]);
    expect(history.mistakeQuestionIds, ['y']);
    expect(history.latestAnswers['x']!.isCorrect, isTrue);
  });

  test('mistakes come back oldest first', () {
    final history = LearningHistory(answers: [_a('late', false, 5), _a('early', false, 1)]);
    expect(history.mistakeQuestionIds, ['early', 'late']);
  });
}
