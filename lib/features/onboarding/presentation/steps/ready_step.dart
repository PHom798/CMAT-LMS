import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/step_body.dart';

/// Payoff screen: what was earned, and the real first lesson to take.
class ReadyStep extends StatelessWidget {
  const ReadyStep({super.key});

  // Streaks start with the first real lesson (see the dashboard), so the
  // celebration shows the journey's first day instead of a streak.
  static String _dayLabel(int day) => 'Day $day';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    final draft = controller.draft;
    // Strip '*' so a name can't break HighlightedText markup.
    final name = draft.firstName.replaceAll('*', '');
    final goal = draft.dailyGoal ?? DailyGoal.regular;
    final course = controller.focusCourse;
    final firstLesson = course == null || course.lessons.isEmpty ? null : course.lessons.first;

    return StepBody(
      title: name.isEmpty ? "You're *all set*!" : "You're all set, *$name*!",
      subtitle: "Here's where your ${controller.exam.title} prep begins.",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StaggeredEntrance(
                  index: 0,
                  child: StatTile(
                    icon: Icons.bolt_rounded,
                    value: draft.earnedXp,
                    format: (v) => '+$v',
                    label: 'XP earned',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: StaggeredEntrance(
                  index: 1,
                  child: StatTile(icon: Icons.flag_rounded, value: 1, format: _dayLabel, label: 'Journey'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StaggeredEntrance(
                  index: 2,
                  child: StatTile(
                    icon: Icons.timer_outlined,
                    value: goal.minutes,
                    format: (v) => '${v}m',
                    label: 'Daily goal',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (course != null && firstLesson != null)
            StaggeredEntrance(
              index: 3,
              child: _FirstLessonCard(
                sectionTitle: course.title,
                iconKey: course.iconKey,
                lessonTitle: firstLesson.title,
                minutes: firstLesson.estimatedMinutes,
                questions: firstLesson.questionCount,
                isFromDiagnostic: draft.diagnosticResult != null,
              ),
            ),
        ],
      ),
    );
  }
}

/// The real first lesson, so the promise on this screen is one the app keeps.
class _FirstLessonCard extends StatelessWidget {
  const _FirstLessonCard({
    required this.sectionTitle,
    required this.iconKey,
    required this.lessonTitle,
    required this.minutes,
    required this.questions,
    required this.isFromDiagnostic,
  });

  final String sectionTitle;
  final String iconKey;
  final String lessonTitle;
  final int minutes;
  final int questions;
  final bool isFromDiagnostic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(AppIcons.forKey(iconKey), size: 18, color: AppColors.orangeDeep),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  isFromDiagnostic ? 'Your focus: $sectionTitle' : 'First up: $sectionTitle',
                  style: AppText.label.copyWith(fontSize: 14, color: AppColors.orangeDeep),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              PulseRing(
                diameter: 50,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.orangeDeep, offset: Offset(0, 4))],
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lessonTitle, style: AppText.label),
                    Text('$minutes min, $questions questions', style: AppText.caption),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
