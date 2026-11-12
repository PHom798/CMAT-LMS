import 'package:w3_lms/features/onboarding/domain/onboarding_progress.dart';

/// Persists in-progress onboarding so it survives restarts, and records
/// whether onboarding has been completed.
abstract interface class OnboardingRepository {
  /// Returns a fresh [OnboardingProgress] when nothing has been saved yet.
  Future<OnboardingProgress> getProgress();

  Future<void> saveProgress(OnboardingProgress progress);

  /// Marks onboarding done. The draft is kept for reference/debugging; the
  /// learner's answers live in LearnerProfileRepository from now on.
  Future<void> markCompleted();

  Future<bool> isCompleted();

  /// Deletes all onboarding state (used by the debug reset).
  Future<void> reset();
}
