import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/steps/daily_goal_step.dart';
import 'package:w3_lms/features/onboarding/presentation/steps/diagnostic_step.dart';
import 'package:w3_lms/features/onboarding/presentation/steps/exam_timeframe_step.dart';
import 'package:w3_lms/features/onboarding/presentation/steps/name_step.dart';
import 'package:w3_lms/features/onboarding/presentation/steps/ready_step.dart';
import 'package:w3_lms/features/onboarding/presentation/steps/welcome_step.dart';

/// Swaps step content with a direction-aware slide + fade.
/// Kit and the chrome around it stay put, so only the content moves.
class OnboardingStepSwitcher extends StatelessWidget {
  const OnboardingStepSwitcher({super.key, required this.onNameSubmitted});

  final VoidCallback onNameSubmitted;

  @override
  Widget build(BuildContext context) {
    final step = context.select((OnboardingController c) => c.step);
    final direction = context.select((OnboardingController c) => c.direction).toDouble();
    final currentKey = ValueKey(step);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.expand,
        children: [...previous, if (current != null) current],
      ),
      transitionBuilder: (child, animation) {
        // Incoming slides in from the travel direction; outgoing leaves the other way.
        final isIncoming = child.key == currentKey;
        final begin = Offset((isIncoming ? 0.18 : -0.18) * direction, 0);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(begin: begin, end: Offset.zero).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: currentKey,
        child: switch (step) {
          OnboardingStep.welcome => const WelcomeStep(),
          OnboardingStep.name => NameStep(onSubmitted: onNameSubmitted),
          OnboardingStep.examTimeframe => const ExamTimeframeStep(),
          OnboardingStep.diagnostic => const DiagnosticStep(),
          OnboardingStep.dailyGoal => const DailyGoalStep(),
          OnboardingStep.ready => const ReadyStep(),
        },
      ),
    );
  }
}
