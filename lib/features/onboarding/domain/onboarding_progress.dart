import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/onboarding/domain/onboarding_draft.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';

/// Everything needed to resume onboarding after the app restarts.
@immutable
class OnboardingProgress {
  const OnboardingProgress({
    this.currentStep = OnboardingStep.welcome,
    this.draft = const OnboardingDraft(),
    this.isCompleted = false,
  });

  final OnboardingStep currentStep;
  final OnboardingDraft draft;
  final bool isCompleted;

  @override
  bool operator ==(Object other) =>
      other is OnboardingProgress &&
      other.currentStep == currentStep &&
      other.draft == draft &&
      other.isCompleted == isCompleted;

  @override
  int get hashCode => Object.hash(currentStep, draft, isCompleted);
}
