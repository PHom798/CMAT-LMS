import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/core/navigation/learning_navigator.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/presentation/journey/topic_path.dart';
import 'package:w3_lms/features/learning/presentation/state/journey_kit_script.dart';
import 'package:w3_lms/features/learning/presentation/state/section_journey_controller.dart';
import 'package:w3_lms/features/learning/presentation/views/lesson_status_views.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_backdrop.dart';

/// A section's learning path: every syllabus topic in order, its lessons
/// and checkpoint, what's done, what's next and what's coming soon.
class SectionJourneyScreen extends StatelessWidget {
  const SectionJourneyScreen({super.key, required this.courseId, required this.onBack});

  final String courseId;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SectionJourneyController(
        courseId: courseId,
        contentRepository: context.read<ContentRepository>(),
        progressRepository: context.read<LearningProgressRepository>(),
      )..load(),
      child: _JourneyView(onBack: onBack),
    );
  }
}

class _JourneyView extends StatelessWidget {
  const _JourneyView({required this.onBack});

  final VoidCallback onBack;

  void _openStep(BuildContext context, JourneyStep step) {
    if (step.isLocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Finish the step before this one to unlock it.')));
      return;
    }
    final navigator = context.read<LearningNavigator>();
    switch (step) {
      case LessonStep(:final lesson):
        navigator.openLesson(lesson.id);
      case CheckpointStep(:final topic):
        navigator.openCheckpoint(topic.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SectionJourneyController>();
    switch (controller.status) {
      case JourneyLoadStatus.loading:
        return const LessonLoadingView();
      case JourneyLoadStatus.failure:
        return LessonUnavailableView(onClose: onBack);
      case JourneyLoadStatus.ready:
        break;
    }
    final journey = controller.journey;
    final current = journey.nextStep;
    final line = journeyKitLine(journey);

    return Stack(
      children: [
        LessonBackdrop(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      onPressed: onBack,
                      tooltip: 'Back',
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                    ),
                    Expanded(child: Text(journey.course.title, style: AppText.label.copyWith(fontSize: 17))),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xs, AppSpacing.xl, AppSpacing.xxxl),
                  children: [
                    _JourneyHeader(journey: journey),
                    const SizedBox(height: AppSpacing.lg),
                    _KitBanner(line: line, reactionKey: controller.reactionTick),
                    const SizedBox(height: AppSpacing.xxl),
                    for (final (i, topic) in journey.topics.indexed)
                      TopicPath(
                        number: i + 1,
                        topic: topic,
                        currentStep: current,
                        onStepTap: (step) => _openStep(context, step),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(child: ConfettiBurst(trigger: controller.celebrationTick)),
      ],
    );
  }
}

/// Section summary: mastery and topic counts, without a card (open layout).
class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader({required this.journey});

  final SectionJourney journey;

  @override
  Widget build(BuildContext context) {
    final mastery = (journey.mastery * 100).round();
    final soon = journey.comingSoonCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ChoiceIconTile(icon: AppIcons.forKey(journey.course.iconKey), isSelected: true),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(journey.course.description, style: AppText.body.copyWith(fontSize: 14))),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Text(
              'Mastery $mastery%',
              style: AppText.label.copyWith(fontSize: 14, color: AppColors.orangeDeep),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: ProgressTrack(value: journey.mastery, semanticLabel: 'Section mastery')),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${journey.masteredTopicCount} of ${journey.topics.length} topics mastered'
          '${soon > 0 ? ', $soon coming soon' : ''}',
          style: AppText.caption,
        ),
      ],
    );
  }
}

/// Kit's head with a line about where to go next.
class _KitBanner extends StatelessWidget {
  const _KitBanner({required this.line, required this.reactionKey});

  final FoxLine line;
  final int reactionKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FoxMascot(height: 72, mood: line.mood, reactionKey: reactionKey),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: SpeechBubble(text: line.text)),
      ],
    );
  }
}
