import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';

/// Shared scroll + padding + heading for every lesson activity.
class ActivityScroll extends StatelessWidget {
  const ActivityScroll({super.key, required this.title, required this.children, this.leading});

  /// Supports `*highlight*` segments.
  final String title;
  final Widget? leading;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.sm, AppSpacing.xxl, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (leading != null) ...[
            Align(alignment: Alignment.centerLeft, child: leading),
            const SizedBox(height: AppSpacing.md),
          ],
          HighlightedText(title, style: AppText.title),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}
