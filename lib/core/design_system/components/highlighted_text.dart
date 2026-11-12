import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';

/// Headline where `*wrapped*` segments take the brand orange, the same way
/// the W3 Developers site highlights key words.
///
/// Example: `HighlightedText('Pick a *daily goal*', style: AppText.title)`.
class HighlightedText extends StatelessWidget {
  const HighlightedText(this.source, {super.key, required this.style, this.textAlign});

  final String source;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final parts = source.split('*');
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd ? const TextStyle(color: AppColors.orange) : null,
            ),
        ],
      ),
      style: style,
      textAlign: textAlign,
    );
  }
}
