import 'package:w3_lms/core/mascot/fox_line.dart';
import 'package:w3_lms/core/mascot/fox_mascot.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/presentation/state/quiz_session_controller.dart';

const _praise = ['Nailed it!', 'Exactly right!', 'Sharp!', 'Keep going!'];

/// Kit's lines during a checkpoint or mistake review.
FoxLine quizKitLine(QuizSessionController c) {
  switch (c.phase) {
    case QuizPhase.loading || QuizPhase.unavailable:
      return const FoxLine(FoxMood.idle, '');
    case QuizPhase.intro:
      final checkpoint = c.checkpoint;
      if (c.isCheckpoint && checkpoint != null) {
        return FoxLine(
          FoxMood.idea,
          'Get ${checkpoint.passMark} of ${checkpoint.questions.length} right to master this topic. You can do it!',
        );
      }
      return FoxLine(FoxMood.idea, '${c.questionCount} questions you missed before. Time to turn them into points!');
    case QuizPhase.saving:
      return const FoxLine(FoxMood.idea, 'Saving your results…');
    case QuizPhase.saveFailed:
      return const FoxLine(FoxMood.oops, "Hmm, I couldn't save that. Let's try again.");
    case QuizPhase.complete:
      final outcome = c.outcome!;
      if (outcome.passed == false) {
        return const FoxLine(FoxMood.oops, 'So close! Review the lessons and try again.');
      }
      if (outcome.isNewlyMastered) return const FoxLine(FoxMood.cheer, 'Topic mastered! On to the next one.');
      if (c.isCheckpoint) return const FoxLine(FoxMood.happy, 'Passed again. That topic is solid.');
      return FoxLine(FoxMood.cheer, 'You fixed ${outcome.correct} of ${outcome.total} mistakes!');
    case QuizPhase.playing:
      return switch (c.run.status) {
        AnswerStatus.correct => FoxLine(FoxMood.cheer, _praise[c.run.index % _praise.length]),
        AnswerStatus.incorrect => const FoxLine(FoxMood.oops, 'Not this time. Read the explanation below.'),
        AnswerStatus.unanswered => const FoxLine(FoxMood.curious, 'Take your best guess.'),
      };
  }
}
