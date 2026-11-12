import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';

/// Kit beside a speech bubble, used at the top of lessons and quizzes.
class KitRow extends StatelessWidget {
  const KitRow({super.key, required this.line, required this.reactionKey, this.foxHeight = 84});

  final FoxLine line;
  final int reactionKey;
  final double foxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: [
          FoxMascot(height: foxHeight, mood: line.mood, reactionKey: reactionKey),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: SpeechBubble(text: line.text)),
        ],
      ),
    );
  }
}
