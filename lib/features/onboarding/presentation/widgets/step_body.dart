import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';

/// Consistent scroll, padding and heading for every question step.
class StepBody extends StatelessWidget {
  const StepBody({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.leading,
  });

  /// Supports `*highlight*` segments (see [HighlightedText]).
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, const SizedBox(height: AppSpacing.md)],
          HighlightedText(title, style: AppText.title),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: AppText.body),
          ],
          const SizedBox(height: AppSpacing.xl),
          child,
        ],
      ),
    );
  }
}
