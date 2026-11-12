import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_motion.dart';

enum FoxMood { idle, wave, curious, idea, happy, cheer, oops }

abstract final class FoxAssets {
  static const full = 'assets/images/kit_fox.png';
  static const head = 'assets/images/kit_fox_head.png';
  static const double feetAlignX = 0.2;

  /// width / height of [full] (cropped to the character's bounds).
  static const double aspect = 437 / 663;

  /// Drop dedicated poses here as the illustrator delivers them, e.g.
  /// `FoxMood.cheer: 'assets/images/kit_fox_cheer.png'`. Until then every
  /// mood uses the base art and personality comes from motion + emotes.
  static const Map<FoxMood, String> poses = {};

  static String forMood(FoxMood mood) => poses[mood] ?? full;
}

/// Kit, the learning companion.
///
/// One looping "breathing" controller plus one short reaction controller
/// that replays whenever [mood] or [reactionKey] changes. Everything is
/// transforms on a single raster inside a RepaintBoundary, so it stays cheap
/// on low-end Android devices.
class FoxMascot extends StatefulWidget {
  const FoxMascot({
    super.key,
    required this.height,
    this.mood = FoxMood.idle,
    this.reactionKey = 0,
    this.onTap,
  });

  final double height;
  final FoxMood mood;
  final int reactionKey;
  final VoidCallback? onTap;

  @override
  State<FoxMascot> createState() => _FoxMascotState();
}

