import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/lesson.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/presentation/activities/activity_scroll.dart';
import 'package:w3_lms/features/learning/presentation/activities/choice_tone.dart';

/// A sentence or code line with a blank; tapping a choice drops it in.
class FillInBlankActivityView extends StatelessWidget {
  const FillInBlankActivityView({
    super.key,
    required this.activity,
    required this.selectedChoice,
    required this.status,
    required this.wrongAnswers,
    required this.onSelect,
    this.leading,
  });

  final FillInBlankActivity activity;
  final int? selectedChoice;
  final AnswerStatus status;
  final int wrongAnswers;
  final ValueChanged<int> onSelect;
  final Widget? leading;

  CardTone _tone(int index) =>
      toneForChoice(question: activity, selectedChoice: selectedChoice, status: status, index: index);

  @override
  Widget build(BuildContext context) {
    final selected = selectedChoice;
    final isLocked = status != AnswerStatus.unanswered;
    final blank = Shake(
      trigger: status == AnswerStatus.incorrect ? wrongAnswers : 0,
      child: _Blank(
        text: selected == null ? null : activity.choices[selected],
        tone: selected == null ? CardTone.neutral : _tone(selected),
        onDark: activity.isCode,
      ),
    );

    return ActivityScroll(
      leading: leading ?? const PillTag(icon: Icons.edit_note_rounded, label: 'Fill in the blank'),
      title: activity.prompt,
      children: [
        if (activity.isCode)
          CodeBlock(
            language: activity.label,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(activity.textBefore, style: AppText.code.copyWith(color: Colors.white)),
                blank,
                Text(activity.textAfter, style: AppText.code.copyWith(color: Colors.white)),
              ],
            ),
          )
        else
          _SentenceCard(before: activity.textBefore, after: activity.textAfter, blank: blank),
        const SizedBox(height: AppSpacing.xxl),
        const Text('Tap the missing word', style: AppText.caption),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (var i = 0; i < activity.choices.length; i++)
              StaggeredEntrance(
                index: i,
                child: _TokenChip(
                  label: activity.choices[i],
                  tone: _tone(i),
                  isCode: activity.isCode,
                  onTap: isLocked ? null : () => onSelect(i),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Sentence that wraps naturally, with the blank inline.
class _SentenceCard extends StatelessWidget {
  const _SentenceCard({required this.before, required this.after, required this.blank});

  final String before;
  final String after;
  final Widget blank;

  @override
  Widget build(BuildContext context) {
    final style = AppText.label.copyWith(fontSize: 18, height: 1.7);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before),
            WidgetSpan(alignment: PlaceholderAlignment.middle, child: blank),
            TextSpan(text: after),
          ],
        ),
        style: style,
      ),
    );
  }
}

class _Blank extends StatelessWidget {
  const _Blank({required this.text, required this.tone, required this.onDark});

  final String? text;
  final CardTone tone;

  /// True inside a dark code block.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      CardTone.success => AppColors.success,
      CardTone.error => AppColors.error,
      CardTone.brand => AppColors.orange,
      CardTone.neutral => AppColors.muted,
    };
    return AnimatedContainer(
      duration: AppMotion.fast,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      constraints: const BoxConstraints(minWidth: 52),
      decoration: BoxDecoration(
        color: text == null ? Colors.transparent : color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(6),
        border: Border(bottom: BorderSide(color: color, width: 2)),
      ),
      child: Text(
        text ?? ' ',
        textAlign: TextAlign.center,
        style: onDark
            ? AppText.code.copyWith(color: Colors.white)
            : AppText.label.copyWith(fontSize: 18, color: AppColors.ink),
      ),
    );
  }
}

/// Pill-shaped token with the same pressable 3D edge as SelectableCard.
class _TokenChip extends StatefulWidget {
  const _TokenChip({required this.label, required this.tone, required this.onTap, required this.isCode});

  final String label;
  final CardTone tone;
  final VoidCallback? onTap;
  final bool isCode;

  @override
  State<_TokenChip> createState() => _TokenChipState();
}

class _TokenChipState extends State<_TokenChip> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final (border, edge, fill) = switch (widget.tone) {
      CardTone.neutral => (AppColors.line, AppColors.lineDeep, AppColors.surface),
      CardTone.brand => (AppColors.orange, AppColors.orangeDeep, AppColors.orangeTint),
      CardTone.success => (AppColors.success, AppColors.successDeep, AppColors.successSoft),
      CardTone.error => (AppColors.error, AppColors.errorDeep, AppColors.errorSoft),
    };
    final depth = _isPressed ? 0.0 : 3.0;
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: widget.onTap == null ? null : (_) => _setPressed(true),
        onTapUp: widget.onTap == null ? null : (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                widget.onTap!();
              },
        child: AnimatedContainer(
          duration: AppMotion.fast,
          transform: Matrix4.translationValues(0, 3 - depth, 0),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: border, width: 2),
            boxShadow: [BoxShadow(color: edge, offset: Offset(0, depth))],
          ),
          child: Text(widget.label, style: widget.isCode ? AppText.code : AppText.label),
        ),
      ),
    );
  }
}
