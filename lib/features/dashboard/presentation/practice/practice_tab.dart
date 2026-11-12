import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_controller.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';

/// Practice by exam section: one card per section, each opening its path.
class PracticeTab extends StatelessWidget {
  const PracticeTab({super.key, required this.onOpenSection, required this.onReviewMistakes});

  final ValueChanged<String> onOpenSection;
  final VoidCallback onReviewMistakes;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final summary = controller.summary;
    final exam = controller.exam;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxxl),
      children: [
        const HighlightedText('Your learning *paths*', style: AppText.title),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '${exam.title} has ${exam.sections.length} sections. Each path takes you topic by topic, '
          'with a checkpoint at the end of every topic.',
          style: AppText.body,
        ),
        if (summary.mistakeCount > 0) ...[
          const SizedBox(height: AppSpacing.lg),
          _ReviewStrip(count: summary.mistakeCount, onTap: onReviewMistakes),
        ],
        const SizedBox(height: AppSpacing.xl),
        for (final (index, progress) in summary.courseProgress.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: StaggeredEntrance(
              index: index,
              child: _SectionPathCard(progress: progress, onTap: () => onOpenSection(progress.course.id)),
            ),
          ),
      ],
    );
  }
}

class _SectionPathCard extends StatelessWidget {
  const _SectionPathCard({required this.progress, required this.onTap});

  final CourseProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final journey = progress.journey;
    final next = progress.nextStep;
    final available = journey.availableTopicCount;
    return SelectableCard(
      onTap: onTap,
      showBadge: false,
      semanticLabel: '${progress.course.title}. ${journey.masteredTopicCount} of ${journey.topics.length} '
          'topics mastered. ${next == null ? '' : 'Next: ${next.title}.'}',
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ChoiceIconTile(icon: AppIcons.forKey(progress.course.iconKey), isSelected: progress.isStarted),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(progress.course.title, style: AppText.label),
                    Text(
                      '${journey.topics.length} topics, $available ready now',
                      style: AppText.caption,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 14),
          // Mini map: one dot per topic, so the syllabus is visible at a glance.
          Row(
            children: [
              for (final topic in journey.topics)
                Expanded(
                  child: Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: topic.isMastered
                          ? AppColors.orange
                          : topic.isComingSoon
                              ? AppColors.line
                              : AppColors.orangeSoft,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            next == null
                ? '${journey.masteredTopicCount} mastered. More topics coming soon.'
                : 'Next: ${next.title}',
            style: AppText.caption.copyWith(
              color: next == null ? AppColors.successDeep : AppColors.orangeDeep,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStrip extends StatelessWidget {
  const _ReviewStrip({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.orangeSoft.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            const Icon(Icons.replay_rounded, color: AppColors.orangeDeep),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '$count ${count == 1 ? 'mistake' : 'mistakes'} to review',
                style: AppText.label.copyWith(fontSize: 14.5),
              ),
            ),
            Text('Review', style: AppText.label.copyWith(fontSize: 14, color: AppColors.orangeDeep)),
          ],
        ),
      ),
    );
  }
}
