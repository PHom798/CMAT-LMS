import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_draft.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/step_body.dart';

class NameStep extends StatefulWidget {
  const NameStep({super.key, required this.onSubmitted});

  /// Called when the keyboard's "done" key is pressed with a valid name.
  final VoidCallback onSubmitted;

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  late final TextEditingController _textController;
  final _focusNode = FocusNode();
  Timer? _focusTimer;

  @override
  void initState() {
    super.initState();
    // Pre-fill with the restored draft so returning learners see their name.
    _textController = TextEditingController(text: context.read<OnboardingController>().draft.name);
    // Raise the keyboard after the page transition settles; opening it
    // mid-animation causes visible jank on low-end devices.
    _focusTimer = Timer(const Duration(milliseconds: 420), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        borderSide: BorderSide(color: color, width: 2),
      );

  @override
  Widget build(BuildContext context) {
    final hasName = context.select((OnboardingController c) => c.draft.firstName.isNotEmpty);

    return StepBody(
      title: "What's your *name*?",
      subtitle: 'Kit uses it to cheer you on.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _textController,
            focusNode: _focusNode,
            onChanged: (value) => context.read<OnboardingController>().updateName(value),
            onSubmitted: (_) {
              if (hasName) widget.onSubmitted();
            },
            maxLength: OnboardingDraft.maxNameLength,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.givenName],
            style: AppText.label.copyWith(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Your first name',
              hintStyle: AppText.label.copyWith(fontSize: 18, color: AppColors.muted),
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 18),
              enabledBorder: _border(AppColors.line),
              focusedBorder: _border(AppColors.orange),
              suffixIcon: AnimatedScale(
                scale: hasName ? 1 : 0,
                duration: AppMotion.medium,
                curve: Curves.easeOutBack,
                child: const Icon(Icons.check_circle_rounded, color: AppColors.orange),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 15, color: AppColors.muted),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Saved only on this device to personalize your lessons.',
                  style: AppText.caption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
