import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/step_body.dart';

/// "When is your exam?" Sets the suggested daily goal and Kit's tone.
class ExamTimeframeStep extends StatelessWidget {
  const ExamTimeframeStep({super.key});

  static IconData _iconFor(ExamTimeframe timeframe) => switch (timeframe) {
        ExamTimeframe.underOneMonth => Icons.alarm_rounded,
        ExamTimeframe.oneToThreeMonths => Icons.event_rounded,
        ExamTimeframe.overThreeMonths => Icons.calendar_month_rounded,
        ExamTimeframe.notSure => Icons.help_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final selected = context.select((OnboardingController c) => c.draft.examTimeframe);
    final examTitle = context.select((OnboardingController c) => c.exam.title);

    return StepBody(
      title: 'When is your *$examTitle*?',
      subtitle: "A rough idea is enough. We'll pace your practice to fit.",
      child: Column(
        children: [
          for (final (index, timeframe) in ExamTimeframe.values.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: StaggeredEntrance(
                index: index,
                child: SelectableCard(
                  tone: timeframe == selected ? CardTone.brand : CardTone.neutral,
                  semanticLabel: '${timeframe.title}, ${timeframe.description}',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.read<OnboardingController>().selectExamTimeframe(timeframe);
                  },
                  child: Row(
                    children: [
                      ChoiceIconTile(icon: _iconFor(timeframe), isSelected: timeframe == selected),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(timeframe.title, style: AppText.label),
                            Text(timeframe.description, style: AppText.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
