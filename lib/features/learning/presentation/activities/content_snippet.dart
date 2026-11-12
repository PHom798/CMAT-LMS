import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';

/// Extra text under a prompt or concept: a dark code block for code, a
/// light card for everything else (number series, sentences, worked maths).
class ContentSnippet extends StatelessWidget {
  const ContentSnippet({super.key, required this.text, this.label, this.isCode = false});

  final String text;
  final String? label;
  final bool isCode;

  @override
  Widget build(BuildContext context) {
    if (isCode) return CodeBlock(code: text, language: label);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: const Border(
          left: BorderSide(color: AppColors.orange, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Text(label!, style: AppText.caption.copyWith(color: AppColors.orangeDeep)),
            ),
          Text(text, style: AppText.label.copyWith(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
