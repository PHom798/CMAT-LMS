import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_controller.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_kit_script.dart';
import 'package:w3_lms/features/learning/domain/achievement.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';
import 'package:w3_lms/features/learning/domain/lesson_scoring.dart';

/// Kit's card: he peeks over its top edge and briefs the learner on the
/// next mission, or celebrates when every lesson is done. Kit and his words
/// live inside the card instead of floating beside it.
class MissionCard extends StatelessWidget {
  const MissionCard({super.key, required this.onOpenStep, required this.onPracticeAgain});

  final ValueChanged<JourneyStep> onOpenStep;
  final VoidCallback onPracticeAgain;

  static const _kitHeight = 118.0;
  static const _kitOverlap = 46.0;
  static const _kitSlot = 84.0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final summary = controller.summary;
    final line = missionKitLine(controller);
    final mission = summary.continueCourse;
    final step = mission?.nextStep;

    return Padding(
      padding: const EdgeInsets.only(top: _kitOverlap),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.line, width: 1.5),
              boxShadow: const [BoxShadow(color: AppColors.line, offset: Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Reserve room for Kit's body so content below never overlaps him.
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: _kitHeight - _kitOverlap - AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: _kitSlot),
                      Expanded(child: _KitSays(text: line.text)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (mission != null && step != null)
                  _NextMission(progress: mission, step: step, onStart: () => onOpenStep(step))
                else
                  _AllComplete(summary: summary, onPracticeAgain: onPracticeAgain),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.sm,
            top: -_kitOverlap,
            child: FoxMascot(
              height: _kitHeight,
              mood: line.mood,
              reactionKey: controller.reactionTick,
              onTap: controller.pokeKit,
            ),
          ),
        ],
      ),
    );
  }
}

/// Kit's words, styled as part of the card (a speech tile that opens toward
/// Kit) rather than a floating bubble.
class _KitSays extends StatelessWidget {
  const _KitSays({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: const BoxDecoration(
        color: AppColors.orangeTint,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Semantics(
        liveRegion: true,
        child: TypewriterText(text, style: AppText.bubble, maxLines: 3),
      ),
    );
  }
}

class _NextMission extends StatelessWidget {
  const _NextMission({required this.progress, required this.step, required this.onStart});

  final CourseProgress progress;
  final JourneyStep step;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final step = this.step;
    final (String title, String detail, List<_Meta> meta, String button) = switch (step) {
      LessonStep(:final lesson) => (
          lesson.title,
          lesson.objective,
          [
            _Meta(icon: Icons.timer_outlined, text: '${lesson.estimatedMinutes} min'),
            _Meta(icon: Icons.quiz_outlined, text: '${lesson.questionCount} questions'),
            _Meta(
              icon: Icons.bolt_rounded,
              text: 'Up to ${LessonScoring.maxXpFor(questionCount: lesson.questionCount, isReplay: false)} XP',
            ),
          ],
          progress.isStarted ? 'Continue mission' : 'Start mission',
        ),
      CheckpointStep(:final checkpoint, :final topic) => (
          '${topic.title} checkpoint',
          'Pass to master the topic and unlock what comes next.',
          [
            _Meta(icon: Icons.quiz_outlined, text: '${checkpoint.questions.length} questions'),
            _Meta(icon: Icons.flag_rounded, text: 'Pass with ${checkpoint.passMark}'),
            const _Meta(icon: Icons.bolt_rounded, text: '+${PracticeScoring.checkpointPassXp} XP'),
          ],
          'Take checkpoint',
        ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PillTag(
          icon: step is CheckpointStep ? Icons.emoji_events_rounded : AppIcons.forKey(progress.course.iconKey),
          label: "Today's mission: ${progress.course.title}",
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(title, style: AppText.title.copyWith(fontSize: 21)),
        const SizedBox(height: AppSpacing.xxs),
        Text(detail, style: AppText.body.copyWith(fontSize: 14)),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.lg, runSpacing: AppSpacing.xs, children: meta),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(label: button, onPressed: onStart),
      ],
    );
  }
}

/// Shown when everything available is done: celebrate, don't apologise.
class _AllComplete extends StatelessWidget {
  const _AllComplete({required this.summary, required this.onPracticeAgain});

  final LearningSummary summary;
  final VoidCallback onPracticeAgain;

  @override
  Widget build(BuildContext context) {
    final allRounder = summary.achievements.where((a) => a.kind == AchievementKind.allRounder).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PillTag(icon: Icons.verified_rounded, label: 'Everything complete'),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.orangeDeep, offset: Offset(0, 3))],
              ),
              child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 30),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(allRounder?.title ?? 'Every section done', style: AppText.title.copyWith(fontSize: 20)),
                  if (allRounder != null)
                    Text(
                      '+${allRounder.rewardXp} XP earned',
                      style: AppText.label.copyWith(fontSize: 14, color: AppColors.orangeDeep),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          "You've mastered every topic available right now. Your next adventure is on the way.",
          style: AppText.body,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(label: 'Practice previous lessons', onPressed: onPracticeAgain),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: AppSpacing.xxs),
        Text(text, style: AppText.caption),
      ],
    );
  }
}
