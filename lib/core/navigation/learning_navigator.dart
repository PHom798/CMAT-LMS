/// Opens learning screens by id. Features call this abstraction; the app
/// layer decides which routes it maps to, so features never import each
/// other's screens.
abstract interface class LearningNavigator {
  /// Completes with true if the lesson was finished and saved.
  Future<bool> openLesson(String lessonId);

  /// Completes with true if the checkpoint was finished and saved.
  Future<bool> openCheckpoint(String topicId);

  /// Completes with true if a review session was finished and saved.
  Future<bool> openMistakeReview();

  /// The section's learning path. Completes when the learner leaves it.
  Future<void> openSection(String courseId);
}
