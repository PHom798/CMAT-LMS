import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';

//enum StepState { locked, available, completed }
enum JourneyStepState { completed, available, locked }

/// One stop on a section's path: a lesson or a topic checkpoint.
@immutable
sealed class JourneyStep {
  const JourneyStep({required this.topic, required this.state});

  final Topic topic;
  final JourneyStepState state;

  bool get isLocked => state == JourneyStepState.locked;
  bool get isCompleted => state == JourneyStepState.completed;
  String get title;
}

final class LessonStep extends JourneyStep {
  const LessonStep({required super.topic, required super.state, required this.lesson});

  final Lesson lesson;

  @override
  String get title => lesson.title;
}

final class CheckpointStep extends JourneyStep {
  const CheckpointStep({
    required super.topic,
    required super.state,
    required this.checkpoint,
    this.bestCorrect,
  });

  final Checkpoint checkpoint;

  /// Best score so far, or null if never taken.
  final int? bestCorrect;

  @override
  String get title => '${topic.title} checkpoint';
}

/// A topic on the path with its steps and mastery.
@immutable
class TopicJourney {
  const TopicJourney({required this.topic, required this.steps, required this.mastery});

  final Topic topic;
  final List<JourneyStep> steps;

  /// 0..1: share of the topic's questions whose latest answer is correct.
  final double mastery;

  bool get isComingSoon => !topic.isAvailable;

  /// Mastered = checkpoint passed (or, for a topic without one, every lesson done).
  bool get isMastered => steps.isNotEmpty && steps.every((s) => s.isCompleted);
}

/// A whole section's path, ready to draw.
@immutable
class SectionJourney {
  const SectionJourney({required this.course, required this.topics, required this.mastery});

  final Course course;
  final List<TopicJourney> topics;

  /// 0..1 across every question in the section's available topics.
  final double mastery;

  List<JourneyStep> get steps => [for (final t in topics) ...t.steps];

  /// The first step not completed yet (the learner's "you are here").
  JourneyStep? get nextStep {
    for (final step in steps) {
      if (!step.isCompleted) return step;
    }
    return null;
  }

  int get availableTopicCount => topics.where((t) => !t.isComingSoon).length;
  int get comingSoonCount => topics.where((t) => t.isComingSoon).length;
  int get masteredTopicCount => topics.where((t) => t.isMastered).length;
  bool get isComplete => steps.isNotEmpty && nextStep == null;
}

/// Builds the path for a section from its syllabus and the learner's
/// history. Pure, so unlock rules are fully unit-tested.
///
/// Unlock rule: steps open one after another in syllabus order (lessons,
/// then the topic's checkpoint, then the next topic). Completed steps can
/// always be replayed. Topics that aren't written yet ("coming soon") never
/// block the topics after them.
abstract final class JourneyBuilder {
  static SectionJourney build(Course course, LearningHistory history) {
    final completedLessons = history.completedLessonIds;
    final passedTopics = history.passedTopicIds;
    final latest = history.latestAnswers;
    final bestScores = <String, int>{};
    for (final result in history.checkpoints) {
      final best = bestScores[result.topicId];
      if (best == null || result.correct > best) bestScores[result.topicId] = result.correct;
    }

    var previousDone = true;
    var sectionQuestions = 0;
    var sectionMastered = 0;
    final topics = <TopicJourney>[];

    for (final topic in course.topics) {
      if (!topic.isAvailable) {
        topics.add(TopicJourney(topic: topic, steps: const [], mastery: 0));
        continue;
      }
      final steps = <JourneyStep>[];
      for (final lesson in topic.lessons) {
        final done = completedLessons.contains(lesson.id);
        steps.add(LessonStep(topic: topic, lesson: lesson, state: _state(done, previousDone)));
        previousDone = done;
      }
      final checkpoint = topic.checkpoint;
      if (checkpoint != null) {
        final passed = passedTopics.contains(topic.id);
        steps.add(CheckpointStep(
          topic: topic,
          checkpoint: checkpoint,
          state: _state(passed, previousDone),
          bestCorrect: bestScores[topic.id],
        ));
        previousDone = passed;
      }

      final questionIds = topic.questionIds;
      final mastered = questionIds.where((id) => latest[id]?.isCorrect ?? false).length;
      sectionQuestions += questionIds.length;
      sectionMastered += mastered;
      topics.add(TopicJourney(
        topic: topic,
        steps: steps,
        mastery: questionIds.isEmpty ? 0 : mastered / questionIds.length,
      ));
    }

    return SectionJourney(
      course: course,
      topics: topics,
      mastery: sectionQuestions == 0 ? 0 : sectionMastered / sectionQuestions,
    );
  }

  static JourneyStepState _state(bool done, bool previousDone) {
    if (done) return JourneyStepState.completed;
    return previousDone ? JourneyStepState.available : JourneyStepState.locked;
  }
}
