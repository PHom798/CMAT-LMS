import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';

/// The same cream gradient as onboarding, so lessons feel like one product.
class LessonBackdrop extends StatelessWidget {
  const LessonBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cream, AppColors.creamLight],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
