import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/domain/quiz_request.dart';

enum QuizPhase { loading, unavailable, intro, playing, saving, saveFailed, complete }

enum QuizPrimaryAction { start, check, next, retrySave, retake, finish }

/// What a finished quiz earned.
@immutable
class QuizOutcome {
  const QuizOutcome({
    required this.correct,
    required this.total,
    required this.xpEarned,
    this.passed,
    this.isNewlyMastered = false,
  });

  final int correct;
  final int total;
  final int xpEarned;

  /// Checkpoints only: whether the pass mark was reached.
  final bool? passed;

  /// Checkpoints only: passed for the first time.
  final bool isNewlyMastered;
}

/// Runs a topic checkpoint or a mistake review (provided per quiz screen).
///
/// Question rules live in [AssessmentRun]; this class loads the questions,
/// saves the answers and works out the outcome.
class QuizSessionController extends ChangeNotifier {
  QuizSessionController({
    required this.request,
    required ContentRepository contentRepository,
    required LearningProgressRepository progressRepository,
    DateTime Function()? clock,
  })  : _contentRepository = contentRepository,
        _progressRepository = progressRepository,
        _clock = clock ?? DateTime.now;

  final QuizRequest request;
  final ContentRepository _contentRepository;
  final LearningProgressRepository _progressRepository;
  final DateTime Function() _clock;

  QuizPhase _phase = QuizPhase.loading;
  Topic? _topic;
  List<AssessmentQuestion> _questions = const [];
  bool _alreadyPassed = false;
  AssessmentRun? _run;
  QuizOutcome? _outcome;
  bool _isDisposed = false;
  int _wrongAnswers = 0;
  int _reactionTick = 0;
  int _celebrationTick = 0;

  QuizPhase get phase => _phase;
  bool get isCheckpoint => request is CheckpointQuiz;

  /// Checkpoints only.
  Topic? get topic => _topic;
  Checkpoint? get checkpoint => _topic?.checkpoint;
  bool get alreadyPassed => _alreadyPassed;
  int get questionCount => _questions.length;
  AssessmentRun get run => _run!;
  QuizOutcome? get outcome => _outcome;
  int get wrongAnswers => _wrongAnswers;
  int get reactionTick => _reactionTick;
  int get celebrationTick => _celebrationTick;
  bool get shouldConfirmExit => _phase == QuizPhase.playing;

  QuizPrimaryAction get primaryAction => switch (_phase) {
        QuizPhase.intro => QuizPrimaryAction.start,
        QuizPhase.saveFailed => QuizPrimaryAction.retrySave,
        QuizPhase.complete =>
          _outcome?.passed == false ? QuizPrimaryAction.retake : QuizPrimaryAction.finish,
        _ => _run != null && _run!.canAdvance ? QuizPrimaryAction.next : QuizPrimaryAction.check,
      };

  bool get canPerformPrimaryAction => switch (primaryAction) {
        QuizPrimaryAction.check => _phase == QuizPhase.playing && run.canCheck,
        QuizPrimaryAction.next => _phase == QuizPhase.playing,
        _ => _phase != QuizPhase.saving,
      };

  Future<void> load() async {
    try {
      final history = await _progressRepository.getHistory();
      switch (request) {
        case CheckpointQuiz(:final topicId):
          _topic = await _contentRepository.getTopic(topicId);
          _questions = _topic?.checkpoint?.questions ?? const [];
          _alreadyPassed = history.passedTopicIds.contains(topicId);
        case MistakeReviewQuiz(:final maxQuestions):
          _questions = await _contentRepository.getQuestions(history.mistakeQuestionIds.take(maxQuestions));
      }
      _phase = _questions.isEmpty ? QuizPhase.unavailable : QuizPhase.intro;
    } on Object catch (error, stackTrace) {
      debugPrint('Loading quiz failed: $error\n$stackTrace');
      _phase = QuizPhase.unavailable;
    }
    _notify();
  }

  void start() {
    if (_phase != QuizPhase.intro && _phase != QuizPhase.complete) return;
    _run = AssessmentRun(_questions);
    _outcome = null;
    _wrongAnswers = 0;
    _phase = QuizPhase.playing;
    _reactionTick++;
    _notify();
  }

  void selectChoice(int index) {
    if (_phase != QuizPhase.playing) return;
    run.select(index);
    _notify();
  }

  AnswerStatus checkAnswer() {
    if (_phase != QuizPhase.playing || !run.canCheck) return run.status;
    final status = run.check();
    if (status == AnswerStatus.incorrect) _wrongAnswers++;
    _reactionTick++;
    _notify();
    return status;
  }

  Future<void> next() async {
    if (_phase != QuizPhase.playing || !run.canAdvance) return;
    run.advance();
    if (run.isFinished) {
      await _save();
    } else {
      _reactionTick++;
      _notify();
    }
  }

  Future<void> retrySave() => _save();

  Future<void> _save() async {
    _phase = QuizPhase.saving;
    _notify();
    final now = _clock();
    final correct = run.correctCount;
    final source = isCheckpoint ? AnswerSource.checkpoint : AnswerSource.review;
    final answers = [
      for (final entry in run.answersById.entries)
        AnswerEntry(questionId: entry.key, isCorrect: entry.value, answeredAt: now, source: source),
    ];
    try {
      final checkpoint = this.checkpoint;
      if (isCheckpoint && checkpoint != null) {
        final passed = checkpoint.passes(correct);
        final firstPass = passed && !_alreadyPassed;
        final xp = firstPass ? PracticeScoring.checkpointPassXp : 0;
        await _progressRepository.recordCheckpoint(
          CheckpointResult(
            topicId: checkpoint.topicId,
            correct: correct,
            total: run.total,
            passed: passed,
            xpEarned: xp,
            completedAt: now,
          ),
          answers,
        );
        _outcome = QuizOutcome(
          correct: correct,
          total: run.total,
          xpEarned: xp,
          passed: passed,
          isNewlyMastered: firstPass,
        );
        if (passed) _alreadyPassed = true;
      } else {
        await _progressRepository.recordReview(answers);
        _outcome = QuizOutcome(correct: correct, total: run.total, xpEarned: correct * PracticeScoring.reviewFixXp);
      }
      _phase = QuizPhase.complete;
      if (_outcome!.passed ?? correct > 0) _celebrationTick++;
    } on Object catch (error, stackTrace) {
      debugPrint('Saving quiz failed: $error\n$stackTrace');
      _phase = QuizPhase.saveFailed;
    }
    _reactionTick++;
    _notify();
  }

  void _notify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
