import 'package:isar_community/isar.dart';

part 'learner_profile_record.g.dart';

/// Isar storage shape of [LearnerProfile]. Data-layer only: never import this
/// from presentation code. Enums are stored by their stable keys so renaming
/// a Dart enum value can never corrupt saved data.
@collection
class LearnerProfileRecord {
  /// One learner per device, so the profile lives at a fixed id.
  static const singletonId = 1;

  Id id = singletonId;

  String name = '';
  String examTimeframeKey = '';
  int dailyGoalMinutes = 0;

  /// XP from the onboarding diagnostic.
  int onboardingXp = 0;

  /// Diagnostic baseline as parallel lists (index i = one section).
  /// Empty when the learner skipped the diagnostic.
  List<String> diagnosticSectionIds = [];
  List<int> diagnosticCorrect = [];
  List<int> diagnosticTotals = [];

  DateTime createdAt = DateTime.now();

  /// Set on every write. Future sync can compare this with the server copy.
  DateTime updatedAt = DateTime.now();
}
