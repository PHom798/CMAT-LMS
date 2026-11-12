import 'package:w3_lms/features/onboarding/data/onboarding_local_data_source.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_progress_mapper.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_progress_record.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_progress.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._local);

  final OnboardingLocalDataSource _local;

  @override
  Future<OnboardingProgress> getProgress() async =>
      (await _local.read())?.toDomain() ?? const OnboardingProgress();

  @override
  Future<void> saveProgress(OnboardingProgress progress) async {
    final existing = await _local.read();
    await _local.write(progress.toRecord(existing: existing));
  }

  @override
  Future<void> markCompleted() async {
    final record = await _local.read() ?? OnboardingProgressRecord();
    final now = DateTime.now();
    await _local.write(
      record
        ..isCompleted = true
        ..completedAt = now
        ..updatedAt = now,
    );
  }

  @override
  Future<bool> isCompleted() async => (await _local.read())?.isCompleted ?? false;

  @override
  Future<void> reset() => _local.delete();
}
