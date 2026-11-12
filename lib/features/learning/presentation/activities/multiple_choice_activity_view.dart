import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/presentation/activities/activity_scroll.dart';
import 'package:w3_lms/features/learning/presentation/activities/choice_tone.dart';
import 'package:w3_lms/features/learning/presentation/activities/content_snippet.dart';

class MultipleChoiceActivityView extends StatelessWidget {
  const MultipleChoiceActivityView({
    super.key,
    required this.activity,
    required this.selectedChoice,
    required this.status,
    required this.wrongAnswers,
    required this.onSelect,
    this.leading,
  });

  final MultipleChoiceActivity activity;
  final int? selectedChoice;
  final AnswerStatus status;
  final int wrongAnswers;
  final ValueChanged<int> onSelect;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final question = activity.question;
    final snippet = question.snippet;
    final isLocked = status != AnswerStatus.unanswered;
    return ActivityScroll(
      leading: leading,
      title: question.prompt,
      children: [
        if (snippet != null) ...[
          ContentSnippet(text: snippet, label: question.snippetLabel, isCode: question.snippetIsCode),
          const SizedBox(height: 18),
        ],
        for (var i = 0; i < question.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: StaggeredEntrance(
              index: i,
              child: AnswerOptionCard(
                index: i,
                text: question.options[i],
                isCode: question.optionsAreCode,
                tone: toneForChoice(question: activity, selectedChoice: selectedChoice, status: status, index: i),
                shakeTrigger: selectedChoice == i && status == AnswerStatus.incorrect ? wrongAnswers : 0,
                onTap: isLocked ? null : () => onSelect(i),
              ),
            ),
          ),
      ],
    );
  }
}
