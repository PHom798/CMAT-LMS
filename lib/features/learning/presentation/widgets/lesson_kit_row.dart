import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/features/learning/presentation/state/lesson_kit_script.dart';
import 'package:w3_lms/features/learning/presentation/state/lesson_session_controller.dart';
import 'package:w3_lms/features/learning/presentation/widgets/kit_row.dart';

/// Kit reacting to every answer in a lesson.
class LessonKitRow extends StatelessWidget {
  const LessonKitRow({super.key, this.foxHeight = 84});

  final double foxHeight;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LessonSessionController>();
    return KitRow(line: lessonKitLine(controller), reactionKey: controller.reactionTick, foxHeight: foxHeight);
  }
}