class _FoxMascotState extends State<FoxMascot> with TickerProviderStateMixin {
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  late final AnimationController _react = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  );

  late double _fromTilt = _restTilt(widget.mood);
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    // Play the first reaction (e.g. a wave) as soon as Kit appears.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_reduceMotion) _react.forward(from: 0);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _idle.stop();
    } else if (!_idle.isAnimating) {
      _idle.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FoxMascot old) {
    super.didUpdateWidget(old);
    if (old.mood != widget.mood || old.reactionKey != widget.reactionKey) {
      // Continue the head tilt from wherever it currently is.
      _fromTilt = lerpDouble(
        _fromTilt,
        _restTilt(old.mood),
        Curves.easeOutBack.transform(_react.value),
      )!;
      if (_reduceMotion) {
        _react.value = 1;
      } else {
        _react.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _idle.dispose();
    _react.dispose();
    super.dispose();
  }

  static double _restTilt(FoxMood mood) => switch (mood) {
    FoxMood.curious => -0.045,
    FoxMood.idea => 0.035,
    _ => 0.0,
  };

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final w = h * FoxAssets.aspect;

    final image = Image.asset(
      FoxAssets.forMood(widget.mood),
      width: w,
      height: h,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
    );
    final emote = _FoxEmote(mood: widget.mood, size: (h * 0.15).clamp(22.0, 34.0).toDouble());

    return Semantics(
      label: 'Kit the fox, your learning buddy',
      button: widget.onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap == null
            ? null
            : () {
          HapticFeedback.selectionClick();
          widget.onTap!();
        },
        child: RepaintBoundary(
          child: SizedBox(
            width: w,
            height: h,
            child: AnimatedBuilder(
              animation: Listenable.merge([_idle, _react]),
              child: image,
              builder: (context, child) {
                final pose = _poseFor(_idle.value, _react.value, h);
                final lift = (-pose.dy / (h * 0.18)).clamp(0.0, 0.5).toDouble();
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Ground shadow shrinks as Kit leaves the floor.
                    Transform.translate(
                      offset: Offset(w / 2 * FoxAssets.feetAlignX, 5),

                      child: Transform.scale(
                        scale: 1 - lift,
                        child: Container(
                          width: w * 0.62,
                          height: h * 0.035,
                          decoration: BoxDecoration(
                            color: AppColors.ink.withValues(alpha: 0.10 * (1 - lift)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(pose.dx, pose.dy),
                      // child: Transform.rotate(
                      //   angle: pose.angle,
                      //   alignment: Alignment.bottomCenter,
                      //   child: Transform.scale(
                      //     scaleX: pose.sx,
                      //     scaleY: pose.sy,
                      //     alignment: Alignment.bottomCenter,
                      //     child: child,
                      //   ),
                      // ),
                      child: Transform.rotate(
                        angle: pose.angle,
                        alignment: const Alignment(FoxAssets.feetAlignX, 1),
                        child: Transform.scale(
                          scaleX: pose.sx,
                          scaleY: pose.sy,
                          alignment: const Alignment(FoxAssets.feetAlignX, 1),
                          child: child,
                        ),
                      ),
                    ),
                    Positioned(
                      top: h * 0.02 + pose.dy,
                      right: -w * 0.08,
                      child: emote,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _Pose _poseFor(double idle, double r, double size) {
    if (_reduceMotion) return _Pose(angle: _restTilt(widget.mood));

    final breathe = Curves.easeInOut.transform(idle);
    var dx = 0.0;
    var dy = -3.0 * breathe;
    var sx = 1.0;
    var sy = 1.0 + 0.012 * breathe;
    var angle = lerpDouble(
      _fromTilt,
      _restTilt(widget.mood),
      Curves.easeOutBack.transform(r),
    )!;

    switch (widget.mood) {
      case FoxMood.cheer:
        dy += _jump(r, size * 0.13);
        final s = _squash(r);
        sy += s;
        sx -= s * 0.6;
        angle += 0.07 * math.sin(r * math.pi * 4) * (1 - r);
      case FoxMood.happy:
        dy += _jump(r, size * 0.065);
        final s = _squash(r) * 0.7;
        sy += s;
        sx -= s * 0.6;
      case FoxMood.wave:
        angle += 0.09 * math.sin(r * math.pi * 6) * (1 - r);
      case FoxMood.curious:
        dy += _jump(r, size * 0.025);
      case FoxMood.idea:
        sy -= 0.035 * math.sin(math.pi * r);
        dy += _jump(r, size * 0.03);
      case FoxMood.oops:
        dx += 9 * math.sin(r * math.pi * 8) * (1 - r);
        sy -= 0.04 * math.sin(math.pi * r);
      case FoxMood.idle:
        break;
    }
    return _Pose(dx: dx, dy: dy, angle: angle, sx: sx, sy: sy);
  }

  static double _jump(double r, double height) =>
      r < 0.7 ? -height * math.sin(math.pi * (r / 0.7)) : 0;

  /// Anticipation squash, stretch on take-off, small squash on landing.
  static double _squash(double r) {
    if (r < 0.1) return -0.08 * (r / 0.1);
    if (r < 0.2) return -0.08 + 0.16 * ((r - 0.1) / 0.1);
    if (r < 0.7) return 0.08 * (1 - (r - 0.2) / 0.5);
    if (r < 0.82) return -0.05 * math.sin(math.pi * (r - 0.7) / 0.12);
    return 0;
  }
}

class _Pose {
  const _Pose({this.dx = 0, this.dy = 0, this.angle = 0, this.sx = 1, this.sy = 1});
  final double dx, dy, angle, sx, sy;
}

/// A small badge next to Kit's head that stands in for facial expressions
/// until dedicated pose art exists.
class _FoxEmote extends StatelessWidget {
  const _FoxEmote({required this.mood, required this.size});

  final FoxMood mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (IconData? icon, Color color) = switch (mood) {
      FoxMood.wave => (Icons.waving_hand_rounded, AppColors.orange),
      FoxMood.curious => (Icons.question_mark_rounded, AppColors.orange),
      FoxMood.idea => (Icons.lightbulb_rounded, AppColors.orange),
      FoxMood.happy => (Icons.favorite_rounded, AppColors.orange),
      FoxMood.cheer => (Icons.auto_awesome_rounded, AppColors.orange),
      FoxMood.oops => (Icons.water_drop_rounded, AppColors.inkSoft),
      FoxMood.idle => (null, AppColors.orange),
    };

    return AnimatedSwitcher(
      duration: AppMotion.medium,
      switchInCurve: Curves.elasticOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: icon == null
          ? SizedBox(key: const ValueKey('none'), width: size, height: size)
          : Container(
        key: ValueKey(mood),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.line, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: size * 0.56, color: color),
      ),
    );
  }
}
