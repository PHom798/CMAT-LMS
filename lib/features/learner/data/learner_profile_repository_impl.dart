import 'package:w3_lms/features/learner/data/learner_profile_local_data_source.dart';
import 'package:w3_lms/features/learner/data/learner_profile_mapper.dart';
import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';

/// Local-first implementation: Isar is the source of truth.
///
/// When sync is introduced, add a remote data source here and keep the
/// public contract unchanged; callers will not notice.
class LearnerProfileRepositoryImpl implements LearnerProfileRepository {
  const LearnerProfileRepositoryImpl(this._local);

  final LearnerProfileLocalDataSource _local;

  @override
  Future<LearnerProfile?> getProfile() async => (await _local.read())?.toDomain();

  @override
  Future<void> saveProfile(LearnerProfile profile) async {
    final existing = await _local.read();
    await _local.write(profile.toRecord(existing: existing));
  }

  @override
  Future<void> clear() => _local.delete();
}
