import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/onboarding/presentation/state/fox_script.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';

/// Kit lives here for the whole flow. Instead of every screen owning its own
/// illustration, one fox glides from a big "hero" spot on the welcome screen
/// into a companion spot beside a speech bubble, so the journey feels
/// continuous rather than a stack of slides.
class FoxStage extends StatelessWidget {
  const FoxStage({super.key, required this.availableHeight1});

  static const _duration = Duration(milliseconds: 560);
  static const _curve = Curves.easeInOutCubic;
  static const _foxBaseHeight = 260.0;
  final double availableHeight1;


  @override
  Widget build(BuildContext context) {
    final c = context.watch<OnboardingController>();
    final line = foxLineFor(c);
    // final mq = MediaQuery.of(context);
    // final keyboardOpen = mq.viewInsets.bottom > 0;
    // final screenH = mq.size.height;
    //
    // final hero = c.step == OnboardingStep.welcome;
    // final heroH = (screenH * (screenH < 720 ? 0.34 : 0.40)).clamp(220.0, 360.0).toDouble();
    // final companionH = keyboardOpen ? 96.0 : (screenH < 700 ? 118.0 : 138.0);
    // final h = hero ? heroH : companionH;
    final hero = c.step == OnboardingStep.welcome;
    // Kit takes a share; the step content always keeps the rest.
    final heroH = math.min(availableHeight1 * 0.62, 360.0);
    final companionH = math.min(availableHeight1 * 0.28, 138.0);
    final h = hero ? heroH : companionH;


    return AnimatedContainer(
      duration: _duration,
      curve: _curve,
      height: h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final foxH = hero ? h * 0.70 : h * 0.94;
          final foxW = foxH * FoxAssets.aspect;
          final foxLeft = hero ? (w - foxW) / 2 : 14.0;
          final foxTop = hero ? h - foxH - 6 : (h - foxH) / 2;

          final bubbleW = hero ? math.min(w * 0.8, 300.0) : w - foxW - 34;
          final bubbleLeft = hero ? (w - bubbleW) / 2 : foxW + 22;
          final bubbleBottom = hero ? h - foxTop - 18 : 0.0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: AppMotion.medium,
                  child: hero
                      ? _OrbitDecor(
                          key: const ValueKey('orbit'),
                          foxCenter: Offset(w / 2, h - 6 - foxH / 2),
                          stageHeight: h,
                          topics: c.exam.sections,
                          activeTopic: c.activeSection,
                          onTopic: c.exploreSection,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              AnimatedPositioned(
                duration: _duration,
                curve: _curve,
                left: foxLeft,
                top: foxTop,
                width: foxW,
                height: foxH,
                // Fixed base size scaled by FittedBox, so Kit resizes smoothly
                // with the animated box instead of snapping.
                child: FittedBox(
                  child: FoxMascot(
                    height: _foxBaseHeight,
                    mood: line.mood,
                    reactionKey: c.reactionTick,
                    onTap: hero ? c.pokeFox : null,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: _duration,
                curve: _curve,
                left: bubbleLeft,
                width: bubbleW,
                top: 0,
                bottom: bubbleBottom,
                child: Align(
                  alignment: hero ? Alignment.topCenter : Alignment.centerLeft,
                  child: SpeechBubble(
                    text: line.text,
                    tail: hero ? BubbleTail.down : BubbleTail.left,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Soft disc, dashed orbit and one tappable bubble per exam section behind
/// Kit on the welcome screen, borrowed from the website's hero illustration.
class _OrbitDecor extends StatefulWidget {
  const _OrbitDecor({
    super.key,
    required this.foxCenter,
    required this.stageHeight,
    required this.topics,
    required this.activeTopic,
    required this.onTopic,
  });

  final Offset foxCenter;
  final double stageHeight;
  final List<ExamSection> topics;
  final ExamSection? activeTopic;
  final ValueChanged<ExamSection> onTopic;

  @override
  State<_OrbitDecor> createState() => _OrbitDecorState();
}

class _OrbitDecorState extends State<_OrbitDecor> with SingleTickerProviderStateMixin {
  // One controller drives all bubbles, each with its own phase.
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

  // Angles in radians (0 = right, y grows downward). Kept away from the top
  // so they never collide with the speech bubble.
  static const _angles = [-2.62, -0.52, 2.55, 0.62];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _float.stop();
    } else if (!_float.isAnimating) {
      _float.repeat();
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.stageHeight;
    final center = widget.foxCenter;
    final discR = h * 0.36;
    final orbitR = h * 0.47;
    const bubble = 52.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _OrbitPainter(center: center, discRadius: discR, orbitRadius: orbitR),
                ),
              ),
            ),
            for (var i = 0; i < widget.topics.length && i < _angles.length; i++)
              AnimatedBuilder(
                animation: _float,
                builder: (context, child) {
                  final phase = _float.value * 2 * math.pi + i * 1.7;
                  final x = math.min(
                    math.max(center.dx + orbitR * math.cos(_angles[i]), bubble / 2 + 6),
                    w - bubble / 2 - 6,
                  );
                  final y = center.dy + orbitR * math.sin(_angles[i]) + 4 * math.sin(phase);
                  return Positioned(
                    left: x - bubble / 2,
                    top: y - bubble / 2,
                    child: child!,
                  );
                },
                child: _TopicBubble(
                  topic: widget.topics[i],
                  size: bubble,
                  active: widget.activeTopic == widget.topics[i],
                  onTap: () => widget.onTopic(widget.topics[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.center, required this.discRadius, required this.orbitRadius});

  final Offset center;
  final double discRadius;
  final double orbitRadius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, discRadius, Paint()..color = AppColors.orangeSoft);

    final dash = Paint()
      ..color = AppColors.orange.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    const segments = 56;
    for (var i = 0; i < segments; i++) {
      final a = i * 2 * math.pi / segments;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: orbitRadius),
        a,
        math.pi / segments,
        false,
        dash,
      );
    }

    // Small satellite dots, like the ones around the website illustration.
    final dot = Paint()..color = AppColors.orange.withValues(alpha: 0.55);
    for (final a in const [-1.57, 1.2, 3.6]) {
      canvas.drawCircle(
        center + Offset(math.cos(a), math.sin(a)) * orbitRadius,
        3,
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.center != center || old.discRadius != discRadius || old.orbitRadius != orbitRadius;
}

class _TopicBubble extends StatelessWidget {
  const _TopicBubble({
    required this.topic,
    required this.size,
    required this.active,
    required this.onTap,
  });

  final ExamSection topic;
  final double size;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Learn about ${topic.title}',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedScale(
          scale: active ? 1.12 : 1,
          duration: AppMotion.medium,
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.orange : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? AppColors.orangeDeep : AppColors.lineDeep,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              topic.shortLabel,
              style: AppText.label.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
