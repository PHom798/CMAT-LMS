import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/presentation/activities/activity_scroll.dart';
import 'package:w3_lms/features/learning/presentation/activities/content_snippet.dart';

class ConceptActivityView extends StatelessWidget {
  const ConceptActivityView({super.key, required this.activity});

  final ConceptActivity activity;

  @override
  Widget build(BuildContext context) {
    final example = activity.example;
    return ActivityScroll(
      leading: const PillTag(icon: Icons.lightbulb_rounded, label: 'New idea'),
      title: activity.title,
      children: [
        Text(activity.body, style: AppText.body.copyWith(fontSize: 16, color: AppColors.ink)),
        if (example != null) ...[
          const SizedBox(height: AppSpacing.xl),
          StaggeredEntrance(
            index: 1,
            child: ContentSnippet(
              text: example,
              label: activity.exampleLabel ?? (activity.exampleIsCode ? null : 'Example'),
              isCode: activity.exampleIsCode,
            ),
          ),
        ],
      ],
    );
  }
}
