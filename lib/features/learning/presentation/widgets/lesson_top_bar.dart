import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';

/// Close button plus Kit's trail progress bar (same as onboarding).
class LessonTopBar extends StatelessWidget {
  const LessonTopBar({super.key, required this.onClose, this.progress});

  final VoidCallback onClose;

  /// Null hides the progress bar (intro screen).
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            IconButton(
              onPressed: onClose,
              tooltip: 'Close lesson',
              icon: const Icon(Icons.close_rounded, color: AppColors.ink),
            ),
            const SizedBox(width: AppSpacing.xxs),
            if (progress != null) ...[
              Expanded(child: TrailProgressBar(value: progress!)),
              const SizedBox(width: AppSpacing.lg),
            ],
          ],
        ),
      ),
    );
  }
}
