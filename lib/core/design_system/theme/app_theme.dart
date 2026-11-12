import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/tokens/app_colors.dart';
import 'package:w3_lms/core/design_system/tokens/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      primary: AppColors.orange,
      onPrimary: Colors.white,
      surface: AppColors.cream,
      onSurface: AppColors.ink,
      error: AppColors.error,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppFonts.sans,
      scaffoldBackgroundColor: AppColors.cream,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.orange,
        selectionColor: AppColors.orangeSoft,
        selectionHandleColor: AppColors.orange,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }
}
