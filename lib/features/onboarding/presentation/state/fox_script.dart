import 'package:w3_lms/core/mascot/fox_line.dart';
import 'package:w3_lms/core/mascot/fox_mascot.dart';
import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/onboarding/domain/diagnostic_status.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';

const _pokeLines = [
  'Hehe, that tickles!',
  'I can do this all day.',
  'Okay, okay. Ready when you are!',
];

const _praise = ['Nice one!', 'Exactly right!', 'Sharp!', 'You know this!'];

/// All of Kit's onboarding dialogue, derived purely from controller state.
/// Keeping copy in one place makes tone easy to review and localize.
FoxLine foxLineFor(OnboardingController c) {
  final name = c.draft.firstName;

  switch (c.step) {
    case OnboardingStep.welcome:
      final section = c.activeSection;
      if (section != null) {
        return FoxLine(
          FoxMood.idea,
          '${section.title}: ${section.description} ${section.questionCount} questions in the exam.',
        );
      }
      if (c.foxPokes == 0) {
        return FoxLine(FoxMood.wave, "Hi! I'm Kit. Let's get you ready for ${c.exam.title}.");
      }
      return FoxLine(FoxMood.happy, _pokeLines[(c.foxPokes - 1) % _pokeLines.length]);

    case OnboardingStep.name:
      if (name.isEmpty) {
        return const FoxLine(FoxMood.curious, 'First things first. What should I call you?');
      }
      return FoxLine(FoxMood.happy, 'Nice to meet you, $name!');

    case OnboardingStep.examTimeframe:
      return switch (c.draft.examTimeframe) {
        null => FoxLine(FoxMood.curious, 'When is your ${c.exam.title}?'),
        ExamTimeframe.underOneMonth => const FoxLine(FoxMood.cheer, "Crunch time! We'll make every minute count."),
        ExamTimeframe.oneToThreeMonths => const FoxLine(FoxMood.happy, 'A great window for steady practice.'),
        ExamTimeframe.overThreeMonths => const FoxLine(FoxMood.happy, 'Starting early is the smartest move.'),
        ExamTimeframe.notSure => const FoxLine(FoxMood.happy, "No problem. We'll keep it flexible."),
      };

    case OnboardingStep.diagnostic:
      return _diagnosticLine(c);

    case OnboardingStep.dailyGoal:
      final suggested = c.draft.examTimeframe?.suggestedDailyGoal;
      return switch (c.draft.dailyGoal) {
        null => FoxLine(
            FoxMood.curious,
            suggested == null
                ? 'How much time can you give each day?'
                : 'For your timeline I suggest ${suggested.minutes} minutes a day.',
          ),
        DailyGoal.casual => const FoxLine(FoxMood.happy, 'Small steps add up fast.'),
        DailyGoal.regular => const FoxLine(FoxMood.happy, 'A solid habit. I like it.'),
        DailyGoal.serious => const FoxLine(FoxMood.cheer, "Now we're talking!"),
        DailyGoal.intense => const FoxLine(FoxMood.cheer, "Whoa! Let's make it count."),
      };

    case OnboardingStep.ready:
      if (c.draft.diagnosticStatus == DiagnosticStatus.completed) {
        return FoxLine(FoxMood.cheer, "Let's start with ${c.focusSection.title}, $name!");
      }
      return FoxLine(FoxMood.cheer, name.isEmpty ? 'Your plan is ready!' : 'Your plan is ready, $name!');
  }
}

FoxLine _diagnosticLine(OnboardingController c) {
  switch (c.diagnosticPhase) {
    case DiagnosticPhase.intro:
      return FoxLine(
        FoxMood.idea,
        'Just ${c.diagnosticQuestionCount} questions. It only decides where we start.',
      );
    case DiagnosticPhase.done:
      final result = c.draft.diagnosticResult;
      if (result == null) return const FoxLine(FoxMood.happy, "Let's keep going!");
      return FoxLine(FoxMood.cheer, '${result.correct} out of ${result.total}! Now I know where to start.');
    case DiagnosticPhase.running:
      final run = c.diagnosticRun!;
      return switch (run.status) {
        AnswerStatus.correct => FoxLine(FoxMood.cheer, _praise[run.index % _praise.length]),
        AnswerStatus.incorrect => const FoxLine(FoxMood.oops, "No worries. That's what practice is for."),
        AnswerStatus.unanswered => run.index == 0 && !c.exam.negativeMarking
            ? FoxLine(FoxMood.curious, 'Not sure? Guess! ${c.exam.title} has no negative marking.')
            : const FoxLine(FoxMood.curious, 'Take your best guess.'),
      };
  }
}
