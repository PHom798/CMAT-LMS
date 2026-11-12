import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';

enum JourneyLoadStatus { loading, ready, failure }

/// State for one section's learning path. Listens to the learning history,
/// so finishing a lesson or checkpoint updates the path immediately.
class SectionJourneyController extends ChangeNotifier {
  SectionJourneyController({
    required this.courseId,
    required ContentRepository contentRepository,
    required LearningProgressRepository progressRepository,
  })  : _contentRepository = contentRepository,
        _progressRepository = progressRepository;

  final String courseId;
  final ContentRepository _contentRepository;
  final LearningProgressRepository _progressRepository;

  StreamSubscription<LearningHistory>? _subscription;
  JourneyLoadStatus _status = JourneyLoadStatus.loading;
  Course? _course;
  SectionJourney? _journey;
  int _reactionTick = 0;
  int _celebrationTick = 0;
  bool _isDisposed = false;

  JourneyLoadStatus get status => _status;

  /// Non-null once [status] is ready.
  SectionJourney get journey => _journey!;
  int get reactionTick => _reactionTick;
  int get celebrationTick => _celebrationTick;

  Future<void> load() async {
    _status = JourneyLoadStatus.loading;
    _notify();
    try {
      _course = await _contentRepository.getCourse(courseId);
      if (_course == null) throw StateError('Unknown course $courseId');
      await _subscription?.cancel();
      _subscription = _progressRepository.watchHistory().listen(_onHistory, onError: _onError);
    } on Object catch (error, stackTrace) {
      _onError(error, stackTrace);
    }
  }

  void _onHistory(LearningHistory history) {
    final previous = _journey;
    _journey = JourneyBuilder.build(_course!, history);
    if (previous != null) {
      final before = previous.steps.where((s) => s.isCompleted).length;
      final after = _journey!.steps.where((s) => s.isCompleted).length;
      if (after > before) {
        _celebrationTick++;
        _reactionTick++;
      }
    }
    _status = JourneyLoadStatus.ready;
    _notify();
  }

  void _onError(Object error, StackTrace stackTrace) {
    debugPrint('Journey failed to load: $error\n$stackTrace');
    _status = JourneyLoadStatus.failure;
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
