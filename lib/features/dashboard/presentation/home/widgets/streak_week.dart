import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_kit_script.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';

/// The last 7 days as a row of flames, plus the reason to come back
/// tomorrow. Open layout, no card.
class StreakWeek extends StatelessWidget {
  const StreakWeek({super.key, required this.summary});

  final LearningSummary summary;

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final day in summary.week)
              _Day(letter: _letters[day.day.weekday - 1], isActive: day.isActive, isToday: day.isToday),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 18,
              color: summary.streak.isActiveToday ? AppColors.orange : AppColors.muted,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(streakMessage(summary), style: AppText.body.copyWith(fontSize: 14))),
          ],
        ),
      ],
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({required this.letter, required this.isActive, required this.isToday});

  final String letter;
  final bool isActive;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$letter${isToday ? ', today' : ''}: ${isActive ? 'practiced' : 'no practice'}',
      excludeSemantics: true,
      child: Column(
        children: [
          AnimatedContainer(
            duration: AppMotion.medium,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isActive ? AppColors.orange : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppColors.orangeDeep : (isToday ? AppColors.orange : AppColors.lineDeep),
                width: isToday && !isActive ? 2.5 : 1.5,
              ),
            ),
            child: isActive ? const Icon(Icons.local_fire_department_rounded, size: 19, color: Colors.white) : null,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            letter,
            style: AppText.caption.copyWith(
              color: isToday ? AppColors.ink : AppColors.muted,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
