import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_kit_script.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_backdrop.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_top_bar.dart';

/// "What you'll learn" screen before the first activity.
class LessonIntroView extends StatelessWidget {
  const LessonIntroView({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LessonSessionController>();
    final lesson = controller.lesson;
    final course = controller.course;
    final line = lessonKitLine(controller);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final foxHeight = (screenHeight * 0.22).clamp(130.0, 200.0).toDouble();

    return LessonBackdrop(
      child: Column(
        children: [
          LessonTopBar(onClose: onClose),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                children: [
                  SpeechBubble(text: line.text, tail: BubbleTail.down),
                  const SizedBox(height: AppSpacing.xs),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: foxHeight * 0.95,
                        height: foxHeight * 0.95,
                        decoration: const BoxDecoration(color: AppColors.orangeSoft, shape: BoxShape.circle),
                      ),
                      FoxMascot(height: foxHeight, mood: line.mood, reactionKey: controller.reactionTick),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (course != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(AppIcons.forKey(course.iconKey), size: 18, color: AppColors.orangeDeep),
                        const SizedBox(width: AppSpacing.xs),
                        Text(course.title, style: AppText.label.copyWith(color: AppColors.orangeDeep, fontSize: 14)),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(lesson.title, style: AppText.display, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text(lesson.objective, style: AppText.body, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.xl),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      PillTag(icon: Icons.timer_outlined, label: '${lesson.estimatedMinutes} min'),
                      PillTag(icon: Icons.quiz_outlined, label: '${lesson.questionCount} questions'),
                      PillTag(icon: Icons.bolt_rounded, label: 'Up to ${controller.maxXp} XP'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.md),
            child: PrimaryButton(
              label: controller.isReplay ? 'Practice again' : 'Start lesson',
              onPressed: controller.start,
            ),
          ),
        ],
      ),
    );
  }
}
