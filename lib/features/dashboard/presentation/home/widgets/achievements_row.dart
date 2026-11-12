import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/dashboard/presentation/widgets/achievement_medal.dart';
import 'package:w3_lms/features/learning/domain/achievement.dart';

/// Horizontal shelf of medals, earned first. Tap one to see what it needs.
class AchievementsRow extends StatelessWidget {
  const AchievementsRow({super.key, required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    final sorted = [
      ...achievements.where((a) => a.isEarned),
      ...achievements.where((a) => !a.isEarned),
    ];
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        itemCount: sorted.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          final achievement = sorted[i];
          return Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: achievement.isEarned
                ? '${achievement.description}. Earned +${achievement.rewardXp} XP.'
                : '${achievement.description} (${achievement.progress}/${achievement.target}). '
                    'Reward: +${achievement.rewardXp} XP.',
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  StaggeredEntrance(index: i, child: AchievementMedal(achievement: achievement)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    achievement.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(
                      fontSize: 11.5,
                      color: achievement.isEarned ? AppColors.ink : AppColors.muted,
                      fontWeight: achievement.isEarned ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
