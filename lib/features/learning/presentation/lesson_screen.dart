import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';
import 'package:w3_lms/features/learning/presentation/views/lesson_complete_view.dart';
import 'package:w3_lms/features/learning/presentation/views/lesson_intro_view.dart';
import 'package:w3_lms/features/learning/presentation/views/lesson_player_view.dart';
import 'package:w3_lms/features/learning/presentation/views/lesson_status_views.dart';

/// Route entry for a lesson. Creates a [LessonSessionController] scoped to
/// this screen. [onExit] receives true when the lesson was completed and
/// saved, so the caller can celebrate and refresh.
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lessonId, required this.onExit});

  final String lessonId;
  final ValueChanged<bool> onExit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LessonSessionController(
        lessonId: lessonId,
        contentRepository: context.read<ContentRepository>(),
        progressRepository: context.read<LearningProgressRepository>(),
        learnerProfileRepository: context.read<LearnerProfileRepository>(),
      )..load(),
      child: _LessonPhaseSwitcher(onExit: onExit),
    );
  }
}

class _LessonPhaseSwitcher extends StatelessWidget {
  const _LessonPhaseSwitcher({required this.onExit});

  final ValueChanged<bool> onExit;

  Future<void> _requestExit(BuildContext context) async {
    final controller = context.read<LessonSessionController>();
    if (controller.phase == LessonPhase.complete) {
      onExit(true);
      return;
    }
    if (!controller.shouldConfirmExit) {
      onExit(false);
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.creamLight,
        title: const Text('Leave this lesson?', style: AppText.title),
        content: const Text(
          "Your answers in this lesson won't be saved.",
          style: AppText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Keep learning', style: AppText.label.copyWith(color: AppColors.orangeDeep)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Leave', style: AppText.label.copyWith(color: AppColors.muted)),
          ),
        ],
      ),
    );
    if (leave == true) onExit(false);
  }

  @override
  Widget build(BuildContext context) {
    final phase = context.select((LessonSessionController c) => c.phase);
    void onClose() => _requestExit(context);

    return PopScope(
      // System back goes through the same exit rules as the close button.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _requestExit(context);
      },
      child: AnimatedSwitcher(
        duration: AppMotion.medium,
        child: switch (phase) {
          LessonPhase.loading => const LessonLoadingView(key: ValueKey('loading')),
          LessonPhase.unavailable => LessonUnavailableView(key: const ValueKey('unavailable'), onClose: onClose),
          LessonPhase.intro => LessonIntroView(key: const ValueKey('intro'), onClose: onClose),
          LessonPhase.playing || LessonPhase.saving || LessonPhase.saveFailed =>
            LessonPlayerView(key: const ValueKey('player'), onClose: onClose),
          LessonPhase.complete => LessonCompleteView(key: const ValueKey('complete'), onContinue: () => onExit(true)),
        },
      ),
    );
  }
}
