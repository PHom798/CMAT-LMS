import 'package:isar_community/isar.dart';

import 'package:w3_lms/core/database/local_storage_exception.dart';
import 'package:w3_lms/features/learner/data/learner_profile_record.dart';

/// The only class that talks to Isar about the learner profile.
class LearnerProfileLocalDataSource {
  const LearnerProfileLocalDataSource(this._isar);

  final Isar _isar;

  IsarCollection<LearnerProfileRecord> get _records => _isar.learnerProfileRecords;

  Future<LearnerProfileRecord?> read() => guardStorage(
        'read learner profile',
        () => _records.get(LearnerProfileRecord.singletonId),
      );

  Future<void> write(LearnerProfileRecord record) => guardStorage(
        'write learner profile',
        () => _isar.writeTxn(() => _records.put(record)),
      );

  Future<void> delete() => guardStorage(
        'delete learner profile',
        () => _isar.writeTxn(() => _records.delete(LearnerProfileRecord.singletonId)),
      );
}
