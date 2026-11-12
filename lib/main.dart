import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:w3_lms/app/app.dart';
import 'package:w3_lms/app/app_dependencies.dart';
import 'package:w3_lms/app/app_router.dart';
import 'package:w3_lms/core/design_system/design_system.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.creamLight,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    final dependencies = await AppDependencies.initialize();
    final initialRoute = await _resolveInitialRoute(dependencies);
    runApp(LmsApp(dependencies: dependencies, initialRoute: initialRoute));
  } on Object catch (error, stackTrace) {
    debugPrint('Startup failed: $error\n$stackTrace');
    runApp(const StartupErrorApp());
  }
}

/// Home only when onboarding finished AND a valid profile exists; otherwise
/// (first launch, interrupted onboarding, unreadable profile) onboarding,
/// which restores wherever the learner left off.
Future<String> _resolveInitialRoute(AppDependencies dependencies) async {
  final isOnboarded = await dependencies.onboardingRepository.isCompleted();
  if (!isOnboarded) return AppRoutes.onboarding;
  final profile = await dependencies.learnerProfileRepository.getProfile();
  return profile == null ? AppRoutes.onboarding : AppRoutes.home;
}
