import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';

/// Builds the shared [FeedbackPanel] for a diagnostic answer, or null when
/// there is nothing to show.
FeedbackPanel? onboardingFeedbackPanel(OnboardingController controller) {
  final run = controller.diagnosticRun;
  if (controller.step != OnboardingStep.diagnostic || run == null || run.isFinished) return null;
  final question = run.current.activity;
  return switch (run.status) {
    AnswerStatus.correct => FeedbackPanel(
        tone: CardTone.success,
        icon: Icons.check_circle_rounded,
        title: 'Correct!',
        body: question.explanation,
      ),
    AnswerStatus.incorrect => FeedbackPanel(
        tone: CardTone.error,
        icon: Icons.cancel_rounded,
        title: 'Answer: ${question.correctChoice}',
        body: question.explanation,
      ),
    AnswerStatus.unanswered => null,
  };
}
