import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/dashboard/presentation/home/widgets/achievements_row.dart';
import 'package:w3_lms/features/dashboard/presentation/home/widgets/home_header.dart';
import 'package:w3_lms/features/dashboard/presentation/home/widgets/mission_card.dart';
import 'package:w3_lms/features/dashboard/presentation/home/widgets/quests_section.dart';
import 'package:w3_lms/features/dashboard/presentation/home/widgets/review_mistakes.dart';
import 'package:w3_lms/features/dashboard/presentation/home/widgets/sections_card.dart';
import 'package:w3_lms/features/dashboard/presentation/home/widgets/streak_week.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_controller.dart';
import 'package:w3_lms/features/dashboard/presentation/widgets/section_header.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';

/// Home answers three questions, in this order:
/// 1. What should I do next?  -> Kit's mission card (+ mistakes to review)
/// 2. Why come back tomorrow? -> daily quests + the week's streak
/// 3. What have I achieved?   -> section paths + achievements
///
/// Layouts deliberately vary: open header, white mission card, tinted quest
/// band, open streak strip, white sections card, open medal shelf.
class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.onOpenStep,
    required this.onOpenSection,
    required this.onReviewMistakes,
    required this.onBrowsePractice,
  });

  final ValueChanged<JourneyStep> onOpenStep;
  final ValueChanged<String> onOpenSection;
  final VoidCallback onReviewMistakes;
  final VoidCallback onBrowsePractice;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final summary = controller.summary;
    final exam = controller.exam;

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeader(name: controller.profile.name, summary: summary),
              const SizedBox(height: AppSpacing.sm),
              MissionCard(onOpenStep: onOpenStep, onPracticeAgain: onBrowsePractice),
              if (summary.mistakeCount > 0) ...[
                const SizedBox(height: AppSpacing.xl),
                ReviewMistakes(count: summary.mistakeCount, onReview: onReviewMistakes),
              ],
              const SizedBox(height: AppSpacing.xxl),
              QuestsSection(summary: summary),
              const SizedBox(height: AppSpacing.xxl),
              StreakWeek(summary: summary),
              SectionHeader(
                title: 'Your ${exam.title} paths',
                trailing: 'See all',
                onTrailingTap: onBrowsePractice,
              ),
              SectionsCard(
                exam: exam,
                summary: summary,
                diagnostic: controller.profile.diagnostic,
                onOpenSection: onOpenSection,
              ),
              SectionHeader(
                title: 'Achievements',
                trailing: '${summary.earnedAchievements.length} of ${summary.achievements.length}',
              ),
              AchievementsRow(achievements: summary.achievements),
            ],
          ),
        ),
        Positioned.fill(child: ConfettiBurst(trigger: controller.celebrationTick)),
      ],
    );
  }
}
