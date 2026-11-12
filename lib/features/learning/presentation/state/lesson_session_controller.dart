import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/achievement.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/daily_quest.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_summary.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_attempt.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/domain/lesson_scoring.dart';
import 'package:w3_lms/features/learning/domain/progress_calculator.dart';

enum LessonPhase { loading, unavailable, intro, playing, saving, saveFailed, complete }

/// What the bottom button does right now.
enum LessonPrimaryAction { start, check, next, retrySave, finish }

/// Results shown on the completion screen: the saved attempt plus progress
/// before and after it, so we can show what changed (quests, level, streak).
@immutable
class LessonCompletion {
  const LessonCompletion({required this.attempt, required this.before, required this.after});

  final LessonAttempt attempt;
  final LearningSummary before;
  final LearningSummary after;

  /// Lesson XP plus any daily-quest rewards this lesson unlocked.
  int get totalXpGained => after.totalXp - before.totalXp;
  bool get leveledUp => after.level.level > before.level.level;
  bool get startedStreakToday => !before.streak.isActiveToday && after.streak.isActiveToday;

  List<Achievement> get achievementsUnlockedNow => [
        for (final achievement in after.achievements)
          if (achievement.isEarned &&
              !before.achievements.any((a) => a.id == achievement.id && a.isEarned))
            achievement,
      ];

  List<DailyQuest> get questsCompletedNow => [
        for (final quest in after.todayQuests)
          if (quest.isComplete &&
              !before.todayQuests.any((q) => q.type == quest.type && q.isComplete))
            quest,
      ];
}

/// Drives one lesson from intro to completion (provided per lesson screen).
///
/// Answer rules live in [LessonRun], XP rules in [LessonScoring], progress
/// in [ProgressCalculator]. This class wires them to repositories and the UI.
class LessonSessionController extends ChangeNotifier {
  LessonSessionController({
    required this.lessonId,
    required ContentRepository contentRepository,
    required LearningProgressRepository progressRepository,
    required LearnerProfileRepository learnerProfileRepository,
    DateTime Function()? clock,
  })  : _contentRepository = contentRepository,
        _progressRepository = progressRepository,
        _learnerProfileRepository = learnerProfileRepository,
        _clock = clock ?? DateTime.now;

  final String lessonId;
  final ContentRepository _contentRepository;
  final LearningProgressRepository _progressRepository;
  final LearnerProfileRepository _learnerProfileRepository;
  final DateTime Function() _clock;

  LessonPhase _phase = LessonPhase.loading;
  Lesson? _lesson;
  Course? _course;
  LearnerProfile? _profile;
  bool _isReplay = false;
  LessonRun? _run;
  DateTime? _startedAt;
  LessonAttempt? _pendingAttempt;
  List<AnswerEntry>? _pendingAnswers;
  LessonCompletion? _completion;
  bool _isDisposed = false;

  int _stepNumber = 0;
  int _wrongAnswers = 0;
  int _reactionTick = 0;
  int _celebrationTick = 0;

  // ---------------------------------------------------------------------------
  // Read API
  // ---------------------------------------------------------------------------

  LessonPhase get phase => _phase;
  Lesson get lesson => _lesson!;
  Course? get course => _course;
  bool get isReplay => _isReplay;
  LessonRun get run => _run!;
  LessonCompletion? get completion => _completion;

  int get maxXp => LessonScoring.maxXpFor(questionCount: lesson.questionCount, isReplay: _isReplay);

  /// Changes on every advance; keys the activity transition.
  int get stepNumber => _stepNumber;

  /// Increases on every wrong answer; drives the shake animation.
  int get wrongAnswers => _wrongAnswers;
  int get reactionTick => _reactionTick;
  int get celebrationTick => _celebrationTick;

  /// Leaving now would lose answers, so the UI should confirm first.
  bool get shouldConfirmExit => _phase == LessonPhase.playing;

  LessonPrimaryAction get primaryAction => switch (_phase) {
        LessonPhase.intro => LessonPrimaryAction.start,
        LessonPhase.saveFailed => LessonPrimaryAction.retrySave,
        LessonPhase.complete => LessonPrimaryAction.finish,
        _ => _run != null && _run!.canAdvance ? LessonPrimaryAction.next : LessonPrimaryAction.check,
      };

