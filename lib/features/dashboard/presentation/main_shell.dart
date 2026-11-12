import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/core/navigation/learning_navigator.dart';
import 'package:w3_lms/features/dashboard/presentation/home/home_tab.dart';
import 'package:w3_lms/features/dashboard/presentation/main_tab.dart';
import 'package:w3_lms/features/dashboard/presentation/practice/practice_tab.dart';
import 'package:w3_lms/features/dashboard/presentation/profile/profile_tab.dart';
import 'package:w3_lms/features/dashboard/presentation/state/dashboard_controller.dart';
import 'package:w3_lms/features/dashboard/presentation/widgets/brand_bottom_nav.dart';
import 'package:w3_lms/features/dashboard/presentation/widgets/dashboard_status_views.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/journey.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';

/// The main app after onboarding: bottom navigation over Home, Practice and
/// Profile. Provides one [DashboardController] shared by all three tabs.
class MainShell extends StatelessWidget {
  const MainShell({super.key, this.onDebugReset});

  final VoidCallback? onDebugReset;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardController(
        learnerProfileRepository: context.read<LearnerProfileRepository>(),
        contentRepository: context.read<ContentRepository>(),
        learningProgressRepository: context.read<LearningProgressRepository>(),
      )..load(),
      child: _MainShellView(onDebugReset: onDebugReset),
    );
  }
}

class _MainShellView extends StatefulWidget {
  const _MainShellView({this.onDebugReset});

  final VoidCallback? onDebugReset;

  @override
  State<_MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<_MainShellView> {
  MainTab _tab = MainTab.home;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    // Quests and streaks are per day; refresh when the app comes back.
    _lifecycleListener = AppLifecycleListener(
      onResume: () => context.read<DashboardController>().refreshForToday(),
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _selectTab(MainTab tab) => setState(() => _tab = tab);

  LearningNavigator get _navigator => context.read<LearningNavigator>();

  /// Opens a lesson or checkpoint. When it was completed, comes back to
  /// Home so the learner sees their progress move, and Kit celebrates.
  Future<void> _openStep(JourneyStep step) async {
    final completed = switch (step) {
      LessonStep(:final lesson) => await _navigator.openLesson(lesson.id),
      CheckpointStep(:final topic) => await _navigator.openCheckpoint(topic.id),
    };
    if (!mounted || !completed) return;
    setState(() => _tab = MainTab.home);
    context.read<DashboardController>().celebrateRecentProgress();
  }

  Future<void> _openSection(String courseId) async {
    await _navigator.openSection(courseId);
    if (!mounted) return;
    context.read<DashboardController>().celebrateRecentProgress();
  }

  Future<void> _reviewMistakes() async {
    final completed = await _navigator.openMistakeReview();
    if (!mounted || !completed) return;
    context.read<DashboardController>().celebrateRecentProgress();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((DashboardController c) => c.status);
    return switch (status) {
      DashboardStatus.loading => const DashboardLoadingView(),
      DashboardStatus.failure => DashboardErrorView(
          onRetry: () => context.read<DashboardController>().load(),
        ),
      DashboardStatus.ready => PopScope(
          // Back from another tab returns Home; back on Home leaves the app.
          canPop: _tab == MainTab.home,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _selectTab(MainTab.home);
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
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
                    // IndexedStack keeps each tab's scroll position.
                    child: IndexedStack(
                      index: _tab.index,
                      children: [
                        for (final tab in MainTab.values) _buildTab(tab),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BrandBottomNav(current: _tab, onSelected: _selectTab),
          ),
        ),
    };
  }

  Widget _buildTab(MainTab tab) => switch (tab) {
        MainTab.home => HomeTab(
            onOpenStep: _openStep,
            onOpenSection: _openSection,
            onReviewMistakes: _reviewMistakes,
            onBrowsePractice: () => _selectTab(MainTab.practice),
          ),
        MainTab.practice => PracticeTab(onOpenSection: _openSection, onReviewMistakes: _reviewMistakes),
        MainTab.profile => ProfileTab(onDebugReset: widget.onDebugReset),
      };
}
