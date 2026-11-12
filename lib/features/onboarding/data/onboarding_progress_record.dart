import 'package:isar_community/isar.dart';

part 'onboarding_progress_record.g.dart';

/// Isar storage shape of [OnboardingProgress]. Data-layer only.
@collection
class OnboardingProgressRecord {
  static const singletonId = 1;

  Id id = singletonId;

  String currentStepName = 'welcome';
  bool isCompleted = false;
  DateTime? completedAt;

  // Draft answers, stored by stable keys.
  String name = '';
  String? examTimeframeKey;
  int? dailyGoalMinutes;
  String diagnosticStatusName = 'notTaken';
  List<String> diagnosticSectionIds = [];
  List<int> diagnosticCorrect = [];
  List<int> diagnosticTotals = [];
  int earnedXp = 0;

  DateTime updatedAt = DateTime.now();
}
