import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_controller.dart';
import 'package:w3_lms/features/dashboard/presentation/widgets/achievement_medal.dart';
import 'package:w3_lms/features/learning/domain/achievement.dart';

/// The learner's stats, diagnostic baseline and the plan from onboarding.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, this.onDebugReset});

  /// Debug builds only.
  final VoidCallback? onDebugReset;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final profile = controller.profile;
    final summary = controller.summary;
    final exam = controller.exam;
    final diagnostic = profile.diagnostic;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxxl),
      children: [
        Row(
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.orange, width: 2.5),
              ),
              child: ClipOval(child: Image.asset(FoxAssets.head, fit: BoxFit.cover)),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.name, style: AppText.title),
                  Text('${exam.title} prep, level ${summary.level.level}', style: AppText.caption),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(child: StatTile(icon: Icons.bolt_rounded, value: summary.totalXp, label: 'Total XP')),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: Icons.local_fire_department_rounded,
                value: summary.streak.days,
                label: 'Day streak',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.school_rounded,
                value: summary.completedLessonCount,
                label: 'Lessons done',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(icon: Icons.military_tech_rounded, value: summary.level.level, label: 'Level'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Achievements (${summary.earnedAchievements.length} of ${summary.achievements.length})',
          style: AppText.label.copyWith(fontSize: 17),
        ),
        const SizedBox(height: AppSpacing.md),
        _Panel(
          children: [
            for (final (i, achievement) in summary.achievements.indexed) ...[
              if (i > 0) const Divider(height: 1, color: AppColors.line),
              _AchievementLine(achievement: achievement),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text('Diagnostic baseline', style: AppText.label.copyWith(fontSize: 17)),
        const SizedBox(height: AppSpacing.md),
        _Panel(
          children: diagnostic == null
              ? [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'You skipped the diagnostic. Lessons will show where you stand.',
                      style: AppText.body,
                    ),
                  ),
                ]
              : [
                  for (final (i, section) in exam.sections.indexed) ...[
                    if (i > 0) const Divider(height: 1, color: AppColors.line),
                    _InfoRow(
                      icon: AppIcons.forKey(section.iconKey),
                      label: section.title,
                      value: _scoreText(diagnostic.scoreFor(section.id)?.correct,
                          diagnostic.scoreFor(section.id)?.total),
                    ),
                  ],
                ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text('Your plan', style: AppText.label.copyWith(fontSize: 17)),
        const SizedBox(height: AppSpacing.md),
        _Panel(
          children: [
            _InfoRow(icon: Icons.event_rounded, label: '${exam.title} exam', value: profile.examTimeframe.title),
            const Divider(height: 1, color: AppColors.line),
            _InfoRow(
              icon: Icons.timer_outlined,
              label: 'Daily goal',
              value: '${profile.dailyGoal.minutes} min (${profile.dailyGoal.title})',
            ),
          ],
        ),
        if (onDebugReset != null) ...[
          const SizedBox(height: AppSpacing.xxxl),
          TextButton.icon(
            onPressed: onDebugReset,
            icon: const Icon(Icons.restart_alt_rounded, color: AppColors.muted),
            label: Text(
              'Reset local data (debug only)',
              style: AppText.label.copyWith(fontSize: 14, color: AppColors.muted),
            ),
          ),
        ],
      ],
    );
  }

  static String _scoreText(int? correct, int? total) =>
      correct == null || total == null ? 'Not tested' : '$correct of $total correct';
}

class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          ChoiceIconTile(icon: icon, isSelected: false),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.caption),
                Text(value, style: AppText.label.copyWith(fontSize: 14.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementLine extends StatelessWidget {
  const _AchievementLine({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final earned = achievement.isEarned;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          AchievementMedal(achievement: achievement, size: 44),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(achievement.title, style: AppText.label.copyWith(fontSize: 14.5)),
                Text(
                  earned
                      ? achievement.description
                      : '${achievement.description} (${achievement.progress}/${achievement.target})',
                  style: AppText.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            earned ? 'Earned' : '+${achievement.rewardXp} XP',
            style: AppText.caption.copyWith(
              color: earned ? AppColors.successDeep : AppColors.orangeDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
