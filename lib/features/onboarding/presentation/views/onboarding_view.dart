import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/onboarding/presentation/state/onboarding_controller.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/fox_stage.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/onboarding_action_bar.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/onboarding_step_switcher.dart';
import 'package:w3_lms/features/onboarding/presentation/widgets/onboarding_top_bar.dart';

/// The onboarding layout, top to bottom: top bar, Kit's stage, the current
/// step, and the action bar. Only the step area swaps; Kit and the chrome
/// persist, which is what makes the flow feel like one continuous journey.
///
/// This widget translates taps into controller calls and handles the
/// UI-only side effects (haptics, snackbars, navigation callback).
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key, required this.onCompleted, this.onSignIn});

  final VoidCallback onCompleted;
  final VoidCallback? onSignIn;

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final AppLifecycleListener _lifecycleListener;
  bool _didPrecache = false;

  OnboardingController get _controller => context.read<OnboardingController>();

  @override
  void initState() {
    super.initState();
    // Save when the app is backgrounded so a killed app resumes in place.
    _lifecycleListener = AppLifecycleListener(onPause: () => _controller.saveCheckpoint());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      _didPrecache = true;
      precacheImage(const AssetImage(FoxAssets.full), context);
      precacheImage(const AssetImage(FoxAssets.head), context);
    }
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _onPrimaryPressed() async {
    final controller = _controller;
    switch (controller.primaryAction) {
      case OnboardingPrimaryAction.getStarted || OnboardingPrimaryAction.next:
        FocusScope.of(context).unfocus();
        controller.goNext();
      case OnboardingPrimaryAction.startDiagnostic:
        controller.startDiagnostic();
      case OnboardingPrimaryAction.checkAnswer:
        final status = controller.checkDiagnosticAnswer();
        if (status == AnswerStatus.correct) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.heavyImpact();
        }
      case OnboardingPrimaryAction.nextQuestion:
        controller.nextDiagnosticQuestion();
      case OnboardingPrimaryAction.finish:
        final saved = await controller.completeOnboarding();
        if (!mounted) return;
        if (saved) {
          widget.onCompleted();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Couldn't save your progress. Please try again.")),
          );
        }
    }
  }

  void _onBack() {
    FocusScope.of(context).unfocus();
    _controller.goBack();
  }

  void _onNameSubmitted() {
    if (_controller.canLeaveCurrentStep) _onPrimaryPressed();
  }

  @override
  Widget build(BuildContext context) {
    final isFirstStep = context.select((OnboardingController c) => c.step.isFirst);
    final celebrationTick = context.select((OnboardingController c) => c.celebrationTick);

    return PopScope(
      // System back walks back through steps; only exits from the first one.
      canPop: isFirstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.cream, AppColors.creamLight],
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
                    // child: Column(
                    //   children: [
                    //     OnboardingTopBar(onBack: _onBack),
                    //     const FoxStage(availableHeight1: constraints.maxHeight,),
                    //     Expanded(
                    //       child: OnboardingStepSwitcher(onNameSubmitted: _onNameSubmitted),
                    //     ),
                    //     OnboardingActionBar(
                    //       onPrimaryPressed: _onPrimaryPressed,
                    //       onSkipDiagnostic: () => _controller.skipDiagnostic(),
                    //       onSignIn: widget.onSignIn,
                    //     ),
                    //   ],
                    // ),
                    child: Column(
                      children: [
                        OnboardingTopBar(onBack: _onBack),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) => Column(
                              children: [
                                FoxStage(availableHeight1: constraints.maxHeight),
                                Expanded(
                                  child: OnboardingStepSwitcher(onNameSubmitted: _onNameSubmitted),
                                ),
                              ],
                            ),
                          ),
                        ),
                        OnboardingActionBar(
                          onPrimaryPressed: _onPrimaryPressed,
                          onSkipDiagnostic: () => _controller.skipDiagnostic(),
                          onSignIn: widget.onSignIn,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: ConfettiBurst(trigger: celebrationTick)),
            ],
          ),
        ),
      ),
    );
  }
}
