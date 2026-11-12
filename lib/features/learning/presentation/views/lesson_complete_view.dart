import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_kit_script.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_backdrop.dart';

/// Celebration + summary: XP, accuracy, time, and what this lesson unlocked
/// (daily quests, level up, streak). All numbers come from the saved attempt
/// and the recalculated progress.
class LessonCompleteView extends StatelessWidget {
  const LessonCompleteView({super.key, required this.onContinue});

  final VoidCallback onContinue;

  static String _formatSeconds(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LessonSessionController>();
    final completion = controller.completion!;
    final attempt = completion.attempt;
    final line = lessonKitLine(controller);
    final accuracy = attempt.questionCount == 0
        ? 100
        : (attempt.firstTryCorrect * 100 / attempt.questionCount).round();

    return Stack(
      children: [
        LessonBackdrop(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xxl, AppSpacing.xxl, AppSpacing.lg),
                  child: Column(
                    children: [
                      SpeechBubble(text: line.text, tail: BubbleTail.down),
                      const SizedBox(height: AppSpacing.xs),
                      FoxMascot(height: 170, mood: line.mood, reactionKey: controller.reactionTick),
                      const SizedBox(height: AppSpacing.xl),
                      const HighlightedText('Lesson *complete*!', style: AppText.display),
                      const SizedBox(height: AppSpacing.xs),
                      Text(controller.lesson.title, style: AppText.body),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: StaggeredEntrance(
                              index: 0,
                              child: StatTile(
                                icon: Icons.bolt_rounded,
                                value: completion.totalXpGained,
                                format: (v) => '+$v',
                                label: 'XP earned',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StaggeredEntrance(
                              index: 1,
                              child: StatTile(
                                icon: Icons.track_changes_rounded,
                                value: accuracy,
                                format: (v) => '$v%',
                                label: 'First try',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StaggeredEntrance(
                              index: 2,
                              child: StatTile(
                                icon: Icons.timer_outlined,
                                value: attempt.duration.inSeconds,
                                format: _formatSeconds,
                                label: 'Time',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      StaggeredEntrance(index: 3, child: _RewardsCard(completion: completion)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.md),
                child: PrimaryButton(label: 'Continue', onPressed: onContinue),
              ),
            ],
          ),
        ),
        Positioned.fill(child: ConfettiBurst(trigger: controller.celebrationTick, playOnMount: true)),
      ],
    );
  }
}

/// Itemised list of everything this lesson earned.
class _RewardsCard extends StatelessWidget {
  const _RewardsCard({required this.completion});

  final LessonCompletion completion;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _RewardRow(
        icon: Icons.school_rounded,
        label: completion.attempt.isPerfect ? 'Perfect lesson' : 'Lesson completed',
        value: '+${completion.attempt.xpEarned} XP',
      ),
      for (final achievement in completion.achievementsUnlockedNow)
        _RewardRow(
          icon: Icons.emoji_events_rounded,
          label: 'Achievement: ${achievement.title}',
          value: '+${achievement.rewardXp} XP',
          isHighlight: true,
        ),
      for (final quest in completion.questsCompletedNow)
        _RewardRow(icon: Icons.flag_rounded, label: 'Quest: ${quest.title}', value: '+${quest.rewardXp} XP'),
      if (completion.startedStreakToday)
        _RewardRow(
          icon: Icons.local_fire_department_rounded,
          label: '${completion.after.streak.days}-day streak',
          value: completion.after.streak.days == 1 ? 'Started!' : 'Extended!',
        ),
      if (completion.leveledUp)
        _RewardRow(
          icon: Icons.military_tech_rounded,
          label: 'Level ${completion.after.level.level} reached',
          value: 'Level up!',
        ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(children: rows),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({required this.icon, required this.label, required this.value, this.isHighlight = false});

  final IconData icon;
  final String label;
  final String value;

  /// Achievements get a filled orange medal so they stand out from quests.
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isHighlight ? AppColors.orange : AppColors.orangeSoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 19, color: isHighlight ? Colors.white : AppColors.orangeDeep),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label, style: AppText.label.copyWith(fontSize: 14.5))),
          Text(value, style: AppText.label.copyWith(fontSize: 14.5, color: AppColors.orangeDeep)),
        ],
      ),
    );
  }
}
