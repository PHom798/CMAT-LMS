import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_motion.dart';
import 'package:w3_lms/core/design_system/tokens/app_spacing.dart';

/// Rounded icon square used inside option cards; fills orange when selected.
class ChoiceIconTile extends StatelessWidget {
  const ChoiceIconTile({super.key, required this.icon, required this.isSelected});

  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange : AppColors.orangeSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, size: 21, color: isSelected ? Colors.white : AppColors.orangeDeep),
    );
  }
}
