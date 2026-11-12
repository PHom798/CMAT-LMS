import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';

/// Font families bundled in pubspec.yaml.
abstract final class AppFonts {
  static const sans = 'Poppins';
  static const mono = 'JetBrainsMono';
}

/// The type scale. Use these instead of creating ad-hoc TextStyles;
/// tweak with `.copyWith(color: ...)` when a component needs a variant.
abstract final class AppText {
  static const display = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 28,
    height: 1.18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    color: AppColors.ink,
  );
  static const title = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 23,
    height: 1.22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );
  static const body = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.inkSoft,
  );
  static const bubble = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 14.5,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );
  static const label = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15.5,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
  static const caption = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 12.5,
    height: 1.35,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );
  static const button = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static const code = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );
}
