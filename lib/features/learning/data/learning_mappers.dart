import 'package:w3_lms/features/learning/data/learning_records.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';

extension LessonAttemptRecordMapper on LessonAttemptRecord {
  LessonAttempt toDomain() => LessonAttempt(
        lessonId: lessonId,
        courseId: courseId,
        completedAt: completedAt,
        questionCount: questionCount,
        firstTryCorrect: firstTryCorrect,
        xpEarned: xpEarned,
        duration: Duration(seconds: durationSeconds),
        estimatedMinutes: estimatedMinutes,
      );
}

extension LessonAttemptToRecord on LessonAttempt {
  LessonAttemptRecord toRecord() => LessonAttemptRecord()
    ..lessonId = lessonId
    ..courseId = courseId
    ..completedAt = completedAt
    ..questionCount = questionCount
    ..firstTryCorrect = firstTryCorrect
    ..xpEarned = xpEarned
    ..durationSeconds = duration.inSeconds
    ..estimatedMinutes = estimatedMinutes;
}

extension AnswerRecordMapper on AnswerRecord {
  AnswerEntry toDomain() => AnswerEntry(
        questionId: questionId,
        isCorrect: isCorrect,
        answeredAt: answeredAt,
        source: AnswerSource.values.firstWhere((s) => s.name == sourceName, orElse: () => AnswerSource.lesson),
      );
}

extension AnswerEntryToRecord on AnswerEntry {
  AnswerRecord toRecord() => AnswerRecord()
    ..questionId = questionId
    ..isCorrect = isCorrect
    ..answeredAt = answeredAt
    ..sourceName = source.name;
}

extension CheckpointResultRecordMapper on CheckpointResultRecord {
  CheckpointResult toDomain() => CheckpointResult(
        topicId: topicId,
        correct: correct,
        total: total,
        passed: passed,
        xpEarned: xpEarned,
        completedAt: completedAt,
      );
}

extension CheckpointResultToRecord on CheckpointResult {
  CheckpointResultRecord toRecord() => CheckpointResultRecord()
    ..topicId = topicId
    ..correct = correct
    ..total = total
    ..passed = passed
    ..xpEarned = xpEarned
    ..completedAt = completedAt;
}
