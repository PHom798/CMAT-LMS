import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/app/app_dependencies.dart';
import 'package:w3_lms/app/app_learning_navigator.dart';
import 'package:w3_lms/app/app_router.dart';
import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/navigation/learning_navigator.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_repository.dart';

class LmsApp extends StatefulWidget {
  const LmsApp({super.key, required this.dependencies, required this.initialRoute});

  final AppDependencies dependencies;
  final String initialRoute;

  @override
  State<LmsApp> createState() => _LmsAppState();
}

class _LmsAppState extends State<LmsApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final LearningNavigator _learningNavigator = AppLearningNavigator(_navigatorKey);

  @override
  Widget build(BuildContext context) {
    final dependencies = widget.dependencies;
    // App-wide singletons. Screen-scoped state (controllers) is created by
    // each screen with ChangeNotifierProvider and reads these via context.read.
    return MultiProvider(
      providers: [
        Provider<LearnerProfileRepository>.value(value: dependencies.learnerProfileRepository),
        Provider<OnboardingRepository>.value(value: dependencies.onboardingRepository),
        Provider<ContentRepository>.value(value: dependencies.contentRepository),
        Provider<LearningProgressRepository>.value(value: dependencies.learningProgressRepository),
        Provider<LearningNavigator>.value(value: _learningNavigator),
      ],
      child: MaterialApp(
        title: 'W3 Developers Learn',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        navigatorKey: _navigatorKey,
        initialRoute: widget.initialRoute,
        onGenerateInitialRoutes: AppRouter.onGenerateInitialRoutes,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}

/// Fallback app shown if local storage cannot be opened at launch.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(
          child: Padding(
            padding: AppSpacing.page,
            child: Text(
              "The app couldn't open its local storage. Please restart it. "
              'If this keeps happening, reinstalling usually fixes it.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
