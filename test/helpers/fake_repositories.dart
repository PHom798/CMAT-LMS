import 'dart:async';

import 'package:w3_lms/core/database/local_storage_exception.dart';
import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_progress.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_repository.dart';

/// In-memory stand-ins so state logic can be tested without Isar.
class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({OnboardingProgress? initial, this.failReads = false})
      : progress = initial ?? const OnboardingProgress();

  OnboardingProgress progress;
  bool failReads;
  int saveCount = 0;

  @override
  Future<OnboardingProgress> getProgress() async {
    if (failReads) throw const LocalStorageException('read onboarding progress');
    return progress;
  }

  @override
  Future<void> saveProgress(OnboardingProgress value) async {
    saveCount++;
    progress = value;
  }

  @override
  Future<void> markCompleted() async {
    progress = OnboardingProgress(
      currentStep: progress.currentStep,
      draft: progress.draft,
      isCompleted: true,
    );
  }

  @override
  Future<bool> isCompleted() async => progress.isCompleted;

  @override
  Future<void> reset() async {
    progress = const OnboardingProgress();
  }
}

class FakeLearnerProfileRepository implements LearnerProfileRepository {
  LearnerProfile? profile;
  bool failWrites = false;

  @override
  Future<LearnerProfile?> getProfile() async => profile;

  @override
  Future<void> saveProfile(LearnerProfile value) async {
    if (failWrites) throw const LocalStorageException('write learner profile');
    profile = value;
  }

  @override
  Future<void> clear() async {
    profile = null;
  }
}

/// In-memory learning history with a live stream, like the Isar version.
class FakeLearningProgressRepository implements LearningProgressRepository {
  FakeLearningProgressRepository([LearningHistory? initial]) : history = initial ?? const LearningHistory();

  LearningHistory history;
  final _changes = StreamController<LearningHistory>.broadcast();
  bool failWrites = false;

  void _update(LearningHistory next) {
    history = next;
    _changes.add(next);
  }

  void _checkWrite(String what) {
    if (failWrites) throw LocalStorageException(what);
  }

  @override
  Future<LearningHistory> getHistory() async => history;

  @override
  Stream<LearningHistory> watchHistory() async* {
    yield history;
    yield* _changes.stream;
  }

  @override
  Future<void> recordLesson(LessonAttempt attempt, List<AnswerEntry> answers) async {
    _checkWrite('save lesson');
    _update(LearningHistory(
      attempts: [...history.attempts, attempt],
      answers: [...history.answers, ...answers],
      checkpoints: history.checkpoints,
    ));
  }

  @override
  Future<void> recordCheckpoint(CheckpointResult result, List<AnswerEntry> answers) async {
    _checkWrite('save checkpoint');
    _update(LearningHistory(
      attempts: history.attempts,
      answers: [...history.answers, ...answers],
      checkpoints: [...history.checkpoints, result],
    ));
  }

  @override
  Future<void> recordReview(List<AnswerEntry> answers) async {
    _checkWrite('save answers');
    _update(LearningHistory(
      attempts: history.attempts,
      answers: [...history.answers, ...answers],
      checkpoints: history.checkpoints,
    ));
  }

  @override
  Future<void> clear() async => _update(const LearningHistory());
}
