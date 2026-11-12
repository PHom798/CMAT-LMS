import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';

/// One topic on a section's path: a header, then its steps drawn as a
/// winding trail (or a "coming soon" note).
class TopicPath extends StatelessWidget {
  const TopicPath({
    super.key,
    required this.number,
    required this.topic,
    required this.currentStep,
    required this.onStepTap,
  });

  final int number;
  final TopicJourney topic;

  /// The learner's "you are here" step on the whole path.
  final JourneyStep? currentStep;
  final ValueChanged<JourneyStep> onStepTap;

  @override
  Widget build(BuildContext context) {
    final soon = topic.isComingSoon;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NumberBadge(number: number, isMastered: topic.isMastered, isComingSoon: soon),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.topic.title,
                      style: AppText.label.copyWith(fontSize: 16, color: soon ? AppColors.muted : AppColors.ink),
                    ),
                    Text(topic.topic.description, style: AppText.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _TopicTag(topic: topic),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (soon)
            const _ComingSoonNote()
          else
            _Trail(steps: topic.steps, currentStep: currentStep, onStepTap: onStepTap),
        ],
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.isMastered, required this.isComingSoon});

  final int number;
  final bool isMastered;
  final bool isComingSoon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isMastered ? AppColors.orange : (isComingSoon ? AppColors.locked : AppColors.orangeSoft),
        shape: BoxShape.circle,
      ),
      child: isMastered
          ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
          : Text(
              '$number',
              style: AppText.label.copyWith(
                fontSize: 13,
                color: isComingSoon ? AppColors.muted : AppColors.orangeDeep,
              ),
            ),
    );
  }
}

class _TopicTag extends StatelessWidget {
  const _TopicTag({required this.topic});

  final TopicJourney topic;

  @override
  Widget build(BuildContext context) {
    final (text, background, foreground) = topic.isComingSoon
        ? ('Coming soon', AppColors.locked, AppColors.muted)
        : topic.isMastered
            ? ('Mastered', AppColors.successSoft, AppColors.successDeep)
            : ('Mastery ${(topic.mastery * 100).round()}%', AppColors.orangeSoft, AppColors.orangeDeep);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(text, style: AppText.caption.copyWith(color: foreground, fontWeight: FontWeight.w700, fontSize: 11.5)),
    );
  }
}

class _ComingSoonNote extends StatelessWidget {
  const _ComingSoonNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 42),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: const Row(
        children: [
          Icon(Icons.edit_note_rounded, color: AppColors.muted, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text('Lessons for this topic are being written.', style: AppText.caption),
          ),
        ],
      ),
    );
  }
}

/// Steps on a gentle zigzag, joined by a dashed trail.
class _Trail extends StatelessWidget {
  const _Trail({required this.steps, required this.currentStep, required this.onStepTap});

  final List<JourneyStep> steps;
  final JourneyStep? currentStep;
  final ValueChanged<JourneyStep> onStepTap;

  static const _node = 60.0;
  static const _row = 88.0;
  static const _offsets = [12.0, 56.0, 24.0, 68.0];

  double _offset(int i) => _offsets[i % _offsets.length];

  @override
  Widget build(BuildContext context) {
    final centers = [
      for (var i = 0; i < steps.length; i++) Offset(_offset(i) + _node / 2, _row * i + _node / 2),
    ];
    return SizedBox(
      height: _row * (steps.length - 1) + _node + AppSpacing.sm,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: CustomPaint(painter: _TrailPainter(centers))),
          for (var i = 0; i < steps.length; i++)
            Positioned(
              left: _offset(i),
              right: 0,
              top: _row * i,
              height: _node,
              child: StaggeredEntrance(
                index: i,
                child: _StepTile(
                  step: steps[i],
                  isCurrent: identical(steps[i], currentStep),
                  onTap: () => onStepTap(steps[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.step, required this.isCurrent, required this.onTap});

  final JourneyStep step;
  final bool isCurrent;
  final VoidCallback onTap;

  String get _subtitle => switch (step) {
        LessonStep(state: JourneyStepState.completed) => 'Done. Tap to practice',
        LessonStep(state: JourneyStepState.available, :final lesson) => '${lesson.estimatedMinutes} min lesson',
        CheckpointStep(state: JourneyStepState.completed, :final bestCorrect, :final checkpoint) =>
          'Passed, best ${bestCorrect ?? checkpoint.passMark}/${checkpoint.questions.length}',
        CheckpointStep(state: JourneyStepState.available, :final checkpoint) =>
          'Get ${checkpoint.passMark} of ${checkpoint.questions.length} to master',
        _ => 'Locked',
      };

  @override
  Widget build(BuildContext context) {
    final locked = step.isLocked;
    return Semantics(
      button: true,
      enabled: !locked,
      label: '${step.title}. $_subtitle',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            _StepNode(step: step, isCurrent: isCurrent),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(fontSize: 14.5, color: locked ? AppColors.muted : AppColors.ink),
                  ),
                  Text(
                    _subtitle,
                    style: AppText.caption.copyWith(color: isCurrent ? AppColors.orangeDeep : AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lessons are circles; checkpoints are rounded squares with a trophy, so
/// milestones stand out on the trail.
class _StepNode extends StatelessWidget {
  const _StepNode({required this.step, required this.isCurrent});

  final JourneyStep step;
  final bool isCurrent;

  static const _size = 60.0;

  @override
  Widget build(BuildContext context) {
    final isCheckpoint = step is CheckpointStep;
    final (fill, edge, iconColor) = switch (step.state) {
      JourneyStepState.completed => (AppColors.orange, AppColors.orangeDeep, Colors.white),
      JourneyStepState.available => (AppColors.orange, AppColors.orangeDeep, Colors.white),
      JourneyStepState.locked => (AppColors.locked, AppColors.line, AppColors.muted),
    };
    final icon = switch (step.state) {
      JourneyStepState.locked => Icons.lock_rounded,
      JourneyStepState.completed => isCheckpoint ? Icons.emoji_events_rounded : Icons.check_rounded,
      JourneyStepState.available => isCheckpoint ? Icons.flag_rounded : Icons.play_arrow_rounded,
    };
    final node = Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: fill,
        shape: isCheckpoint ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isCheckpoint ? BorderRadius.circular(AppRadius.card) : null,
        boxShadow: [BoxShadow(color: edge, offset: const Offset(0, 4))],
      ),
      child: Icon(icon, color: iconColor, size: 28),
    );
    if (!isCurrent) return node;

    // "You are here": a pulse plus Kit's head on the learner's next step.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        PulseRing(diameter: _size, child: node),
        Positioned(
          top: -12,
          right: -14,
          child: Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.orange, width: 1.5),
            ),
            child: ClipOval(child: Image.asset(FoxAssets.head, fit: BoxFit.cover)),
          ),
        ),
      ],
    );
  }
}

class _TrailPainter extends CustomPainter {
  _TrailPainter(this.centers);

  final List<Offset> centers;

  @override
  void paint(Canvas canvas, Size size) {
    if (centers.length < 2) return;
    final path = Path()..moveTo(centers.first.dx, centers.first.dy);
    for (var i = 1; i < centers.length; i++) {
      final a = centers[i - 1];
      final b = centers[i];
      path.cubicTo(a.dx, a.dy + 36, b.dx, b.dy - 36, b.dx, b.dy);
    }
    final paint = Paint()
      ..color = AppColors.lineDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 13) {
        canvas.drawPath(metric.extractPath(d, d + 6), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TrailPainter old) => old.centers.length != centers.length;
}
