import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/step_body.dart';

class DailyGoalStep extends StatelessWidget {
  const DailyGoalStep({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select((OnboardingController c) => c.draft.dailyGoal);
    final suggested = context.select((OnboardingController c) => c.draft.examTimeframe?.suggestedDailyGoal);

    return StepBody(
      title: 'Pick a *daily goal*',
      subtitle: 'Consistency beats intensity. Short daily practice adds up.',
      child: Column(
        children: [
          for (final (i, goal) in DailyGoal.values.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: StaggeredEntrance(
                index: i,
                child: SelectableCard(
                  tone: selected == goal ? CardTone.brand : CardTone.neutral,
                  semanticLabel: '${goal.title}, ${goal.minutes} minutes a day',
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.read<OnboardingController>().selectDailyGoal(goal);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(goal.title, style: AppText.label),
                                if (goal == suggested) ...[
                                  const SizedBox(width: AppSpacing.xs),
                                  const _SuggestedTag(),
                                ],
                              ],
                            ),
                            Text('${goal.minutes} min a day', style: AppText.caption),
                          ],
                        ),
                      ),
                      _IntensityBars(level: goal.intensity, active: selected == goal),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 6),
          _StreakPreview(active: selected != null),
        ],
      ),
    );
  }
}

class _IntensityBars extends StatelessWidget {
  const _IntensityBars({required this.level, required this.active});

  final int level;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < 4; i++)
          AnimatedContainer(
            duration: AppMotion.fast,
            margin: const EdgeInsets.only(left: 3),
            width: 5,
            height: 8.0 + i * 4,
            decoration: BoxDecoration(
              color: i < level
                  ? (active ? AppColors.orange : AppColors.orange.withValues(alpha: 0.4))
                  : AppColors.line,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

/// Plants the idea of a streak before the learner's first real lesson.
class _StreakPreview extends StatelessWidget {
  const _StreakPreview({required this.active});

  final bool active;

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final start = DateTime.now().weekday - 1;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your first week', style: AppText.label.copyWith(fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 7; i++)
                _Day(letter: _letters[(start + i) % 7], today: i == 0, lit: active && i == 0),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: AppMotion.fast,
            child: Text(
              active
                  ? 'Finish one lesson today to start your streak.'
                  : 'Choose a goal to start your streak.',
              key: ValueKey(active),
              style: AppText.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({required this.letter, required this.today, required this.lit});

  final String letter;
  final bool today;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedScale(
          scale: lit ? 1.1 : 1,
          duration: AppMotion.medium,
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: AppMotion.medium,
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: lit ? AppColors.orange : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: lit ? AppColors.orangeDeep : (today ? AppColors.orange : AppColors.line),
                width: 2,
              ),
            ),
            child: lit
                ? const Icon(Icons.local_fire_department_rounded, size: 18, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          letter,
          style: AppText.caption.copyWith(
            color: today ? AppColors.ink : AppColors.muted,
            fontWeight: today ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SuggestedTag extends StatelessWidget {
  const _SuggestedTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.orangeSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        'Suggested',
        style: AppText.caption.copyWith(color: AppColors.orangeDeep, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }
}
