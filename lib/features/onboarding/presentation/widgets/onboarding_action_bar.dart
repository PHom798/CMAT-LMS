import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/answer_feedback_panel.dart';

/// Bottom area: optional answer feedback, the primary button, and a
/// secondary link (sign in on welcome, skip on the diagnostic intro).
/// Its background tints with the feedback.
class OnboardingActionBar extends StatelessWidget {
  const OnboardingActionBar({
    super.key,
    required this.onPrimaryPressed,
    required this.onSkipDiagnostic,
    this.onSignIn,
  });

  final VoidCallback onPrimaryPressed;
  final VoidCallback onSkipDiagnostic;
  final VoidCallback? onSignIn;

  static String labelFor(OnboardingController controller) => switch (controller.primaryAction) {
        OnboardingPrimaryAction.getStarted => 'Get started',
        OnboardingPrimaryAction.next => 'Continue',
        OnboardingPrimaryAction.startDiagnostic => 'Start diagnostic',
        OnboardingPrimaryAction.checkAnswer => 'Check',
        OnboardingPrimaryAction.nextQuestion =>
          (controller.diagnosticRun?.isLastQuestion ?? false) ? 'See my results' : 'Next question',
        OnboardingPrimaryAction.finish => 'Start learning',
      };

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    final feedback = onboardingFeedbackPanel(controller);
    final background = FeedbackPanel.backgroundFor(feedback?.tone);
    final showSignIn = controller.step.isFirst && onSignIn != null;
    final showSkip = controller.canSkipDiagnostic;

    return AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.emphasized,
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 14, AppSpacing.xl, AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
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
            label: controller.isCompleting ? 'Saving…' : labelFor(controller),
            onPressed: controller.canPerformPrimaryAction ? onPrimaryPressed : null,
          ),
          AnimatedSize(
            duration: AppMotion.medium,
            child: showSignIn || showSkip
                ? Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: TextButton(
                      onPressed: showSkip ? onSkipDiagnostic : onSignIn,
                      style: TextButton.styleFrom(foregroundColor: AppColors.ink),
                      child: Text(
                        showSkip ? 'Skip for now' : 'I already have an account',
                        style: AppText.label.copyWith(fontSize: 14),
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
