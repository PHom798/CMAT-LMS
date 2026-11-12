import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';

/// One-shot confetti that fires whenever [trigger] increases.
///
/// Particle positions are pure functions of time (no per-frame state), so a
/// single CustomPainter repaints from one controller. ~40 particles is
/// comfortably cheap on entry-level devices.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    required this.trigger,
    this.origin = const Alignment(0, -0.45),
    this.playOnMount = false,
  });

  final int trigger;
  final Alignment origin;

  /// Also fire once when first shown (e.g. a completion screen).
  final bool playOnMount;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );
  List<_Particle> _particles = const [];
  bool _reduceMotion = false;
  bool _playedOnMount = false;

  static const _palette = [
    AppColors.orange,
    AppColors.orangeDeep,
    AppColors.ink,
    AppColors.sunshine,
    AppColors.orangeSoft,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (widget.playOnMount && !_playedOnMount) {
      _playedOnMount = true;
      _burst(widget.trigger);
    }
  }

  @override
  void didUpdateWidget(ConfettiBurst old) {
    super.didUpdateWidget(old);
    if (widget.trigger > old.trigger) _burst(widget.trigger);
  }

  void _burst(int seed) {
    if (_reduceMotion) return;
    final rnd = math.Random(seed);
    _particles = List.generate(42, (_) {
      return _Particle(
        vx: (rnd.nextDouble() * 2 - 1) * 280,
        vy: -(180 + rnd.nextDouble() * 380),
        spin: (rnd.nextDouble() * 2 - 1) * 10,
        size: 5 + rnd.nextDouble() * 5,
        color: _palette[rnd.nextInt(_palette.length)],
        circle: rnd.nextDouble() < 0.3,
      );
    });
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(_c, _particles, widget.origin),
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.vx,
    required this.vy,
    required this.spin,
    required this.size,
    required this.color,
    required this.circle,
  });

  final double vx, vy, spin, size;
  final Color color;
  final bool circle;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.animation, this.particles, this.origin) : super(repaint: animation);

  final Animation<double> animation;
  final List<_Particle> particles;
  final Alignment origin;

  static const _gravity = 900.0;

  @override
  void paint(Canvas canvas, Size size) {
    final p = animation.value;
    if (p == 0 || p == 1 || particles.isEmpty) return;

    final t = p * 1.5; // seconds
    final start = origin.alongSize(size);
    final fade = p < 0.7 ? 1.0 : 1 - (p - 0.7) / 0.3;
    final paint = Paint();

    for (final particle in particles) {
      final x = start.dx + particle.vx * t;
      final y = start.dy + particle.vy * t + 0.5 * _gravity * t * t;
      paint.color = particle.color.withValues(alpha: fade);
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(particle.spin * t);
      if (particle.circle) {
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size * 0.6),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) =>
      old.particles != particles || old.origin != origin;
}
