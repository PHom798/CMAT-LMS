import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/achievement.dart';

IconData achievementIcon(Achievement achievement) => switch (achievement.kind) {
      AchievementKind.firstLesson => Icons.flag_rounded,
      AchievementKind.perfectLesson => Icons.auto_awesome_rounded,
      AchievementKind.checkpoint => Icons.workspace_premium_rounded,
      AchievementKind.streak => Icons.local_fire_department_rounded,
      AchievementKind.sectionMaster => AppIcons.forKey(achievement.iconKey ?? ''),
      AchievementKind.allRounder => Icons.emoji_events_rounded,
    };

/// Round medal: solid orange when earned, a progress ring when not.
class AchievementMedal extends StatelessWidget {
  const AchievementMedal({super.key, required this.achievement, this.size = 56});

  final Achievement achievement;
  final double size;

  @override
  Widget build(BuildContext context) {
    final earned = achievement.isEarned;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!earned)
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: achievement.fraction,
                strokeWidth: 3,
                backgroundColor: AppColors.line,
                color: AppColors.orange,
              ),
            ),
          Container(
            width: earned ? size : size - 10,
            height: earned ? size : size - 10,
            decoration: BoxDecoration(
              color: earned ? AppColors.orange : AppColors.locked,
              shape: BoxShape.circle,
              boxShadow: earned ? const [BoxShadow(color: AppColors.orangeDeep, offset: Offset(0, 3))] : null,
            ),
            child: Icon(
              achievementIcon(achievement),
              color: earned ? Colors.white : AppColors.muted,
              size: size * 0.45,
            ),
          ),
        ],
      ),
    );
  }
}
