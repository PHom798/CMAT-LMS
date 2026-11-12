import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';

/// The exam sections in a white card: what's next in each, topics mastered,
/// mastery and the diagnostic baseline, each clearly labelled. Tapping a
/// section opens its learning path.
class SectionsCard extends StatelessWidget {
  const SectionsCard({
    super.key,
    required this.exam,
    required this.summary,
    required this.diagnostic,
    required this.onOpenSection,
  });

  final ExamPattern exam;
  final LearningSummary summary;
  final DiagnosticResult? diagnostic;
  final ValueChanged<String> onOpenSection;

  @override
  Widget build(BuildContext context) {
    final weakestId = diagnostic?.weakest?.sectionId;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        children: [
          for (final (i, section) in exam.sections.indexed) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.line),
            _SectionRow(
              section: section,
              progress: summary.progressForSection(section.id),
              baseline: diagnostic?.scoreFor(section.id),
              isFocus: section.id == weakestId,
              onOpenSection: onOpenSection,
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.section,
    required this.progress,
    required this.baseline,
    required this.isFocus,
    required this.onOpenSection,
  });

  final ExamSection section;
  final CourseProgress? progress;
  final SectionScore? baseline;
  final bool isFocus;
  final ValueChanged<String> onOpenSection;

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;
    final baseline = this.baseline;
    final journey = progress?.journey;
    final next = progress?.nextStep;
    final isComplete = progress?.isComplete ?? false;
    final mastered = journey?.masteredTopicCount ?? 0;
    final topics = journey?.topics.length ?? 0;
    final mastery = ((journey?.mastery ?? 0) * 100).round();
    final topicsText = '$mastered of $topics topics mastered, $mastery% mastery';
    final diagnosticText =
        baseline == null ? 'Diagnostic: not taken' : 'Diagnostic: ${baseline.correct} of ${baseline.total} correct';

    return Semantics(
      button: progress != null,
      label: '${section.title}. ${next == null ? 'Everything available complete' : 'Next: ${next.title}'}. '
          '$topicsText. $diagnosticText.',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: progress == null ? null : () => onOpenSection(progress.course.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChoiceIconTile(icon: AppIcons.forKey(section.iconKey), isSelected: isComplete),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            section.title,
                            style: AppText.label.copyWith(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isFocus && !isComplete) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const _Tag(text: 'Focus'),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      next == null ? 'Everything available complete' : 'Next: ${next.title}',
                      style: AppText.caption.copyWith(
                        color: next == null ? AppColors.successDeep : AppColors.orangeDeep,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        SizedBox(width: 72, child: ProgressTrack(value: journey?.mastery ?? 0, height: 6)),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(child: Text(topicsText, style: AppText.caption)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(diagnosticText, style: AppText.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxs),
                child: _Tag(text: isComplete ? 'Practice' : 'Open path', isAction: !isComplete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, this.isAction = false});

  final String text;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: isAction ? AppColors.orange : AppColors.orangeSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: AppText.caption.copyWith(
          color: isAction ? Colors.white : AppColors.orangeDeep,
          fontWeight: FontWeight.w700,
          fontSize: 11.5,
        ),
      ),
    );
  }
}
