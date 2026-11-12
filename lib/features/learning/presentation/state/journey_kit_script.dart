import 'package:w3_lms/core/mascot/fox_line.dart';
import 'package:w3_lms/core/mascot/fox_mascot.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';

/// What Kit says at the top of a section's path.
FoxLine journeyKitLine(SectionJourney journey) {
  final next = journey.nextStep;
  if (next == null) {
    return journey.steps.isEmpty
        ? const FoxLine(FoxMood.curious, 'Lessons for this section are on their way!')
        : const FoxLine(FoxMood.cheer, 'Every available topic mastered! More are coming soon.');
  }
  return switch (next) {
    CheckpointStep(:final checkpoint, :final topic) => FoxLine(
        FoxMood.idea,
        'Checkpoint time! Get ${checkpoint.passMark} of ${checkpoint.questions.length} right to master ${topic.title}.',
      ),
    LessonStep(:final lesson) when journey.steps.every((s) => !s.isCompleted) =>
      FoxLine(FoxMood.wave, "Let's begin with ${lesson.title}. I'll be right here."),
    LessonStep(:final lesson) => FoxLine(FoxMood.happy, 'Next stop: ${lesson.title}.'),
  };
}
