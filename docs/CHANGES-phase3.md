# Phase 3 changes

Compared with the Phase 2 (onboarding) project. Easiest way to apply:
**replace your `lib/`, `test/` and `docs/` folders and `README.md` with the ones in this zip**,
then run build_runner (a new Isar collection was added). `pubspec.yaml`, `assets/`
and `analysis_options.yaml` are unchanged.

## Deleted

- `lib/features/home/presentation/home_screen.dart` (old Home placeholder, replaced by the dashboard)
- `lib/features/onboarding/presentation/widgets/choice_icon_tile.dart` → moved to `lib/core/design_system/components/choice_icon_tile.dart` (now shared)
- `lib/features/onboarding/presentation/widgets/learner_choice_icons.dart` → moved to `lib/features/learner/presentation/learner_icons.dart` (now shared)
- `lib/features/onboarding/presentation/widgets/trail_progress_bar.dart` → moved to `lib/core/mascot/trail_progress_bar.dart` (now shared)
- `lib/features/onboarding/presentation/widgets/xp_chip.dart` → moved to `lib/core/design_system/components/xp_chip.dart` (now shared)

## Modified

- `README.md`: Phase 3 setup + manual test checklist
- `docs/ARCHITECTURE.md`: Learning/dashboard features, progress model, navigation
- `lib/app/app.dart`: Provides CourseRepository and LearningProgressRepository
- `lib/app/app_dependencies.dart`: Registers LessonAttemptRecord schema, builds the new repositories
- `lib/app/app_router.dart`: /home now opens MainShell; new /lesson route; debug reset clears lessons
- `lib/core/design_system/design_system.dart`: Exports the new shared components
- `lib/core/design_system/motion/confetti_burst.dart`: New optional playOnMount (completion screen)
- `lib/core/mascot/mascot.dart`: Exports FoxLine and TrailProgressBar
- `lib/features/learner/data/learner_profile_mapper.dart`: totalXp -> onboardingXp
- `lib/features/learner/data/learner_profile_record.dart`: totalXp -> onboardingXp
- `lib/features/learner/domain/learner_profile.dart`: totalXp -> onboardingXp (lifetime XP is now calculated)
- `lib/features/onboarding/domain/mini_lesson.dart`: Uses shared MultipleChoiceQuestion (MiniLessonQuestion removed)
- `lib/features/onboarding/domain/onboarding_content_catalog.dart`: Uses shared MultipleChoiceQuestion
- `lib/features/onboarding/domain/onboarding_draft.dart`: Writes onboardingXp
- `lib/features/onboarding/presentation/state/fox_script.dart`: FoxLine moved to core/mascot
- `lib/features/onboarding/presentation/state/onboarding_controller.dart`: Question type renamed
- `lib/features/onboarding/presentation/steps/interests_step.dart`: Imports moved widgets
- `lib/features/onboarding/presentation/steps/learning_goal_step.dart`: Imports moved widgets
- `lib/features/onboarding/presentation/steps/mini_lesson_step.dart`: Uses shared AnswerOptionCard + CodeBlock (same look)
- `lib/features/onboarding/presentation/steps/ready_step.dart`: Shared StatTile; "Day streak 1" tile now "Day 1 / Of your journey" (streaks start with real lessons)
- `lib/features/onboarding/presentation/widgets/answer_feedback_panel.dart`: Now builds the shared FeedbackPanel
- `lib/features/onboarding/presentation/widgets/onboarding_action_bar.dart`: Uses shared FeedbackPanel
- `lib/features/onboarding/presentation/widgets/onboarding_top_bar.dart`: Imports moved widgets
- `test/features/learner/data/learner_profile_mapper_test.dart`: onboardingXp rename
- `test/features/onboarding/domain/mini_lesson_attempt_test.dart`: MultipleChoiceQuestion rename
- `test/features/onboarding/domain/onboarding_draft_test.dart`: onboardingXp rename
- `test/features/onboarding/presentation/onboarding_controller_test.dart`: onboardingXp rename
- `test/helpers/fake_repositories.dart`: Adds FakeLearningProgressRepository

## New

