import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_motion.dart';
import 'package:w3_lms/core/design_system/tokens/app_spacing.dart';

/// Visual state of a [SelectableCard].
enum CardTone { neutral, brand, success, error }

/// Tappable card that sinks into its edge when pressed and tints by [tone].
/// Used for every "pick an option" list in the app.
class SelectableCard extends StatefulWidget {
  const SelectableCard({
    super.key,
    required this.child,
    required this.onTap,
    this.tone = CardTone.neutral,
    this.showBadge = true,
    this.padding = const EdgeInsets.all(14),
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final CardTone tone;
  final bool showBadge;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  static const _edgeDepth = 3.0;
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final (border, edge, fill) = switch (widget.tone) {
      CardTone.neutral => (AppColors.line, AppColors.lineDeep, AppColors.surface),
      CardTone.brand => (AppColors.orange, AppColors.orangeDeep, AppColors.orangeTint),
      CardTone.success => (AppColors.success, AppColors.successDeep, AppColors.successSoft),
      CardTone.error => (AppColors.error, AppColors.errorDeep, AppColors.errorSoft),
    };
    final isActive = widget.tone != CardTone.neutral;
    final badgeIcon = widget.tone == CardTone.error ? Icons.close_rounded : Icons.check_rounded;
    final depth = _isPressed ? 0.0 : _edgeDepth;

    return Semantics(
      button: true,
      selected: isActive,
      label: widget.semanticLabel,
      child: GestureDetector(
        onTapDown: widget.onTap == null ? null : (_) => _setPressed(true),
        onTapUp: widget.onTap == null ? null : (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: Curves.easeOut,
          width: double.infinity,
          transform: Matrix4.translationValues(0, _edgeDepth - depth, 0),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: border, width: 2),
            boxShadow: [BoxShadow(color: edge, offset: Offset(0, depth))],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              widget.child,
              if (widget.showBadge)
                Positioned(
                  top: -6,
                  right: -6,
                  child: AnimatedScale(
                    scale: isActive ? 1 : 0,
                    duration: AppMotion.medium,
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(color: border, shape: BoxShape.circle),
                      child: Icon(badgeIcon, size: 15, color: Colors.white),
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
