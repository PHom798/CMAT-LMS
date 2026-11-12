import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';

/// Plain rounded progress bar with the same look as Kit's trail bar, for
/// quests, courses and levels. [value] is 0..1 and animates on change.
class ProgressTrack extends StatelessWidget {
  const ProgressTrack({
    super.key,
    required this.value,
    this.height = 10,
    this.color = AppColors.orange,
    this.semanticLabel,
  });

  final double value;
  final double height;
  final Color color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0).toDouble();
    return Semantics(
      label: semanticLabel,
      value: '${(clamped * 100).round()} percent',
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.line,
          borderRadius: BorderRadius.circular(height),
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: clamped),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          builder: (context, animated, _) => FractionallySizedBox(
            alignment: Alignment.centerLeft,
            // Keep a visible stub for tiny non-zero values.
            widthFactor: animated == 0 ? 0 : animated.clamp(0.06, 1.0).toDouble(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(height),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
