import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/mascot/mascot.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/learning/domain/lesson_run.dart';
import 'package:w3_lms/features/learning/domain/quiz_request.dart';
import 'package:w3_lms/features/learning/presentation/activities/question_activity_view.dart';
import 'package:w3_lms/features/learning/presentation/state/quiz_kit_script.dart';
import 'package:w3_lms/features/learning/presentation/state/quiz_session_controller.dart';
import 'package:w3_lms/features/learning/presentation/views/lesson_status_views.dart';
import 'package:w3_lms/features/learning/presentation/widgets/kit_row.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_backdrop.dart';
import 'package:w3_lms/features/learning/presentation/widgets/lesson_top_bar.dart';

/// Route entry for a topic checkpoint or a mistake review. [onExit]
/// receives true when a result was saved.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.request, required this.onExit});

  final QuizRequest request;
  final ValueChanged<bool> onExit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizSessionController(
        request: request,
        contentRepository: context.read<ContentRepository>(),
        progressRepository: context.read<LearningProgressRepository>(),
      )..load(),
      child: _QuizView(onExit: onExit),
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView({required this.onExit});

  final ValueChanged<bool> onExit;

  Future<void> _requestExit(BuildContext context) async {
    final controller = context.read<QuizSessionController>();
    final saved = controller.phase == QuizPhase.complete;
    if (!controller.shouldConfirmExit) {
      onExit(saved);
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.creamLight,
        title: const Text('Leave now?', style: AppText.title),
        content: const Text("Your answers so far won't be saved.", style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Keep going', style: AppText.label.copyWith(color: AppColors.orangeDeep)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Leave', style: AppText.label.copyWith(color: AppColors.muted)),
          ),
        ],
      ),
    );
    if (leave == true) onExit(false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<QuizSessionController>();
    void onClose() => _requestExit(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _requestExit(context);
      },
      child: switch (controller.phase) {
        QuizPhase.loading => const LessonLoadingView(),
        QuizPhase.unavailable => _Unavailable(isReview: !controller.isCheckpoint, onClose: onClose),
        QuizPhase.complete => _Result(onExit: onExit),
        _ => _Player(onClose: onClose),
      },
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({required this.onClose});

  final VoidCallback onClose;

  void _onPrimary(QuizSessionController c) {
    switch (c.primaryAction) {
      case QuizPrimaryAction.start || QuizPrimaryAction.retake:
        c.start();
      case QuizPrimaryAction.check:
        final status = c.checkAnswer();
        if (status == AnswerStatus.correct) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.heavyImpact();
        }
      case QuizPrimaryAction.next:
        c.next();
      case QuizPrimaryAction.retrySave:
        c.retrySave();
      case QuizPrimaryAction.finish:
        break;
    }
  }

  String _label(QuizSessionController c) {
    if (c.phase == QuizPhase.saving) return 'Saving…';
    return switch (c.primaryAction) {
      QuizPrimaryAction.start => c.isCheckpoint ? 'Start checkpoint' : 'Start review',
      QuizPrimaryAction.check => 'Check',
      QuizPrimaryAction.next => c.run.isLastQuestion ? 'See results' : 'Next question',
      QuizPrimaryAction.retrySave => 'Try again',
      _ => 'Continue',
    };
  }

  FeedbackPanel? _feedback(QuizSessionController c) {
    if (c.phase == QuizPhase.saveFailed) {
      return const FeedbackPanel(
        tone: CardTone.error,
        icon: Icons.cloud_off_rounded,
        title: "Couldn't save your results",
        body: 'Your device storage did not respond. Your answers are kept, so try again.',
      );
    }
    if (c.phase != QuizPhase.playing || c.run.isFinished) return null;
    final question = c.run.current.activity;
    return switch (c.run.status) {
      AnswerStatus.correct =>
        FeedbackPanel(tone: CardTone.success, icon: Icons.check_circle_rounded, title: 'Correct!', body: question.explanation),
      AnswerStatus.incorrect => FeedbackPanel(
          tone: CardTone.error,
          icon: Icons.cancel_rounded,
          title: 'Answer: ${question.correctChoice}',
          body: question.explanation,
        ),
      AnswerStatus.unanswered => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<QuizSessionController>();
    final isIntro = c.phase == QuizPhase.intro;
    final run = isIntro ? null : c.run;
    final answered = run != null && !run.isFinished && run.status != AnswerStatus.unanswered ? 1 : 0;
    final progress = run == null ? null : (run.index + answered) / run.total;
    final feedback = _feedback(c);

    return LessonBackdrop(
      child: Column(
        children: [
          LessonTopBar(onClose: onClose, progress: progress),
          KitRow(line: quizKitLine(c), reactionKey: c.reactionTick),
          Expanded(
            child: run == null
                ? _Intro(controller: c)
                : run.isFinished
                    ? const SizedBox.shrink()
                    : AnimatedSwitcher(
                        duration: AppMotion.medium,
                        layoutBuilder: (current, previous) =>
                            Stack(fit: StackFit.expand, children: [...previous, if (current != null) current]),
                        child: QuestionActivityView(
                          key: ValueKey(run.index),
                          activity: run.current.activity,
                          selectedChoice: run.selectedChoice,
                          status: run.status,
                          wrongAnswers: c.wrongAnswers,
                          onSelect: c.selectChoice,
                          leading: Align(
                            alignment: Alignment.centerRight,
                            child: Text('${run.index + 1} of ${run.total}', style: AppText.caption),
                          ),
                        ),
                      ),
          ),
          AnimatedContainer(
            duration: AppMotion.medium,
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 14, AppSpacing.xl, AppSpacing.md),
            decoration: BoxDecoration(
              color: FeedbackPanel.backgroundFor(feedback?.tone),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSize(
                  duration: AppMotion.medium,
                  alignment: Alignment.topCenter,
                  child: feedback ?? const SizedBox(width: double.infinity),
                ),
                PrimaryButton(
                  label: _label(c),
                  onPressed: c.canPerformPrimaryAction ? () => _onPrimary(c) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.controller});

  final QuizSessionController controller;

  @override
  Widget build(BuildContext context) {
    final topic = controller.topic;
    final checkpoint = controller.checkpoint;
    final List<Widget> content;
    if (controller.isCheckpoint && topic != null && checkpoint != null) {
      content = [
        const PillTag(icon: Icons.emoji_events_rounded, label: 'Topic checkpoint'),
        const SizedBox(height: AppSpacing.md),
        HighlightedText('Master *${topic.title}*', style: AppText.display),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${checkpoint.questions.length} questions, one try each. Get ${checkpoint.passMark} right '
          'to master the topic${controller.alreadyPassed ? '' : ' and earn XP'}.',
          style: AppText.body,
        ),
        if (controller.alreadyPassed) ...[
          const SizedBox(height: AppSpacing.md),
          const PillTag(icon: Icons.verified_rounded, label: 'Already mastered. This is practice.'),
        ],
      ];
    } else {
      content = [
        const PillTag(icon: Icons.replay_rounded, label: 'Mistake review'),
        const SizedBox(height: AppSpacing.md),
        const HighlightedText('Turn mistakes into *points*', style: AppText.display),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${controller.questionCount} questions you got wrong before. Each one you fix earns XP '
          'and leaves your review list.',
          style: AppText.body,
        ),
      ];
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: content),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.onExit});

  final ValueChanged<bool> onExit;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<QuizSessionController>();
    final outcome = c.outcome!;
    final line = quizKitLine(c);
    final failed = outcome.passed == false;
    final title = switch (outcome) {
      QuizOutcome(passed: false) => 'Almost *there*',
      QuizOutcome(isNewlyMastered: true) => 'Topic *mastered*!',
      QuizOutcome(passed: true) => 'Passed *again*',
      _ => 'Mistakes *fixed*',
    };

    return Stack(
      children: [
        LessonBackdrop(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xxl, AppSpacing.xxl, AppSpacing.lg),
                  child: Column(
                    children: [
                      SpeechBubble(text: line.text, tail: BubbleTail.down),
                      const SizedBox(height: AppSpacing.xs),
                      FoxMascot(height: 160, mood: line.mood, reactionKey: c.reactionTick),
                      const SizedBox(height: AppSpacing.xl),
                      HighlightedText(title, style: AppText.display, textAlign: TextAlign.center),
                      if (c.topic != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(c.topic!.title, style: AppText.body),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: StatTile(
                              icon: Icons.track_changes_rounded,
                              value: outcome.correct,
                              format: (v) => '$v/${outcome.total}',
                              label: failed ? 'Need ${c.checkpoint?.passMark ?? 0}' : 'Correct',
                              iconColor: failed ? AppColors.error : AppColors.orange,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StatTile(
                              icon: Icons.bolt_rounded,
                              value: outcome.xpEarned,
                              format: (v) => '+$v',
                              label: 'XP earned',
                            ),
                          ),
                        ],
                      ),
                      if (failed) ...[
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          'Your wrong answers are saved for review. Replay the lessons, then try the checkpoint again.',
                          style: AppText.body,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                      label: failed ? 'Try again' : 'Continue',
                      onPressed: failed ? c.start : () => onExit(true),
                    ),
                    if (failed)
                      TextButton(
                        onPressed: () => onExit(true),
                        child: Text('Back to the path', style: AppText.label.copyWith(fontSize: 14)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(child: ConfettiBurst(trigger: c.celebrationTick, playOnMount: c.celebrationTick > 0)),
      ],
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.isReview, required this.onClose});

  final bool isReview;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.page,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FoxMascot(height: 150, mood: isReview ? FoxMood.cheer : FoxMood.oops),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                isReview ? 'No mistakes to review' : "This checkpoint isn't available",
                style: AppText.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isReview
                    ? 'Every question you answered recently is right. Nice work!'
                    : 'It may have been updated. Pick another topic from the path.',
                style: AppText.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(label: 'Back', onPressed: onClose),
            ],
          ),
        ),
      ),
    );
  }
}
