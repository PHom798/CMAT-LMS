import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_spacing.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';

/// Small white tile with an icon, a counting-up number and a label.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.format,
    this.iconColor = AppColors.orange,
  });

  final IconData icon;
  final int value;
  final String label;

  /// Formats the number, e.g. `(v) => '+$v'`. Defaults to the plain number.
  final String Function(int value)? format;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: AppSpacing.xs),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, current, _) => Text(
              format?.call(current) ?? '$current',
              style: AppText.title.copyWith(fontSize: 20),
              maxLines: 1,
            ),
          ),
          Text(label, style: AppText.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
