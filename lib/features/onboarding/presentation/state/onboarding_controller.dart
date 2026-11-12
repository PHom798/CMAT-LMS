import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/assessment.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/course.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/onboarding/domain/diagnostic_status.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_draft.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_progress.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_repository.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';

enum OnboardingLoadStatus { loading, ready, failure }

/// Where the learner is inside the diagnostic step.
enum DiagnosticPhase { intro, running, done }

/// What the big button at the bottom does right now.
enum OnboardingPrimaryAction {
  getStarted,
  next,
  startDiagnostic,
  checkAnswer,
  nextQuestion,
  finish,
}

/// State holder for the onboarding flow (provided with ChangeNotifierProvider).
///
/// Responsibilities:
/// * load content (exam pattern, diagnostic) and restore saved progress,
/// * save a checkpoint on every step change,
/// * hold the answers ([OnboardingDraft]) and run the diagnostic,
/// * decide what the primary action does and whether it is enabled,
/// * write the final LearnerProfile when onboarding completes.
///
/// Pure rules live in domain classes ([OnboardingDraft], [AssessmentRun]);
/// this class orchestrates them. It never touches Isar or widgets.
class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required OnboardingRepository onboardingRepository,
    required LearnerProfileRepository learnerProfileRepository,
    required ContentRepository contentRepository,
  })  : _onboardingRepository = onboardingRepository,
        _learnerProfileRepository = learnerProfileRepository,
        _contentRepository = contentRepository;

  final OnboardingRepository _onboardingRepository;
  final LearnerProfileRepository _learnerProfileRepository;
  final ContentRepository _contentRepository;

  OnboardingLoadStatus _loadStatus = OnboardingLoadStatus.loading;
  OnboardingStep _step = OnboardingStep.welcome;
  int _direction = 1;
  OnboardingDraft _draft = const OnboardingDraft();
  bool _isCompleting = false;
  bool _isDisposed = false;

  ExamPattern? _exam;
  List<Course> _courses = const [];
  List<AssessmentQuestion> _diagnosticQuestions = const [];
  AssessmentRun? _diagnosticRun;
  int _wrongAnswers = 0;

  /// Saves run one after another so an older checkpoint can never overwrite
  /// a newer one (or the completion flag).
  Future<void> _saveQueue = Future.value();

  // Companion (Kit) state: presentation-only, intentionally not persisted.
  int _foxPokes = 0;
  ExamSection? _activeSection;
  bool _hasExploredWelcome = false;
  int _reactionTick = 0;
  int _celebrationTick = 0;

  // ---------------------------------------------------------------------------
  // Read API
  // ---------------------------------------------------------------------------

  OnboardingLoadStatus get loadStatus => _loadStatus;
  OnboardingStep get step => _step;

  /// +1 when moving forward, -1 when moving back. Drives slide direction.
  int get direction => _direction;
  double get progress => _step.progress;
  OnboardingDraft get draft => _draft;
  bool get isCompleting => _isCompleting;

  /// Non-null once [loadStatus] is ready.
  ExamPattern get exam => _exam!;

  int get diagnosticQuestionCount => _diagnosticQuestions.length;
  AssessmentRun? get diagnosticRun => _diagnosticRun;
  int get wrongAnswers => _wrongAnswers;

  DiagnosticPhase get diagnosticPhase {
    if (_draft.diagnosticStatus != DiagnosticStatus.notTaken) return DiagnosticPhase.done;
    return _diagnosticRun == null ? DiagnosticPhase.intro : DiagnosticPhase.running;
  }

  /// The section to start with: weakest in the diagnostic, else the first.
  ExamSection get focusSection {
    final weakestId = _draft.diagnosticResult?.weakest?.sectionId;
    return (weakestId == null ? null : exam.sectionById(weakestId)) ?? exam.sections.first;
  }

  /// The real course for [focusSection], previewed on the ready step.
  Course? get focusCourse {
    for (final course in _courses) {
      if (course.sectionId == focusSection.id) return course;
    }
    return _courses.isEmpty ? null : _courses.first;
  }

  int get foxPokes => _foxPokes;
  ExamSection? get activeSection => _activeSection;
  bool get hasExploredWelcome => _hasExploredWelcome;

  /// Bumped whenever Kit should replay a reaction, even if the mood is the same.
  int get reactionTick => _reactionTick;

  /// Bumped when the UI should celebrate (confetti).
  int get celebrationTick => _celebrationTick;

  /// Whether "Skip for now" is offered (diagnostic intro only).
  bool get canSkipDiagnostic => _step == OnboardingStep.diagnostic && diagnosticPhase == DiagnosticPhase.intro;

  OnboardingPrimaryAction get primaryAction {
    switch (_step) {
      case OnboardingStep.welcome:
        return OnboardingPrimaryAction.getStarted;
      case OnboardingStep.diagnostic:
        return switch (diagnosticPhase) {
          DiagnosticPhase.intro => OnboardingPrimaryAction.startDiagnostic,
          DiagnosticPhase.running => _diagnosticRun!.canAdvance
              ? OnboardingPrimaryAction.nextQuestion
              : OnboardingPrimaryAction.checkAnswer,
          DiagnosticPhase.done => OnboardingPrimaryAction.next,
        };
      case OnboardingStep.ready:
        return OnboardingPrimaryAction.finish;
      default:
        return OnboardingPrimaryAction.next;
    }
  }

  bool get canPerformPrimaryAction {
    if (_isCompleting) return false;
    return switch (primaryAction) {
      OnboardingPrimaryAction.startDiagnostic => _diagnosticQuestions.isNotEmpty,
      OnboardingPrimaryAction.checkAnswer => _diagnosticRun?.canCheck ?? false,
      OnboardingPrimaryAction.nextQuestion => true,
      OnboardingPrimaryAction.finish => _draft.isComplete,
      _ => _draft.hasAnswered(_step),
    };
  }

  /// Whether the learner has done what the current step needs to move on.
  bool get canLeaveCurrentStep => _draft.hasAnswered(_step);

  // ---------------------------------------------------------------------------
  // Loading & persistence
  // ---------------------------------------------------------------------------

  Future<void> restore() async {
    _loadStatus = OnboardingLoadStatus.loading;
    _notify();
    try {
      _exam = await _contentRepository.getExamPattern();
      _courses = await _contentRepository.getCourses();
      _diagnosticQuestions = await _contentRepository.getDiagnosticQuestions();
      final progress = await _onboardingRepository.getProgress();
      _draft = progress.draft;
      _step = _resumableStep(progress.currentStep);
      _loadStatus = OnboardingLoadStatus.ready;
    } on Object catch (error, stackTrace) {
      debugPrint('Onboarding restore failed: $error\n$stackTrace');
      _loadStatus = OnboardingLoadStatus.failure;
    }
    _notify();
  }

  /// Persists the current step and answers. Safe to call any time (e.g. when
  /// the app goes to the background). An unfinished diagnostic is not saved;
  /// it restarts from its intro. Failures are logged, not fatal.
  Future<void> saveCheckpoint() {
    final progress = OnboardingProgress(currentStep: _step, draft: _draft);
    return _enqueueSave(() => _onboardingRepository.saveProgress(progress));
  }

  Future<void> _enqueueSave(Future<void> Function() save) {
    _saveQueue = _saveQueue.then((_) async {
      try {
        await save();
      } on Object catch (error, stackTrace) {
        debugPrint('Onboarding save failed: $error\n$stackTrace');
      }
    });
    return _saveQueue;
  }

  /// Never resume on a step whose earlier answers are missing (e.g. data
  /// dropped after an app update); fall back to the first unanswered step.
  OnboardingStep _resumableStep(OnboardingStep saved) {
    for (final step in OnboardingStep.values) {
      if (step == saved) return saved;
      if (!_draft.hasAnswered(step)) return step;
    }
    return saved;
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void goNext() {
    final next = _step.next;
    if (next == null || _isCompleting || !canLeaveCurrentStep) return;
    _moveTo(next);
  }

  void goBack() {
    final previous = _step.previous;
    if (previous == null) return;
    _diagnosticRun = null; // leaving mid-diagnostic restarts it next time
    _moveTo(previous);
  }

  void _moveTo(OnboardingStep target) {
    _direction = target.index > _step.index ? 1 : -1;
    _step = target;
    if (target == OnboardingStep.ready) _celebrationTick++;
    _notify();
    saveCheckpoint();
  }

  // ---------------------------------------------------------------------------
  // Answers
  // ---------------------------------------------------------------------------

  void updateName(String value) {
    if (value == _draft.name) return;
    final hadName = _draft.firstName.isNotEmpty;
    _draft = _draft.copyWith(name: value);
    if (!hadName && _draft.firstName.isNotEmpty) _reactionTick++;
    _notify();
  }

  void selectExamTimeframe(ExamTimeframe timeframe) {
    if (timeframe == _draft.examTimeframe) return;
    _draft = _draft.copyWith(examTimeframe: timeframe);
    _reactionTick++;
    _notify();
  }

  void selectDailyGoal(DailyGoal goal) {
    if (goal == _draft.dailyGoal) return;
    _draft = _draft.copyWith(dailyGoal: goal);
    _reactionTick++;
    _notify();
  }

  // ---------------------------------------------------------------------------
  // Diagnostic
  // ---------------------------------------------------------------------------

  void startDiagnostic() {
    if (_diagnosticQuestions.isEmpty || diagnosticPhase != DiagnosticPhase.intro) return;
    _diagnosticRun = AssessmentRun(_diagnosticQuestions);
    _wrongAnswers = 0;
    _reactionTick++;
    _notify();
  }

  void selectDiagnosticAnswer(int index) {
    final run = _diagnosticRun;
    if (run == null) return;
    run.select(index);
    _notify();
  }

  /// Returns the result so the UI can play matching haptics.
  AnswerStatus checkDiagnosticAnswer() {
    final run = _diagnosticRun;
    if (run == null || !run.canCheck) return run?.status ?? AnswerStatus.unanswered;
    final status = run.check();
    if (status == AnswerStatus.incorrect) _wrongAnswers++;
    _reactionTick++;
    _notify();
    return status;
  }

  void nextDiagnosticQuestion() {
    final run = _diagnosticRun;
    if (run == null || !run.canAdvance) return;
    run.advance();
    if (run.isFinished) {
      _draft = _draft.withDiagnosticCompleted(run.result([for (final s in exam.sections) s.id]));
      _diagnosticRun = null;
      _celebrationTick++;
      saveCheckpoint();
    }
    _reactionTick++;
    _notify();
  }

  /// Skips the diagnostic and moves on. The learner starts from the basics.
  void skipDiagnostic() {
    if (!canSkipDiagnostic) return;
    _draft = _draft.withDiagnosticSkipped();
    goNext();
  }

  // ---------------------------------------------------------------------------
  // Welcome interactions
  // ---------------------------------------------------------------------------

  void pokeFox() {
    _foxPokes++;
    _activeSection = null;
    _hasExploredWelcome = true;
    _reactionTick++;
    _notify();
  }

  void exploreSection(ExamSection section) {
    _activeSection = section;
    _hasExploredWelcome = true;
    _reactionTick++;
    _notify();
  }

  // ---------------------------------------------------------------------------
  // Completion
  // ---------------------------------------------------------------------------

  /// Saves the learner profile and marks onboarding as completed.
  /// Returns false (and keeps the learner on this screen) if saving fails.
  Future<bool> completeOnboarding() async {
    if (_isCompleting || !_draft.isComplete) return false;
    _isCompleting = true;
    _notify();
    try {
      await _saveQueue; // let pending checkpoints land first
      await _learnerProfileRepository.saveProfile(_draft.toLearnerProfile());
      await _enqueueSaveOrThrow(_onboardingRepository.markCompleted);
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('Completing onboarding failed: $error\n$stackTrace');
      return false;
    } finally {
      _isCompleting = false;
      _notify();
    }
  }

  /// Like [_enqueueSave] but lets the error reach the caller.
  Future<void> _enqueueSaveOrThrow(Future<void> Function() save) {
    final result = _saveQueue.then((_) => save());
    _saveQueue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
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
