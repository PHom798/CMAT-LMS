import 'package:isar_community/isar.dart';

part 'learning_records.g.dart';

// Isar storage shapes for learning history. Data-layer only. All three
// collections are append-only, which keeps future sync simple.

/// One row per finished lesson.
@collection
class LessonAttemptRecord {
  Id id = Isar.autoIncrement;

  String lessonId = '';
  String courseId = '';
  DateTime completedAt = DateTime.now();
  int questionCount = 0;
  int firstTryCorrect = 0;
  int xpEarned = 0;
  int durationSeconds = 0;
  int estimatedMinutes = 0;
}

/// One row per answered question (first tries in lessons, every answer in
/// checkpoints and reviews).
@collection
class AnswerRecord {
  Id id = Isar.autoIncrement;

  String questionId = '';
  bool isCorrect = false;
  DateTime answeredAt = DateTime.now();

  /// `AnswerSource.name`: lesson, checkpoint or review.
  String sourceName = 'lesson';
}

/// One row per finished topic checkpoint.
@collection
class CheckpointResultRecord {
  Id id = Isar.autoIncrement;

  String topicId = '';
  int correct = 0;
  int total = 0;
  bool passed = false;
  int xpEarned = 0;
  DateTime completedAt = DateTime.now();
}
