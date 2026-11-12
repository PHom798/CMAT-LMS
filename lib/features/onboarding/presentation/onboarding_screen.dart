import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_repository.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/views/onboarding_status_views.dart';
import 'package:w3_lms/features/onboarding/presentation/views/onboarding_view.dart';

/// Route entry for onboarding.
///
/// Creates the [OnboardingController] (scoped to this screen, disposed with
/// it) from the app-level repositories, then shows loading / error / content.
/// The screen does not know which route comes next: the router passes
/// [onCompleted], which keeps features decoupled from each other.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onCompleted, this.onSignIn});

  final VoidCallback onCompleted;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingController(
        onboardingRepository: context.read<OnboardingRepository>(),
        learnerProfileRepository: context.read<LearnerProfileRepository>(),
        contentRepository: context.read<ContentRepository>(),
      )..restore(),
      child: _OnboardingStatusSwitcher(onCompleted: onCompleted, onSignIn: onSignIn),
    );
  }
}

class _OnboardingStatusSwitcher extends StatelessWidget {
  const _OnboardingStatusSwitcher({required this.onCompleted, this.onSignIn});

  final VoidCallback onCompleted;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    final status = context.select((OnboardingController c) => c.loadStatus);
    return AnimatedSwitcher(
      duration: AppMotion.medium,
      child: switch (status) {
        OnboardingLoadStatus.loading => const OnboardingLoadingView(key: ValueKey('loading')),
        OnboardingLoadStatus.failure => OnboardingErrorView(
            key: const ValueKey('failure'),
            onRetry: () => context.read<OnboardingController>().restore(),
          ),
        OnboardingLoadStatus.ready => OnboardingView(
            key: const ValueKey('ready'),
            onCompleted: onCompleted,
            onSignIn: onSignIn,
          ),
      },
    );
  }
}
