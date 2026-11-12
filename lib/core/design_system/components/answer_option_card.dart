import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:w3_lms/core/design_system/components/selectable_card.dart';
import 'package:w3_lms/core/design_system/motion/shake.dart';
import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_motion.dart';
import 'package:w3_lms/core/design_system/tokens/app_spacing.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';

/// A lettered answer choice (A, B, C…) for any multiple-choice question.
/// The caller decides the [tone]; the card only renders it.
class AnswerOptionCard extends StatelessWidget {
  const AnswerOptionCard({
    super.key,
    required this.index,
    required this.text,
    required this.tone,
    required this.onTap,
    this.isCode = false,
    this.shakeTrigger = 0,
  });

  final int index;
  final String text;
  final CardTone tone;

  /// Null disables the card (e.g. after the answer is checked).
  final VoidCallback? onTap;

  /// Render [text] in the monospace face.
  final bool isCode;

  /// Increase to play a shake (wrong answer).
  final int shakeTrigger;

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode(65 + index);
    final accent = switch (tone) {
      CardTone.success => AppColors.success,
      CardTone.error => AppColors.error,
      CardTone.brand => AppColors.orange,
      CardTone.neutral => AppColors.lineDeep,
    };
    final isNeutral = tone == CardTone.neutral;

    return Shake(
      trigger: shakeTrigger,
      child: SelectableCard(
        tone: tone,
        showBadge: tone == CardTone.success || tone == CardTone.error,
        semanticLabel: 'Option $letter: $text',
        padding: const EdgeInsets.all(14),
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap!();
              },
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.fast,
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isNeutral ? AppColors.surface : accent,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: accent, width: 2),
              ),
              child: Text(
                letter,
                style: AppText.label.copyWith(
                  fontSize: 14,
                  color: isNeutral ? AppColors.muted : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(text, style: isCode ? AppText.code : AppText.label)),
          ],
        ),
      ),
    );
  }
}
