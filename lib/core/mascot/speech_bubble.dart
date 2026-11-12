import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';
import 'package:w3_lms/core/mascot/typewriter_text.dart';

enum BubbleTail { left, down }

/// Kit's speech bubble. Text types itself out, but the full string is laid
/// out from the first frame so the bubble never jumps in size.
class SpeechBubble extends StatelessWidget {
  const SpeechBubble({super.key, required this.text, this.tail = BubbleTail.left});

  final String text;
  final BubbleTail tail;

  static const tailSize = 10.0;

  @override
  Widget build(BuildContext context) {
    final padding = switch (tail) {
      BubbleTail.left => const EdgeInsets.fromLTRB(16 + tailSize, 12, 16, 12),
      BubbleTail.down => const EdgeInsets.fromLTRB(16, 12, 16, 12 + tailSize),
    };
    return Semantics(
      liveRegion: true,
      child: CustomPaint(
        painter: _BubblePainter(tail),
        child: Padding(
          padding: padding,
          child: TypewriterText(text, style: AppText.bubble, maxLines: 3),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter(this.tail);

  final BubbleTail tail;

  @override
  void paint(Canvas canvas, Size size) {
    const t = SpeechBubble.tailSize;
    const radius = Radius.circular(18);
    late final Rect body;
    final tailPath = Path();

    switch (tail) {
      case BubbleTail.left:
        body = Rect.fromLTRB(t, 0, size.width, size.height);
        final y = (size.height / 2).clamp(18.0, 30.0).toDouble();
        tailPath
          ..moveTo(t + 1, y - 8)
          ..lineTo(0, y + 2)
          ..lineTo(t + 1, y + 7)
          ..close();
      case BubbleTail.down:
        body = Rect.fromLTRB(0, 0, size.width, size.height - t);
        final x = size.width / 2;
        tailPath
          ..moveTo(x - 9, size.height - t - 1)
          ..lineTo(x - 2, size.height)
          ..lineTo(x + 8, size.height - t - 1)
          ..close();
    }

    final path = Path.combine(
      PathOperation.union,
      Path()..addRRect(RRect.fromRectAndRadius(body, radius)),
      tailPath,
    );

    canvas.drawShadow(path, AppColors.ink.withValues(alpha: 0.35), 3, false);
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_BubblePainter old) => old.tail != tail;
}
