import 'dart:async';

import 'package:isar_community/isar.dart';

import 'package:w3_lms/core/database/local_storage_exception.dart';
import 'package:w3_lms/features/learning/data/learning_records.dart';

/// Raw history rows, read in one go.
class LearningRows {
  const LearningRows({required this.attempts, required this.answers, required this.checkpoints});

  final List<LessonAttemptRecord> attempts;
  final List<AnswerRecord> answers;
  final List<CheckpointResultRecord> checkpoints;
}

/// The only class that talks to Isar about learning history.
class LearningProgressLocalDataSource {
  const LearningProgressLocalDataSource(this._isar);

  final Isar _isar;

  IsarCollection<LessonAttemptRecord> get _attempts => _isar.lessonAttemptRecords;
  IsarCollection<AnswerRecord> get _answers => _isar.answerRecords;
  IsarCollection<CheckpointResultRecord> get _checkpoints => _isar.checkpointResultRecords;

  Future<LearningRows> readAll() => guardStorage('read learning history', () async {
        return LearningRows(
          attempts: await _attempts.where().findAll(),
          answers: await _answers.where().findAll(),
          checkpoints: await _checkpoints.where().findAll(),
        );
      });

  /// Fires (with no data) whenever any history collection changes.
  Stream<void> changes() {
    final controller = StreamController<void>.broadcast();
    final subscriptions = <StreamSubscription<void>>[];
    controller
      ..onListen = () {
        for (final stream in [_attempts.watchLazy(), _answers.watchLazy(), _checkpoints.watchLazy()]) {
          subscriptions.add(stream.listen(controller.add, onError: controller.addError));
        }
      }
      ..onCancel = () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
        subscriptions.clear();
      };
    return controller.stream;
  }

  Future<void> addLesson(LessonAttemptRecord attempt, List<AnswerRecord> answers) => guardStorage(
        'save lesson',
        () => _isar.writeTxn(() async {
          await _attempts.put(attempt);
          await _answers.putAll(answers);
        }),
      );

  Future<void> addCheckpoint(CheckpointResultRecord result, List<AnswerRecord> answers) => guardStorage(
        'save checkpoint',
        () => _isar.writeTxn(() async {
          await _checkpoints.put(result);
          await _answers.putAll(answers);
        }),
      );

  Future<void> addAnswers(List<AnswerRecord> answers) => guardStorage(
        'save answers',
        () => _isar.writeTxn(() => _answers.putAll(answers)),
      );

  Future<void> clear() => guardStorage(
        'clear learning history',
        () => _isar.writeTxn(() async {
          await _attempts.clear();
          await _answers.clear();
          await _checkpoints.clear();
        }),
      );
}
