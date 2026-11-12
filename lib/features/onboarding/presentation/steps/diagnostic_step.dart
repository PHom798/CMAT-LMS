import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learning/domain/exam_pattern.dart';
import 'package:w3_lms/features/learning/presentation/activities/question_activity_view.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/step_body.dart';

/// A short diagnostic: a couple of questions per exam section, instant
/// feedback, no retries. Its result picks the learner's starting section.
class DiagnosticStep extends StatelessWidget {
  const DiagnosticStep({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = context.select((OnboardingController c) => c.diagnosticPhase);
    return switch (phase) {
      DiagnosticPhase.intro => const _DiagnosticIntro(),
      DiagnosticPhase.running => const _DiagnosticQuestion(),
      DiagnosticPhase.done => const _DiagnosticSummary(),
    };
  }
}

class _DiagnosticIntro extends StatelessWidget {
  const _DiagnosticIntro();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    final exam = controller.exam;
    final perSection = exam.sections.isEmpty ? 0 : controller.diagnosticQuestionCount ~/ exam.sections.length;

    return StepBody(
      title: "Let's find your *starting point*",
      subtitle: '${controller.diagnosticQuestionCount} quick questions, $perSection from each section. '
          'No pressure: this only decides where you begin.',
      child: _SectionPanel(
        children: [
          for (final section in exam.sections)
            _SectionLine(section: section, trailing: '$perSection questions'),
        ],
      ),
    );
  }
}

class _DiagnosticQuestion extends StatelessWidget {
  const _DiagnosticQuestion();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    final run = controller.diagnosticRun!;
    final question = run.current;
    final section = controller.exam.sectionById(question.sectionId);

    final header = Row(
      children: [
        if (section != null) PillTag(icon: AppIcons.forKey(section.iconKey), label: section.title),
        const Spacer(),
        Text('${run.index + 1} of ${run.total}', style: AppText.caption),
      ],
    );

    return AnimatedSwitcher(
      duration: AppMotion.medium,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(begin: const Offset(0.12, 0), end: Offset.zero).animate(animation),
          child: child,
        ),
      ),
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.expand,
        children: [...previous, if (current != null) current],
      ),
      child: QuestionActivityView(
        key: ValueKey(run.index),
        activity: question.activity,
        selectedChoice: run.selectedChoice,
        status: run.status,
        wrongAnswers: controller.wrongAnswers,
        onSelect: controller.selectDiagnosticAnswer,
        leading: header,
      ),
    );
  }
}

class _DiagnosticSummary extends StatelessWidget {
  const _DiagnosticSummary();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    final result = controller.draft.diagnosticResult;
    final exam = controller.exam;

    return StepBody(
      title: result == null ? 'Diagnostic *skipped*' : 'You got *${result.correct} of ${result.total}*',
      subtitle: result == null
          ? "No problem. We'll start from the basics."
          : 'Here is your starting point. ${controller.focusSection.title} is where we begin.',
      child: _SectionPanel(
        children: [
          for (final section in exam.sections)
            _SectionLine(
              section: section,
              score: result?.scoreFor(section.id),
              isFocus: result != null && section.id == controller.focusSection.id,
            ),
        ],
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.line),
            StaggeredEntrance(index: i, child: children[i]),
          ],
        ],
      ),
    );
  }
}

/// One section with either a note ([trailing]) or a diagnostic [score].
class _SectionLine extends StatelessWidget {
  const _SectionLine({required this.section, this.trailing, this.score, this.isFocus = false});

  final ExamSection section;
  final String? trailing;
  final SectionScore? score;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    final score = this.score;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          ChoiceIconTile(icon: AppIcons.forKey(section.iconKey), isSelected: isFocus),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.title, style: AppText.label.copyWith(fontSize: 14.5)),
                if (score != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  ProgressTrack(value: score.fraction, height: 8),
                ] else
                  Text(section.description, style: AppText.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            score != null ? '${score.correct}/${score.total}' : trailing ?? '',
            style: AppText.caption.copyWith(
              color: isFocus ? AppColors.orangeDeep : AppColors.muted,
              fontWeight: isFocus ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
