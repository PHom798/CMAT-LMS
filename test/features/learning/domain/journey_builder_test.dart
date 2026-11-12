import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/multiple_choice_question.dart';

import '../../../helpers/test_data.dart';

MultipleChoiceActivity _q(String id) => MultipleChoiceActivity(
      MultipleChoiceQuestion(id: id, prompt: 'Q', options: const ['a', 'b'], correctIndex: 0, explanation: 'e'),
    );

Lesson _lesson(String id) => Lesson(
      id: id,
      courseId: 'c',
      title: id,
      objective: 'o',
      estimatedMinutes: 5,
      activities: [_q('$id-q')],
    );

Topic _topic(String id, {List<String> lessons = const [], bool checkpoint = true}) => Topic(
      id: id,
      courseId: 'c',
      title: id,
      description: 'd',
      lessons: [for (final l in lessons) _lesson(l)],
      checkpoint: checkpoint && lessons.isNotEmpty
          ? Checkpoint(
              topicId: id,
              passPercent: 60,
              questions: [AssessmentQuestion(sectionId: 's', activity: _q('$id-cp'))],
            )
          : null,
    );

/// Topics: A (2 lessons + checkpoint), B (coming soon), C (1 lesson + checkpoint).
final _course = Course(
  id: 'c',
  sectionId: 's',
  title: 'C',
  description: 'd',
  iconKey: 's',
  topics: [
    _topic('A', lessons: ['a1', 'a2']),
    _topic('B'),
    _topic('C', lessons: ['c1']),
  ],
);

LearningHistory _history({List<String> lessons = const [], List<String> passed = const []}) => LearningHistory(
      attempts: [for (final l in lessons) testAttempt(lessonId: l, courseId: 'c')],
      checkpoints: [
        for (final t in passed)
          CheckpointResult(topicId: t, correct: 1, total: 1, passed: true, xpEarned: 20, completedAt: testNow),
      ],
    );

void main() {
  test('only the first step is open at the start', () {
    final journey = JourneyBuilder.build(_course, const LearningHistory());
    final states = journey.steps.map((s) => s.state).toList();
    expect(states, [JourneyStepState.available, JourneyStepState.locked, JourneyStepState.locked, JourneyStepState.locked, JourneyStepState.locked]);
    expect((journey.nextStep! as LessonStep).lesson.id, 'a1');
  });

  test("a topic's checkpoint opens after its lessons", () {
    final journey = JourneyBuilder.build(_course, _history(lessons: ['a1', 'a2']));
    expect(journey.nextStep, isA<CheckpointStep>());
    expect(journey.nextStep!.topic.id, 'A');
  });

  test('passing the checkpoint masters the topic and skips past coming-soon topics', () {
    final journey = JourneyBuilder.build(_course, _history(lessons: ['a1', 'a2'], passed: ['A']));
    expect(journey.topics[0].isMastered, isTrue);
    expect(journey.topics[1].isComingSoon, isTrue);
    expect((journey.nextStep! as LessonStep).lesson.id, 'c1', reason: 'coming soon never blocks');
    expect(journey.masteredTopicCount, 1);
    expect(journey.comingSoonCount, 1);
  });

  test('everything done means no next step', () {
    final journey = JourneyBuilder.build(_course, _history(lessons: ['a1', 'a2', 'c1'], passed: ['A', 'C']));
    expect(journey.nextStep, isNull);
    expect(journey.isComplete, isTrue);
  });

  test('mastery is the share of questions whose latest answer is right', () {
    final history = LearningHistory(
      answers: [
        AnswerEntry(questionId: 'a1-q', isCorrect: true, answeredAt: testNow, source: AnswerSource.lesson),
        AnswerEntry(questionId: 'a2-q', isCorrect: true, answeredAt: testNow, source: AnswerSource.lesson),
        AnswerEntry(
          questionId: 'a2-q',
          isCorrect: false,
          answeredAt: testNow.add(const Duration(hours: 1)),
          source: AnswerSource.checkpoint,
        ),
      ],
    );
    final topicA = JourneyBuilder.build(_course, history).topics.first;
    // Topic A has 3 questions (a1-q, a2-q, A-cp); only a1-q is right now.
    expect(topicA.mastery, closeTo(1 / 3, 0.001));
  });
}
