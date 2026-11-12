import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';

/// Read access to learning content: the exam pattern, courses, lessons and
/// the diagnostic. Today it is bundled with the app (fully offline); later
/// it can be downloaded and cached without changing callers.
abstract interface class ContentRepository {
  Future<ExamPattern> getExamPattern();

  /// One course per exam section, in exam order.
  Future<List<Course>> getCourses();

  Future<Course?> getCourse(String courseId);

  Future<Lesson?> getLesson(String lessonId);

  Future<Topic?> getTopic(String topicId);

  /// Lesson and checkpoint questions by id (unknown ids are skipped), tagged
  /// with their exam section. Used for mistake reviews.
  Future<List<AssessmentQuestion>> getQuestions(Iterable<String> questionIds);

  Future<List<AssessmentQuestion>> getDiagnosticQuestions();
}
