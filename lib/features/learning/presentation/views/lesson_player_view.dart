import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/presentation/activities/lesson_activity_view.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_backdrop.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_kit_row.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_top_bar.dart';

/// Plays activities one by one: Kit up top, the activity in the middle,
/// feedback + primary button at the bottom (same pattern as onboarding).
class LessonPlayerView extends StatelessWidget {
  const LessonPlayerView({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final progress = context.select((LessonSessionController c) => c.run.progress);
    final stepNumber = context.select((LessonSessionController c) => c.stepNumber);
    final isCompact = MediaQuery.sizeOf(context).height < 700;

    return LessonBackdrop(
      child: Column(
        children: [
          LessonTopBar(onClose: onClose, progress: progress),
          LessonKitRow(foxHeight: isCompact ? 68 : 84),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 360),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (current, previous) => Stack(
                fit: StackFit.expand,
                children: [...previous, if (current != null) current],
              ),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(begin: const Offset(0.15, 0), end: Offset.zero).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(key: ValueKey(stepNumber), child: const LessonActivityView()),
            ),
          ),
          const _LessonActionBar(),
        ],
      ),
    );
  }
}

class _LessonActionBar extends StatelessWidget {
  const _LessonActionBar();

  String _label(LessonSessionController controller) {
    if (controller.phase == LessonPhase.saving) return 'Saving…';
    return switch (controller.primaryAction) {
      LessonPrimaryAction.check => 'Check',
      LessonPrimaryAction.retrySave => 'Try again',
      _ => 'Continue',
    };
  }

  FeedbackPanel? _feedback(LessonSessionController controller) {
    if (controller.phase == LessonPhase.saveFailed) {
      return const FeedbackPanel(
        tone: CardTone.error,
        icon: Icons.cloud_off_rounded,
        title: "Couldn't save your progress",
        body: 'Your device storage did not respond. Your answers are kept, so try again.',
      );
    }
    final run = controller.run;
    if (run.isFinished) return null;
    final activity = run.current;
    if (activity is! QuestionActivity) return null;
    switch (run.status) {
      case AnswerStatus.correct:
        return FeedbackPanel(
          tone: CardTone.success,
          icon: Icons.check_circle_rounded,
          title: 'Correct!',
          body: activity.explanation,
        );
      case AnswerStatus.incorrect:
        return FeedbackPanel(
          tone: CardTone.error,
          icon: Icons.cancel_rounded,
          title: 'Answer: ${activity.correctChoice}',
          body: '${activity.explanation} We will come back to this one.',
        );
      case AnswerStatus.unanswered:
        return null;
    }
  }

  void _onPressed(LessonSessionController controller) {
    switch (controller.primaryAction) {
      case LessonPrimaryAction.check:
        final status = controller.checkAnswer();
        if (status == AnswerStatus.correct) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.heavyImpact();
        }
      case LessonPrimaryAction.next:
        controller.advance();
      case LessonPrimaryAction.retrySave:
        controller.retrySave();
      case LessonPrimaryAction.start || LessonPrimaryAction.finish:
        break; // handled by the intro / completion views
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LessonSessionController>();
    final feedback = _feedback(controller);

    return AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.emphasized,
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 14, AppSpacing.xl, AppSpacing.md),
      decoration: BoxDecoration(
        color: FeedbackPanel.backgroundFor(feedback?.tone),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: AppMotion.medium,
            curve: AppMotion.emphasized,
            alignment: Alignment.topCenter,
            child: feedback ?? const SizedBox(width: double.infinity),
          ),
          PrimaryButton(
            label: _label(controller),
            onPressed: controller.canPerformPrimaryAction ? () => _onPressed(controller) : null,
          ),
        ],
      ),
    );
  }
}
