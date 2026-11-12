import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/achievement.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/progress_calculator.dart';

enum DashboardStatus { loading, ready, failure }

/// Shared state for the main tabs (Home, Practice, Profile).
///
/// It listens to the learning history stream, so whenever a lesson is saved
/// anywhere, the summary is recalculated and every tab updates. Nothing on
/// the dashboard is stored separately or hardcoded.
class DashboardController extends ChangeNotifier {
  DashboardController({
    required LearnerProfileRepository learnerProfileRepository,
    required ContentRepository contentRepository,
    required LearningProgressRepository learningProgressRepository,
    DateTime Function()? clock,
  })  : _learnerProfileRepository = learnerProfileRepository,
        _contentRepository = contentRepository,
        _learningProgressRepository = learningProgressRepository,
        _clock = clock ?? DateTime.now;

  final LearnerProfileRepository _learnerProfileRepository;
  final ContentRepository _contentRepository;
  final LearningProgressRepository _learningProgressRepository;
  final DateTime Function() _clock;

  StreamSubscription<LearningHistory>? _subscription;
  DashboardStatus _status = DashboardStatus.loading;
  LearnerProfile? _profile;
  List<Course> _courses = const [];
  ExamPattern? _exam;
  LearningHistory? _history;
  LearningSummary? _summary;
  bool _isDisposed = false;

  // Kit
  int _pendingXpGain = 0;
  int? _recentXpGain;
  final List<Achievement> _pendingAchievements = [];
  Achievement? _recentAchievement;
  int _kitPokes = 0;
  int _reactionTick = 0;
  int _celebrationTick = 0;

  DashboardStatus get status => _status;

  /// Non-null once [status] is ready.
  LearnerProfile get profile => _profile!;
  LearningSummary get summary => _summary!;
  List<Course> get courses => _courses;
  ExamPattern get exam => _exam!;

  /// XP gained by the lesson the learner just finished (for Kit to cheer).
  int? get recentXpGain => _recentXpGain;

  /// The achievement unlocked by the lesson the learner just finished.
  Achievement? get recentAchievement => _recentAchievement;
  int get kitPokes => _kitPokes;
  int get reactionTick => _reactionTick;
  int get celebrationTick => _celebrationTick;

  Future<void> load() async {
    _status = DashboardStatus.loading;
    _notify();
    try {
      final profile = await _learnerProfileRepository.getProfile();
      if (profile == null) throw StateError('No learner profile saved.');
      _profile = profile;
      _courses = await _contentRepository.getCourses();
      _exam = await _contentRepository.getExamPattern();
      await _subscription?.cancel();
      _subscription = _learningProgressRepository.watchHistory().listen(
            _onHistory,
            onError: _onError,
          );
    } on Object catch (error, stackTrace) {
      _onError(error, stackTrace);
    }
  }

  void _onHistory(LearningHistory history) {
    final previous = _summary;
    _history = history;
    _recalculate();
    if (previous != null) {
      if (_summary!.totalXp > previous.totalXp) _pendingXpGain += _summary!.totalXp - previous.totalXp;
      final earnedBefore = {for (final a in previous.earnedAchievements) a.id};
      _pendingAchievements.addAll(_summary!.earnedAchievements.where((a) => !earnedBefore.contains(a.id)));
    }
    _status = DashboardStatus.ready;
    _notify();
  }

  void _onError(Object error, StackTrace stackTrace) {
    debugPrint('Dashboard failed to load: $error\n$stackTrace');
    _status = DashboardStatus.failure;
    _notify();
  }

  void _recalculate() {
    _summary = ProgressCalculator.summarize(
      profile: _profile!,
      courses: _courses,
      history: _history ?? const LearningHistory(),
      now: _clock(),
    );
  }

  /// Call when the app returns to the foreground: quests and streaks are
  /// day-based, so a new day must refresh them even without new lessons.
  void refreshForToday() {
    if (_history == null) return;
    _recalculate();
    _notify();
  }

  /// Call after returning from a completed lesson: Kit cheers once for the
  /// XP that arrived while the lesson screen was open.
  void celebrateRecentProgress() {
    if (_pendingXpGain <= 0) return;
    _recentXpGain = _pendingXpGain;
    _recentAchievement = _pendingAchievements.isEmpty ? null : _pendingAchievements.last;
    _pendingXpGain = 0;
    _pendingAchievements.clear();
    _kitPokes = 0;
    _celebrationTick++;
    _reactionTick++;
    _notify();
  }

  void pokeKit() {
    _kitPokes++;
    _recentXpGain = null;
    _recentAchievement = null;
    _reactionTick++;
    _notify();
  }

  void _notify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