  bool get canPerformPrimaryAction => switch (primaryAction) {
        LessonPrimaryAction.check => _phase == LessonPhase.playing && run.canCheck,
        LessonPrimaryAction.next => _phase == LessonPhase.playing,
        _ => _phase != LessonPhase.saving,
      };

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> load() async {
    try {
      final lesson = await _contentRepository.getLesson(lessonId);
      final profile = await _learnerProfileRepository.getProfile();
      if (lesson == null || profile == null) {
        _phase = LessonPhase.unavailable;
      } else {
        _lesson = lesson;
        _profile = profile;
        _course = await _contentRepository.getCourse(lesson.courseId);
        final history = await _progressRepository.getHistory();
        _isReplay = history.completedLessonIds.contains(lessonId);
        _phase = LessonPhase.intro;
      }
    } on Object catch (error, stackTrace) {
      debugPrint('Loading lesson $lessonId failed: $error\n$stackTrace');
      _phase = LessonPhase.unavailable;
    }
    _notify();
  }

  void start() {
    if (_phase != LessonPhase.intro) return;
    _run = LessonRun(lesson);
    _startedAt = _clock();
    _phase = LessonPhase.playing;
    _reactionTick++;
    _notify();
  }

  void selectChoice(int index) {
    if (_phase != LessonPhase.playing) return;
    run.select(index);
    _notify();
  }

  AnswerStatus checkAnswer() {
    if (_phase != LessonPhase.playing || !run.canCheck) return run.status;
    final status = run.check();
    if (status == AnswerStatus.incorrect) _wrongAnswers++;
    _reactionTick++;
    _notify();
    return status;
  }

  Future<void> advance() async {
    if (_phase != LessonPhase.playing || !run.canAdvance) return;
    run.advance();
    _stepNumber++;
    if (run.isFinished) {
      await _saveCompletion();
    } else {
      _notify();
    }
  }

  Future<void> retrySave() => _saveCompletion();

  Future<void> _saveCompletion() async {
    _phase = LessonPhase.saving;
    _notify();
    try {
      // Build once, so a retry saves exactly the same attempt and answers.
      final attempt = _pendingAttempt ??= _buildAttempt();
      _pendingAnswers ??= [
        for (final entry in run.firstTryResults.entries)
          AnswerEntry(
            questionId: entry.key,
            isCorrect: entry.value,
            answeredAt: attempt.completedAt,
            source: AnswerSource.lesson,
          ),
      ];
      final courses = await _contentRepository.getCourses();
      final before = _summarize(courses, await _progressRepository.getHistory());
      await _progressRepository.recordLesson(attempt, _pendingAnswers!);
      final after = _summarize(courses, await _progressRepository.getHistory());

      _completion = LessonCompletion(attempt: attempt, before: before, after: after);
      _phase = LessonPhase.complete;
      _celebrationTick++;
      _reactionTick++;
    } on Object catch (error, stackTrace) {
      debugPrint('Saving lesson $lessonId failed: $error\n$stackTrace');
      _phase = LessonPhase.saveFailed;
      _reactionTick++;
    }
    _notify();
  }

  LessonAttempt _buildAttempt() {
    final completedAt = _clock();
    return LessonAttempt(
      lessonId: lesson.id,
      courseId: lesson.courseId,
      completedAt: completedAt,
      questionCount: run.questionCount,
      firstTryCorrect: run.firstTryCorrect,
      xpEarned: LessonScoring.xpFor(
        firstTryCorrect: run.firstTryCorrect,
        questionCount: run.questionCount,
        isReplay: _isReplay,
      ),
      duration: completedAt.difference(_startedAt ?? completedAt),
      estimatedMinutes: lesson.estimatedMinutes,
    );
  }

  LearningSummary _summarize(List<Course> courses, LearningHistory history) =>
      ProgressCalculator.summarize(profile: _profile!, courses: courses, history: history, now: _clock());

  void _notify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
