import 'package:w3_lms/features/learning/domain/lesson.dart';

enum AnswerStatus { unanswered, correct, incorrect }

/// Plays one lesson: tracks the current activity, answer checking and
/// first-try results. Pure Dart, no Flutter, fully unit-tested.
///
/// Rule: a question answered wrong goes to the back of the queue, so the
/// lesson ends only when every question has been answered correctly once.
/// XP only counts first-try answers.
class LessonRun {
  LessonRun(this.lesson) : _queue = List.generate(lesson.activities.length, (i) => i);

  final Lesson lesson;
  final List<int> _queue;
  final Set<int> _finished = {};
  final Set<int> _attempted = {};
  final Set<int> _missedFirstTry = {};

  int? _selectedChoice;
  AnswerStatus _status = AnswerStatus.unanswered;

  bool get isFinished => _queue.isEmpty;

  /// Index into `lesson.activities` of the activity on screen.
  int get currentIndex => _queue.first;
  LessonActivity get current => lesson.activities[currentIndex];

  /// True when the current question is being retried after a miss.
  bool get isReview => _attempted.contains(currentIndex) && _status == AnswerStatus.unanswered;

  int? get selectedChoice => _selectedChoice;
  AnswerStatus get status => _status;

  /// 0..1, grows only when an activity is finished (retries don't count).
  double get progress =>
      lesson.activities.isEmpty ? 1 : _finished.length / lesson.activities.length;

  bool get canCheck =>
      !isFinished && current is QuestionActivity && _selectedChoice != null && _status == AnswerStatus.unanswered;

  bool get canAdvance =>
      !isFinished && (current is ConceptActivity || _status != AnswerStatus.unanswered);

  int get questionCount => lesson.questionCount;
  int get firstTryCorrect => questionCount - _missedFirstTry.length;

  /// First-try result of every question attempted so far, by question id.
  /// Only first tries are saved: they are what the learner really knew.
  Map<String, bool> get firstTryResults => {
        for (final index in _attempted)
          (lesson.activities[index] as QuestionActivity).id: !_missedFirstTry.contains(index),
      };

  void select(int choiceIndex) {
    if (isFinished || current is! QuestionActivity || _status != AnswerStatus.unanswered) return;
    _selectedChoice = choiceIndex;
  }

  AnswerStatus check() {
    if (!canCheck) return _status;
    final question = current as QuestionActivity;
    final isCorrect = question.isCorrect(_selectedChoice!);
    if (_attempted.add(currentIndex) && !isCorrect) _missedFirstTry.add(currentIndex);
    _status = isCorrect ? AnswerStatus.correct : AnswerStatus.incorrect;
    return _status;
  }

  void advance() {
    if (!canAdvance) return;
    final index = _queue.removeAt(0);
    if (_status == AnswerStatus.incorrect) {
      _queue.add(index); // try again at the end
    } else {
      _finished.add(index);
    }
    _selectedChoice = null;
    _status = AnswerStatus.unanswered;
  }
}
