import 'package:isar_community/isar.dart';

import 'package:w3_lms/core/database/local_storage_exception.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_progress_record.dart';

/// The only class that talks to Isar about onboarding.
class OnboardingLocalDataSource {
  const OnboardingLocalDataSource(this._isar);

  final Isar _isar;

  IsarCollection<OnboardingProgressRecord> get _records => _isar.onboardingProgressRecords;

  Future<OnboardingProgressRecord?> read() => guardStorage(
        'read onboarding progress',
        () => _records.get(OnboardingProgressRecord.singletonId),
      );

  Future<void> write(OnboardingProgressRecord record) => guardStorage(
        'write onboarding progress',
        () => _isar.writeTxn(() => _records.put(record)),
      );

  Future<void> delete() => guardStorage(
        'delete onboarding progress',
        () => _isar.writeTxn(() => _records.delete(OnboardingProgressRecord.singletonId)),
      );
}
