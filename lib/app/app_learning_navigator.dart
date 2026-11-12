import 'package:flutter/widgets.dart';

import 'package:w3_lms/app/app_router.dart';
import 'package:w3_lms/core/navigation/learning_navigator.dart';
import 'package:w3_lms/features/learning/domain/quiz_request.dart';

/// [LearningNavigator] backed by the app's named routes.
class AppLearningNavigator implements LearningNavigator {
  AppLearningNavigator(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Future<bool> openLesson(String lessonId) async =>
      await _navigator.pushNamed<bool>(AppRoutes.lesson, arguments: lessonId) ?? false;

  @override
  Future<bool> openCheckpoint(String topicId) async =>
      await _navigator.pushNamed<bool>(AppRoutes.quiz, arguments: CheckpointQuiz(topicId)) ?? false;

  @override
  Future<bool> openMistakeReview() async =>
      await _navigator.pushNamed<bool>(AppRoutes.quiz, arguments: const MistakeReviewQuiz()) ?? false;

  @override
  Future<void> openSection(String courseId) => _navigator.pushNamed<void>(AppRoutes.section, arguments: courseId);
}
