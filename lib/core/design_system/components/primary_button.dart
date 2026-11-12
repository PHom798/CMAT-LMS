import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_motion.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';

/// Pill-shaped primary CTA (matches the website buttons) that physically
/// presses into its darker edge. Pass `onPressed: null` to disable it.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  static const _height = 56.0;
  static const _depth = 4.0;
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final face = _isEnabled ? AppColors.orange : AppColors.line;
    final edge = _isEnabled ? AppColors.orangeDeep : AppColors.lineDeep;
    final foreground = _isEnabled ? Colors.white : AppColors.muted;
    final radius = BorderRadius.circular(_height / 2);

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: _isEnabled ? (_) => _setPressed(true) : null,
        onTapUp: _isEnabled ? (_) => _setPressed(false) : null,
        onTapCancel: () => _setPressed(false),
        onTap: _isEnabled
            ? () {
                HapticFeedback.lightImpact();
                widget.onPressed!();
              }
            : null,
        child: SizedBox(
          height: _height + _depth,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _height,
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  decoration: BoxDecoration(color: edge, borderRadius: radius),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 70),
                curve: Curves.easeOut,
                left: 0,
                right: 0,
                top: _isPressed ? _depth : 0,
                height: _height,
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: face, borderRadius: radius),
                  child: AnimatedSwitcher(
                    duration: AppMotion.fast,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween(begin: 0.9, end: 1.0).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text(
                      widget.label,
                      key: ValueKey(widget.label),
                      style: AppText.button.copyWith(color: foreground),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
