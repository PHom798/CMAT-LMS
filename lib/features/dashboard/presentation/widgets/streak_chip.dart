import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';

/// Flame + day count. Orange once today's lesson is done, grey otherwise.
class StreakChip extends StatelessWidget {
  const StreakChip({super.key, required this.streak});

  final StreakStatus streak;

  @override
  Widget build(BuildContext context) {
    final isLit = streak.isActiveToday;
    return Semantics(
      label: '${streak.days} day streak',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 5, AppSpacing.md, 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.line, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 18,
              color: isLit ? AppColors.orange : AppColors.muted,
            ),
            const SizedBox(width: 2),
            Text('${streak.days}', style: AppText.label.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
