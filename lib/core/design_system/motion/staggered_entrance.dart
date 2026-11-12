import 'package:flutter/material.dart';

/// Fades and lifts [child] in once, delayed by its [index] in a list.
/// Uses an implicit animation, so no controller to manage.
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.stepMs = 55,
    this.offset = 14,
  });

  final int index;
  final Widget child;
  final int stepMs;
  final double offset;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final delay = index * stepMs;
    final total = 320 + delay;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(delay / total, 1, curve: Curves.easeOutCubic),
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, (1 - value) * offset), child: child),
      ),
    );
  }
}
