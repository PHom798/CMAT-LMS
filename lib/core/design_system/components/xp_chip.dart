import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_motion.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';

/// XP counter that pops whenever the value changes.
class XpChip extends StatelessWidget {
  const XpChip({super.key, required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$xp XP',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 5, 12, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt_rounded,
              size: 18,
              color: xp > 0 ? AppColors.orange : AppColors.muted,
            ),
            const SizedBox(width: 2),
            AnimatedSwitcher(
              duration: AppMotion.medium,
              transitionBuilder: (child, a) => ScaleTransition(
                scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
                child: child,
              ),
              child: Text(
                '$xp',
                key: ValueKey(xp),
                style: AppText.label.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
