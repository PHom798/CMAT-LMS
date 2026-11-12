import 'dart:async';

import 'package:w3_lms/features/learning/data/learning_mappers.dart';
import 'package:w3_lms/features/learning/data/learning_progress_local_data_source.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

/// Local-first: Isar is the source of truth. Sync would add a remote data
/// source here; the interface stays the same.
class LearningProgressRepositoryImpl implements LearningProgressRepository {
  const LearningProgressRepositoryImpl(this._local);

  final LearningProgressLocalDataSource _local;

  @override
  Future<LearningHistory> getHistory() async {
    final rows = await _local.readAll();
    return LearningHistory(
      attempts: [for (final r in rows.attempts) r.toDomain()],
      answers: [for (final r in rows.answers) r.toDomain()],
      checkpoints: [for (final r in rows.checkpoints) r.toDomain()],
    );
  }

  /// Emits the history immediately, then again after each change. Reloads
  /// run one at a time so an older snapshot can never arrive last.
  @override
  Stream<LearningHistory> watchHistory() {
    late final StreamController<LearningHistory> controller;
    StreamSubscription<void>? changes;
    var queue = Future<void>.value();

    void reload() {
      queue = queue.then((_) async {
        try {
          final history = await getHistory();
          if (!controller.isClosed) controller.add(history);
        } on Object catch (error, stackTrace) {
          if (!controller.isClosed) controller.addError(error, stackTrace);
        }
      });
    }

    controller = StreamController<LearningHistory>(
      onListen: () {
        reload();
        changes = _local.changes().listen((_) => reload());
      },
      onCancel: () => changes?.cancel(),
    );
    return controller.stream;
  }

  @override
  Future<void> recordLesson(LessonAttempt attempt, List<AnswerEntry> answers) =>
      _local.addLesson(attempt.toRecord(), [for (final a in answers) a.toRecord()]);

  @override
  Future<void> recordCheckpoint(CheckpointResult result, List<AnswerEntry> answers) =>
      _local.addCheckpoint(result.toRecord(), [for (final a in answers) a.toRecord()]);

  @override
  Future<void> recordReview(List<AnswerEntry> answers) =>
      _local.addAnswers([for (final a in answers) a.toRecord()]);

  @override
  Future<void> clear() => _local.clear();
}
