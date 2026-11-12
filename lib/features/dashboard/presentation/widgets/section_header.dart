import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';

/// Title for a dashboard section with an optional trailing note or action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing, this.onTrailingTap});

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxl, bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.label.copyWith(fontSize: 17))),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing!,
                style: AppText.caption.copyWith(
                  color: onTrailingTap == null ? AppColors.muted : AppColors.orangeDeep,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
