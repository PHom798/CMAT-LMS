import 'package:flutter/material.dart';

/// Text that types itself out while reserving its full size from the first
/// frame, so surrounding layout never jumps.
class TypewriterText extends StatefulWidget {
  const TypewriterText(this.text, {super.key, required this.style, this.maxLines});

  final String text;
  final TextStyle style;
  final int? maxLines;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(TypewriterText old) {
    super.didUpdateWidget(old);
    if (old.text == widget.text) return;
    // Keep whatever part of the old line is shared and already visible, so
    // "Nice to meet you, H" -> "Nice to meet you, Ho" only types the new letter.
    final shown = (old.text.length * _c.value).round();
    var common = 0;
    final limit = shown < widget.text.length ? shown : widget.text.length;
    while (common < limit && old.text.codeUnitAt(common) == widget.text.codeUnitAt(common)) {
      common++;
    }
    _start(fromChars: common);
  }

  void _start({int fromChars = 0}) {
    final length = widget.text.length;
    if (length == 0) {
      _c.value = 1;
      return;
    }
    // Duration covers the full 0..1 range; starting part-way shortens it naturally.
    final ms = (length * 18).clamp(220, 1300).toInt();
    _c
      ..duration = Duration(milliseconds: ms)
      ..forward(from: fromChars / length);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Text(widget.text, style: widget.style, maxLines: widget.maxLines);
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final n = (widget.text.length * _c.value).round();
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: widget.text.substring(0, n)),
              TextSpan(
                text: widget.text.substring(n),
                style: const TextStyle(color: Colors.transparent),
              ),
            ],
          ),
          style: widget.style,
          maxLines: widget.maxLines,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: widget.text,
        );
      },
    );
  }
}
