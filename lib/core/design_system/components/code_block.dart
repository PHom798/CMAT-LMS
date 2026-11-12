import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_spacing.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';

/// Dark code panel with an optional language label. Scrolls sideways for
/// long lines instead of wrapping.
class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, this.code, this.language, this.child});

  final String? code;
  final String? language;

  /// Custom content (e.g. code with a fill-in blank). Overrides [code].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (language != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(language!, style: AppText.caption.copyWith(color: AppColors.orange)),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: child ?? Text(code ?? '', style: AppText.code.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
