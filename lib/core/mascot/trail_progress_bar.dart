import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/mascot/fox_mascot.dart';

/// Progress bar where Kit's head rides the leading edge of the fill.
class TrailProgressBar extends StatelessWidget {
  const TrailProgressBar({super.key, required this.value});

  final double value;

  static const _track = 12.0;
  static const _head = 30.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Onboarding progress',
      value: '${(value * 100).round()} percent',
      child: SizedBox(
        height: _head,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(end: value.clamp(0.0, 1.0).toDouble()),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) {
                final headLeft = (width - _head) * v;
                final fillWidth = math.max(_track, math.min(width, headLeft + _head / 2));
                return Stack(
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: _track,
                      decoration: BoxDecoration(
                        color: AppColors.line,
                        borderRadius: BorderRadius.circular(_track),
                      ),
                    ),
                    Container(
                      width: fillWidth,
                      height: _track,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.fromLTRB(6, 3, 6, 0),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(_track),
                      ),
                      // Highlight stripe gives the fill a little volume.
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.38),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Positioned(left: headLeft, child: const _FoxHead(size: _head)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FoxHead extends StatelessWidget {
  const _FoxHead({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.orange, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeDeep.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(FoxAssets.head, fit: BoxFit.cover),
      ),
    );
  }
}
