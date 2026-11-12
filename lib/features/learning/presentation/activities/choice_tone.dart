import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';

/// Card color for choice [index]. After a wrong answer the correct choice
/// turns green too, so the learner sees it.
CardTone toneForChoice({
  required QuestionActivity question,
  required int? selectedChoice,
  required AnswerStatus status,
  required int index,
}) {
  final isSelected = selectedChoice == index;
  switch (status) {
    case AnswerStatus.correct:
      return isSelected ? CardTone.success : CardTone.neutral;
    case AnswerStatus.incorrect:
      if (isSelected) return CardTone.error;
      return index == question.correctIndex ? CardTone.success : CardTone.neutral;
    case AnswerStatus.unanswered:
      return isSelected ? CardTone.brand : CardTone.neutral;
  }
}
