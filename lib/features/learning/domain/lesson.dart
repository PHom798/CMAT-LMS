import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/multiple_choice_question.dart';

/// One short, interactive lesson: a list of activities played in order.
@immutable
class Lesson {
  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.objective,
    required this.estimatedMinutes,
    required this.activities,
  });

  /// Stable id, stored with every attempt. Never change it once shipped.
  final String id;
  final String courseId;
  final String title;

  /// One sentence shown on the lesson intro: what the learner will be able to do.
  final String objective;
  final int estimatedMinutes;
  final List<LessonActivity> activities;

  int get questionCount => activities.whereType<QuestionActivity>().length;
}

/// A single screen inside a lesson.
///
/// To add a new interaction type: add a subclass here, parse it in
/// `data/content_parser.dart`, render it in `presentation/activities/`.
/// The compiler then points at every switch that must handle it.
sealed class LessonActivity {
  const LessonActivity();
}

/// Short explanation the learner reads, then taps Continue.
final class ConceptActivity extends LessonActivity {
  const ConceptActivity({
    required this.title,
    required this.body,
    this.example,
    this.exampleLabel,
    this.exampleIsCode = false,
  });

  final String title;
  final String body;

  /// Optional worked example shown under the body.
  final String? example;
  final String? exampleLabel;
  final bool exampleIsCode;
}

/// Any activity with a right answer chosen from [choices].
sealed class QuestionActivity extends LessonActivity {
  const QuestionActivity();

  /// Stable id: every answer is saved against it. Never change it once shipped.
  String get id;
  String get prompt;
  List<String> get choices;
  int get correctIndex;
  String get explanation;
  String? get hint;

  bool isCorrect(int choiceIndex) => choiceIndex == correctIndex;
  String get correctChoice => choices[correctIndex];
}

final class MultipleChoiceActivity extends QuestionActivity {
  const MultipleChoiceActivity(this.question);

  final MultipleChoiceQuestion question;

  @override
  String get id => question.id;
  @override
  String get prompt => question.prompt;
  @override
  List<String> get choices => question.options;
  @override
  int get correctIndex => question.correctIndex;
  @override
  String get explanation => question.explanation;
  @override
  String? get hint => question.hint;
}

/// A sentence (or code line) with one blank; the learner taps the word
/// that completes it.
final class FillInBlankActivity extends QuestionActivity {
  const FillInBlankActivity({
    required this.id,
    required this.prompt,
    required this.textBefore,
    required this.textAfter,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    this.hint,
    this.label,
    this.isCode = false,
  });

  @override
  final String id;
  @override
  final String prompt;
  final String textBefore;
  final String textAfter;

  /// Small label above the sentence (e.g. "Python").
  final String? label;

  /// Render as a dark code line instead of a sentence card.
  final bool isCode;

  @override
  final List<String> choices;
  @override
  final int correctIndex;
  @override
  final String explanation;
  @override
  final String? hint;
}
