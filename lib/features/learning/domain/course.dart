import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';

/// A course for one exam section: an ordered syllabus of topics.
@immutable
class Course {
  const Course({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.topics,
  });

  final String id;

  /// The exam section this course prepares for (see ExamPattern).
  final String sectionId;
  final String title;
  final String description;

  /// Looked up with `AppIcons.forKey`.
  final String iconKey;

  /// The full syllabus in teaching order, including topics not written yet.
  final List<Topic> topics;

  /// Every lesson that exists, in syllabus order.
  List<Lesson> get lessons => [for (final topic in topics) ...topic.lessons];

  List<Topic> get availableTopics => [for (final t in topics) if (t.isAvailable) t];

  int get totalMinutes => lessons.fold(0, (sum, lesson) => sum + lesson.estimatedMinutes);
}

/// One syllabus topic: a few lessons, then a checkpoint quiz.
/// A topic with no lessons yet is part of the map but shown as "Coming soon".
@immutable
class Topic {
  const Topic({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.lessons,
    this.checkpoint,
  });

  final String id;
  final String courseId;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final Checkpoint? checkpoint;

  bool get isAvailable => lessons.isNotEmpty;

  /// Every question in the topic (lessons and checkpoint), used for mastery.
  List<String> get questionIds => [
        for (final lesson in lessons)
          for (final activity in lesson.activities)
            if (activity is QuestionActivity) activity.id,
        ...?checkpoint?.questions.map((q) => q.activity.id),
      ];
}

/// The short quiz at the end of a topic. Passing it masters the topic.
@immutable
class Checkpoint {
  const Checkpoint({required this.topicId, required this.passPercent, required this.questions});

  final String topicId;
  final int passPercent;
  final List<AssessmentQuestion> questions;

  /// Minimum correct answers needed to pass, rounded up.
  int get passMark => (questions.length * passPercent / 100).ceil();

  bool passes(int correct) => correct >= passMark;
}
