import 'package:w3_lms/core/mascot/fox_line.dart';
import 'package:w3_lms/core/mascot/fox_mascot.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';

const _praise = ['Nailed it!', 'Exactly right!', "You're on a roll!", 'Sharp thinking!'];
const _conceptLines = [
  'Have a read, then tap Continue.',
  'This bit is important. Take your time.',
  "Almost there. Here's one more idea.",
];

/// All of Kit's lines during a lesson, derived from controller state.
FoxLine lessonKitLine(LessonSessionController c) {
  switch (c.phase) {
    case LessonPhase.loading || LessonPhase.unavailable:
      return const FoxLine(FoxMood.idle, '');
    case LessonPhase.intro:
      return c.isReplay
          ? const FoxLine(FoxMood.happy, 'Back for practice? Replays earn half XP.')
          : FoxLine(FoxMood.wave, 'Ready? This one takes about ${c.lesson.estimatedMinutes} minutes.');
    case LessonPhase.saving:
      return const FoxLine(FoxMood.idea, 'Saving your progress…');
    case LessonPhase.saveFailed:
      return const FoxLine(FoxMood.oops, "Hmm, I couldn't save that. Let's try again.");
    case LessonPhase.complete:
      final unlocked = c.completion?.achievementsUnlockedNow ?? const [];
      if (unlocked.isNotEmpty) {
        return FoxLine(FoxMood.cheer, 'Achievement unlocked: ${unlocked.last.title}!');
      }
      final attempt = c.completion?.attempt;
      return attempt != null && attempt.isPerfect
          ? const FoxLine(FoxMood.cheer, 'A perfect lesson! Not a single slip.')
          : const FoxLine(FoxMood.cheer, 'Lesson done! Every step counts.');
    case LessonPhase.playing:
      return _playingLine(c);
  }
}

FoxLine _playingLine(LessonSessionController c) {
  final run = c.run;
  if (run.current is ConceptActivity) {
    return FoxLine(FoxMood.idea, _conceptLines[run.currentIndex % _conceptLines.length]);
  }
  switch (run.status) {
    case AnswerStatus.correct:
      return FoxLine(FoxMood.cheer, _praise[c.stepNumber % _praise.length]);
    case AnswerStatus.incorrect:
      return const FoxLine(FoxMood.oops, "Not quite. We'll come back to this one.");
    case AnswerStatus.unanswered:
      if (run.isReview) return const FoxLine(FoxMood.curious, "Let's try this one again.");
      if (run.selectedChoice != null) return const FoxLine(FoxMood.curious, 'Locked in? Tap Check.');
      return const FoxLine(FoxMood.curious, 'Your turn!');
  }
}
