import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/components/selectable_card.dart';
import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';

/// Answer feedback ("Correct!", "Not quite") shown above a primary button.
class FeedbackPanel extends StatelessWidget {
  const FeedbackPanel({
    super.key,
    required this.tone,
    required this.icon,
    required this.title,
    required this.body,
  });

  final CardTone tone;
  final IconData icon;
  final String title;
  final String body;

  /// Background for the area behind the panel, matching [tone].
  static Color backgroundFor(CardTone? tone) => switch (tone) {
        CardTone.success => AppColors.successSoft,
        CardTone.error => AppColors.errorSoft,
        CardTone.brand => AppColors.orangeSoft.withValues(alpha: 0.6),
        _ => AppColors.creamLight.withValues(alpha: 0),
      };

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      CardTone.success => AppColors.successDeep,
      CardTone.error => AppColors.errorDeep,
      _ => AppColors.orangeDeep,
    };
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.label.copyWith(color: color, fontSize: 16.5)),
                  const SizedBox(height: 2),
                  Text(body, style: AppText.body.copyWith(color: color, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
