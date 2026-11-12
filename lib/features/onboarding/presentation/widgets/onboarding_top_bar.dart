import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';

/// Brand mark on the welcome step; back button, progress and XP afterwards.
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: AnimatedSwitcher(
          duration: AppMotion.medium,
          child: controller.step.isFirst
              ? const Align(
                  key: ValueKey('brand'),
                  alignment: Alignment.centerLeft,
                  child: _BrandMark(),
                )
              : Row(
                  key: const ValueKey('progress'),
                  children: [
                    IconButton(
                      onPressed: onBack,
                      tooltip: 'Back',
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(child: TrailProgressBar(value: controller.progress)),
                    const SizedBox(width: AppSpacing.md),
                    XpChip(xp: controller.draft.earnedXp),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Text wordmark placeholder. Swap for the official logo asset.
/// Official W3 Developers logo (mark + wordmark).
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  static const _height = 44.0;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Semantics(
        label: 'W3 Developers',
        image: true,
        child: Image.asset(
          'assets/images/w3_logo.webp',
          height: _height,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          // The source image is large; decode it at display size only.
          cacheHeight: (_height * pixelRatio).round(),
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}