**lib/core/design_system/components/**

- `lib/core/design_system/components/answer_option_card.dart`
- `lib/core/design_system/components/choice_icon_tile.dart` (moved from onboarding)
- `lib/core/design_system/components/code_block.dart`
- `lib/core/design_system/components/feedback_panel.dart`
- `lib/core/design_system/components/progress_track.dart`
- `lib/core/design_system/components/stat_tile.dart`
- `lib/core/design_system/components/xp_chip.dart` (moved from onboarding)

**lib/core/mascot/**

- `lib/core/mascot/fox_line.dart`
- `lib/core/mascot/trail_progress_bar.dart` (moved from onboarding)

**lib/features/dashboard/**

- `lib/features/dashboard/presentation/courses/courses_tab.dart`
- `lib/features/dashboard/presentation/home/home_tab.dart`
- `lib/features/dashboard/presentation/home/widgets/continue_learning_card.dart`
- `lib/features/dashboard/presentation/home/widgets/daily_quests_card.dart`
- `lib/features/dashboard/presentation/home/widgets/home_header.dart`
- `lib/features/dashboard/presentation/home/widgets/kit_greeting.dart`
- `lib/features/dashboard/presentation/home/widgets/level_card.dart`
- `lib/features/dashboard/presentation/main_shell.dart`
- `lib/features/dashboard/presentation/main_tab.dart`
- `lib/features/dashboard/presentation/profile/profile_tab.dart`
- `lib/features/dashboard/presentation/state/dashboard_controller.dart`
- `lib/features/dashboard/presentation/state/dashboard_kit_script.dart`
- `lib/features/dashboard/presentation/widgets/brand_bottom_nav.dart`
- `lib/features/dashboard/presentation/widgets/course_card.dart`
- `lib/features/dashboard/presentation/widgets/dashboard_status_views.dart`
- `lib/features/dashboard/presentation/widgets/section_header.dart`
- `lib/features/dashboard/presentation/widgets/streak_chip.dart`

**lib/features/learner/**

- `lib/features/learner/presentation/learner_icons.dart` (moved from onboarding)

**lib/features/learning/**

- `lib/features/learning/data/bundled_course_repository.dart`
- `lib/features/learning/data/catalog/html_basics_course.dart`
- `lib/features/learning/data/catalog/python_basics_course.dart`
- `lib/features/learning/data/learning_progress_local_data_source.dart`
- `lib/features/learning/data/learning_progress_repository_impl.dart`
- `lib/features/learning/data/lesson_attempt_mapper.dart`
- `lib/features/learning/data/lesson_attempt_record.dart`
- `lib/features/learning/domain/course.dart`
- `lib/features/learning/domain/course_repository.dart`
- `lib/features/learning/domain/daily_quest.dart`
- `lib/features/learning/domain/learner_level.dart`
- `lib/features/learning/domain/learning_progress_repository.dart`
- `lib/features/learning/domain/learning_summary.dart`
- `lib/features/learning/domain/lesson.dart`
- `lib/features/learning/domain/lesson_attempt.dart`
- `lib/features/learning/domain/lesson_run.dart`
- `lib/features/learning/domain/lesson_scoring.dart`
- `lib/features/learning/domain/multiple_choice_question.dart`
- `lib/features/learning/domain/progress_calculator.dart`
- `lib/features/learning/presentation/activities/activity_scroll.dart`
- `lib/features/learning/presentation/activities/choice_tone.dart`
- `lib/features/learning/presentation/activities/concept_activity_view.dart`
- `lib/features/learning/presentation/activities/fill_in_blank_activity_view.dart`
- `lib/features/learning/presentation/activities/lesson_activity_view.dart`
- `lib/features/learning/presentation/activities/multiple_choice_activity_view.dart`
- `lib/features/learning/presentation/lesson_screen.dart`
- `lib/features/learning/presentation/state/lesson_kit_script.dart`
- `lib/features/learning/presentation/state/lesson_session_controller.dart`
- `lib/features/learning/presentation/views/lesson_complete_view.dart`
- `lib/features/learning/presentation/views/lesson_intro_view.dart`
- `lib/features/learning/presentation/views/lesson_player_view.dart`
- `lib/features/learning/presentation/views/lesson_status_views.dart`
- `lib/features/learning/presentation/widgets/lesson_backdrop.dart`
- `lib/features/learning/presentation/widgets/lesson_kit_row.dart`
- `lib/features/learning/presentation/widgets/lesson_top_bar.dart`

**test/features/dashboard/**

- `test/features/dashboard/presentation/dashboard_controller_test.dart`

**test/features/learning/**

- `test/features/learning/data/course_catalog_test.dart`
- `test/features/learning/data/lesson_attempt_mapper_test.dart`
- `test/features/learning/domain/lesson_run_test.dart`
- `test/features/learning/domain/lesson_scoring_test.dart`
- `test/features/learning/domain/progress_calculator_test.dart`
- `test/features/learning/presentation/lesson_session_controller_test.dart`

**test/helpers/**

- `test/helpers/test_data.dart`

## Data migration note

`LearnerProfileRecord.totalXp` was renamed to `onboardingXp`. On a device that already
finished onboarding with the Phase 2 build, Isar drops the old field, so that learner
loses the 10 onboarding XP. Use Profile → "Reset local data" (debug) or reinstall to test
the full flow cleanly.
