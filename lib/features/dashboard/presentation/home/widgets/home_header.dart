import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/dashboard/presentation/widgets/streak_chip.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';

/// Open header (no card): personal greeting, today's context, streak, XP and
/// a slim level bar.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.name, required this.summary});

  final String name;
  final LearningSummary summary;

  static String _greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _context {
    if (summary.everythingComplete) return 'Everything available is complete. Time to practice.';
    final focus = summary.continueCourse?.course.title;
    return focus == null ? 'Ready when you are' : "Today's focus: $focus";
  }

  @override
  Widget build(BuildContext context) {
    // Strip '*' so a name can't break HighlightedText markup.
    final displayName = name.replaceAll('*', '');
    final level = summary.level;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightedText('${_greeting(DateTime.now())}, *$displayName*', style: AppText.title),
                  const SizedBox(height: 2),
                  Text(_context, style: AppText.body.copyWith(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            StreakChip(streak: summary.streak),
            const SizedBox(width: AppSpacing.sm),
            XpChip(xp: summary.totalXp),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Text(
              'Level ${level.level}',
              style: AppText.caption.copyWith(color: AppColors.orangeDeep, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: ProgressTrack(value: level.fraction, height: 6, semanticLabel: 'Level progress')),
            const SizedBox(width: AppSpacing.sm),
            Text('${level.xpToNextLevel} XP to level ${level.level + 1}', style: AppText.caption),
          ],
        ),
      ],
    );
  }
}
