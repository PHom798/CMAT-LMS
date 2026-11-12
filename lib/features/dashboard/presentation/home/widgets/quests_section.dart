import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_kit_script.dart';
import 'package:w3_lms/features/learning/domain/daily_quest.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';

/// Today's quests on an open tinted band (deliberately not a white card),
/// introduced by Kit.
class QuestsSection extends StatelessWidget {
  const QuestsSection({super.key, required this.summary});

  final LearningSummary summary;

  @override
  Widget build(BuildContext context) {
    final quests = summary.todayQuests;
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.orangeSoft.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _KitAvatar(),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Daily quests', style: AppText.label.copyWith(fontSize: 17))),
                        Text(
                          '${summary.completedQuestCount}/${quests.length}',
                          style: AppText.label.copyWith(fontSize: 14, color: AppColors.orangeDeep),
                        ),
                      ],
                    ),
                    Text(questsKitLine(summary), style: AppText.caption.copyWith(color: AppColors.inkSoft)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final quest in quests) _QuestRow(quest: quest),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 14, color: AppColors.muted),
              const SizedBox(width: AppSpacing.xxs),
              Text('New quests every day at midnight', style: AppText.caption.copyWith(fontSize: 11.5)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Kit's head, used where he narrates rather than stars.
class _KitAvatar extends StatelessWidget {
  const _KitAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.orange, width: 2),
      ),
      child: ClipOval(child: Image.asset(FoxAssets.head, fit: BoxFit.cover)),
    );
  }
}

class _QuestRow extends StatelessWidget {
  const _QuestRow({required this.quest});

  final DailyQuest quest;

  IconData get _icon => switch (quest.type) {
        DailyQuestType.completeLesson => Icons.school_rounded,
        DailyQuestType.correctAnswers => Icons.track_changes_rounded,
        DailyQuestType.dailyGoalMinutes => Icons.timer_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final done = quest.isComplete;
    return Semantics(
      label: '${quest.title}. ${quest.progress} of ${quest.target}. Reward ${quest.rewardXp} XP.'
          '${done ? ' Complete.' : ''}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.medium,
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: done ? AppColors.orange : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(done ? Icons.check_rounded : _icon, size: 18, color: done ? Colors.white : AppColors.orangeDeep),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: AppText.label.copyWith(
                      fontSize: 14,
                      color: done ? AppColors.muted : AppColors.ink,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: [
                      Expanded(child: ProgressTrack(value: quest.fraction, height: 6)),
                      const SizedBox(width: AppSpacing.sm),
                      Text('${quest.progress}/${quest.target}', style: AppText.caption.copyWith(fontSize: 11.5)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              done ? 'Earned' : '+${quest.rewardXp} XP',
              style: AppText.caption.copyWith(
                color: done ? AppColors.muted : AppColors.orangeDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
