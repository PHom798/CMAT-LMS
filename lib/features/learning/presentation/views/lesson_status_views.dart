import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';

class LessonLoadingView extends StatelessWidget {
  const LessonLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.orange, strokeWidth: 3)),
    );
  }
}

/// Lesson id not found (e.g. removed in an update) or data unreadable.
class LessonUnavailableView extends StatelessWidget {
  const LessonUnavailableView({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.page,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FoxMascot(height: 150, mood: FoxMood.oops),
              const SizedBox(height: AppSpacing.xxl),
              const Text("This lesson isn't available", style: AppText.title, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'It may have been updated. Pick another lesson from your courses.',
                style: AppText.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(label: 'Back to courses', onPressed: onClose),
            ],
          ),
        ),
      ),
    );
  }
}
