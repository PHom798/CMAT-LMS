import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final hasExplored = context.select((OnboardingController c) => c.hasExploredWelcome);
    final exam = context.select((OnboardingController c) => c.exam);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 21),

                HighlightedText(
                  'Get ready for *${exam.title}*,\none small step a day.',
                  style: AppText.display,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Bite-sized practice for all ${exam.sections.length} sections, '
                  'with a buddy who keeps you on track.',
                  style: AppText.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                AnimatedSwitcher(
                  duration: AppMotion.medium,
                  child: hasExplored
                      ? const SizedBox(key: ValueKey('explored'), height: 36)
                      : const _TapHint(key: ValueKey('hint')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TapHint extends StatelessWidget {
  const _TapHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulseRing(
            diameter: 26,
            child: Icon(Icons.touch_app_rounded, size: 20, color: AppColors.orange),
          ),
          SizedBox(width: 10),
          Text('Tap a bubble to explore each section', style: AppText.caption),
        ],
      ),
    );
  }
}
