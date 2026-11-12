import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

/// Stores the learner's history: lesson attempts, every answer, and
/// checkpoint results. All progress is calculated from it.
abstract interface class LearningProgressRepository {
  Future<LearningHistory> getHistory();

  /// Emits the full history now and after every change, so any screen that
  /// listens updates automatically.
  Stream<LearningHistory> watchHistory();

  /// Saves a finished lesson and its first-try answers together (atomic).
  Future<void> recordLesson(LessonAttempt attempt, List<AnswerEntry> answers);

  /// Saves a finished checkpoint and its answers together (atomic).
  Future<void> recordCheckpoint(CheckpointResult result, List<AnswerEntry> answers);

  /// Saves the answers from a mistake-review session.
  Future<void> recordReview(List<AnswerEntry> answers);

  Future<void> clear();
}
