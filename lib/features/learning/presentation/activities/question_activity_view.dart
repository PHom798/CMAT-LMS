import 'package:flutter/material.dart';

import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/presentation/activities/fill_in_blank_activity_view.dart';
import 'package:w3_lms/features/learning/presentation/activities/multiple_choice_activity_view.dart';

/// Renders any question type from plain answer state. Shared by lessons,
/// the onboarding diagnostic and (later) mock tests, so every question in
/// the app looks and behaves the same.
class QuestionActivityView extends StatelessWidget {
  const QuestionActivityView({
    super.key,
    required this.activity,
    required this.selectedChoice,
    required this.status,
    required this.onSelect,
    this.wrongAnswers = 0,
    this.leading,
  });

  final QuestionActivity activity;
  final int? selectedChoice;
  final AnswerStatus status;
  final ValueChanged<int> onSelect;

  /// Increase to shake the wrong choice.
  final int wrongAnswers;

  /// Shown above the prompt (e.g. a section tag).
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return switch (activity) {
      MultipleChoiceActivity a => MultipleChoiceActivityView(
          activity: a,
          selectedChoice: selectedChoice,
          status: status,
          wrongAnswers: wrongAnswers,
          onSelect: onSelect,
          leading: leading,
        ),
      FillInBlankActivity a => FillInBlankActivityView(
          activity: a,
          selectedChoice: selectedChoice,
          status: status,
          wrongAnswers: wrongAnswers,
          onSelect: onSelect,
          leading: leading,
        ),
    };
  }
}
