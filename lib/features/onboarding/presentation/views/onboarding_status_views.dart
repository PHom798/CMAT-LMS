import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';

/// Shown for the few milliseconds it takes to read saved progress.
class OnboardingLoadingView extends StatelessWidget {
  const OnboardingLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.orange),
        ),
      ),
    );
  }
}

/// Shown if saved progress cannot be read (e.g. storage failure).
class OnboardingErrorView extends StatelessWidget {
  const OnboardingErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.page,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FoxMascot(height: 160, mood: FoxMood.oops),
              const SizedBox(height: AppSpacing.xxl),
              const Text(
                "We couldn't load your progress",
                style: AppText.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Your device storage did not respond. Try again, or restart the app.',
                style: AppText.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(label: 'Try again', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
