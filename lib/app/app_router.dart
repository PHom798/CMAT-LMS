import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/features/dashboard/presentation/main_shell.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/domain/quiz_request.dart';
import 'package:w3_lms/features/learning/presentation/journey/section_journey_screen.dart';
import 'package:w3_lms/features/learning/presentation/lesson_screen.dart';
import 'package:w3_lms/features/learning/presentation/quiz_screen.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_repository.dart';
import 'package:w3_lms/features/onboarding/presentation/onboarding_screen.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';

  /// The main app (bottom navigation: Home, Courses, Profile).
  static const home = '/home';

  /// Full-screen lesson. Argument: the lesson id (String). Returns true
  /// when the lesson was completed and saved.
  static const lesson = '/lesson';

  /// A section's learning path. Argument: the course id (String).
  static const section = '/section';

  /// Checkpoint or mistake review. Argument: a QuizRequest. Returns true
  /// when a result was saved.
  static const quiz = '/quiz';
}

/// Central route table. Features never push each other's routes directly;
/// they expose callbacks (e.g. `onCompleted`) or call the LearningNavigator, and the
/// router wires them up.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    if (settings.name == AppRoutes.lesson && arguments is String) {
      return _slideUp<bool>(
        settings,
        (context) => LessonScreen(
          lessonId: arguments,
          onExit: (completed) => Navigator.of(context).pop(completed),
        ),
      );
    }
    if (settings.name == AppRoutes.quiz && arguments is QuizRequest) {
      return _slideUp<bool>(
        settings,
        (context) => QuizScreen(
          request: arguments,
          onExit: (completed) => Navigator.of(context).pop(completed),
        ),
      );
    }
    if (settings.name == AppRoutes.section && arguments is String) {
      return _fade(
        settings,
        (context) => SectionJourneyScreen(courseId: arguments, onBack: () => Navigator.of(context).pop()),
      );
    }
    if (settings.name == AppRoutes.onboarding) {
      return _fade(
        settings,
        (context) => OnboardingScreen(
          onCompleted: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
          onSignIn: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-in arrives in a later phase.')),
          ),
        ),
      );
    }
    return _fade(
      const RouteSettings(name: AppRoutes.home),
      (context) => MainShell(onDebugReset: kDebugMode ? () => _resetForDebug(context) : null),
    );
  }

  /// Used by MaterialApp so only the resolved initial route is pushed
  /// (by default Navigator would also push '/' underneath it).
  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) =>
      [onGenerateRoute(RouteSettings(name: initialRoute))];

  static Route<void> _fade(RouteSettings settings, WidgetBuilder builder) {
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  static Route<T> _slideUp<T>(RouteSettings settings, WidgetBuilder builder) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  /// Debug-only: wipes local learner data so onboarding can be re-tested.
  static Future<void> _resetForDebug(BuildContext context) async {
    final onboarding = context.read<OnboardingRepository>();
    final learner = context.read<LearnerProfileRepository>();
    final progress = context.read<LearningProgressRepository>();
    final navigator = Navigator.of(context);
    await progress.clear();
    await onboarding.reset();
    await learner.clear();
    navigator.pushNamedAndRemoveUntil(AppRoutes.onboarding, (_) => false);
  }
}
