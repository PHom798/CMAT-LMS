import 'package:w3_lms/features/learner/domain/learner_profile.dart';

/// Read/write access to the learner's profile.
///
/// The UI and controllers depend on this abstraction only. Today the
/// implementation is local (Isar); when sync arrives, the implementation will
/// coordinate local + remote data sources without changing this contract.
abstract interface class LearnerProfileRepository {
  /// Returns null until onboarding has saved a profile.
  Future<LearnerProfile?> getProfile();

  Future<void> saveProfile(LearnerProfile profile);

  Future<void> clear();
}
