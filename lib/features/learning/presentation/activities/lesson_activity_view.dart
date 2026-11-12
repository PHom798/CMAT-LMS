import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/presentation/activities/concept_activity_view.dart';
import 'package:w3_lms/features/learning/presentation/activities/question_activity_view.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';

/// Picks the right view for the current lesson activity. Because
/// LessonActivity is sealed, adding a new type makes this switch fail to
/// compile until it is handled.
class LessonActivityView extends StatelessWidget {
  const LessonActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LessonSessionController>();
    final run = controller.run;
    if (run.isFinished) return const SizedBox.shrink();

    return switch (run.current) {
      ConceptActivity activity => ConceptActivityView(activity: activity),
      QuestionActivity activity => QuestionActivityView(
          activity: activity,
          selectedChoice: run.selectedChoice,
          status: run.status,
          wrongAnswers: controller.wrongAnswers,
          onSelect: controller.selectChoice,
          leading: run.isReview ? const PillTag(icon: Icons.replay_rounded, label: 'Review') : null,
        ),
    };
  }
}
