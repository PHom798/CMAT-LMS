# Phase 3.5 changes: CMAT pivot

Compared with the Phase 3 project. To apply: **replace `lib/`, `test/`, `docs/`, `assets/content/`,
`pubspec.yaml` and `README.md`** with the ones in this zip (whole folders, because files were
deleted), then run `flutter pub get` and build_runner. No new packages; `pubspec.yaml` only
adds the two content asset folders.

**Uninstall the old build before testing** (or use Profile → Reset local data): the saved
onboarding and learner-profile formats changed, so old local data is not migrated.

Summary: 24 new, 55 modified, 16 deleted.

## Deleted (and what replaces them)

- `lib/features/dashboard/presentation/courses/courses_tab.dart` → `lib/features/dashboard/presentation/practice/practice_tab.dart`
- `lib/features/learner/domain/learning_goal.dart`
- `lib/features/learner/domain/learning_interest.dart`
- `lib/features/learner/presentation/learner_icons.dart`
- `lib/features/learning/data/bundled_course_repository.dart` → `lib/features/learning/data/bundled_content_repository.dart (reads JSON)`
- `lib/features/learning/data/catalog/html_basics_course.dart` → `assets/content/cmat/sections/*.json`
- `lib/features/learning/data/catalog/python_basics_course.dart` → `assets/content/cmat/sections/*.json`
- `lib/features/learning/domain/course_repository.dart` → `lib/features/learning/domain/content_repository.dart (now also serves the exam pattern and diagnostic)`
- `lib/features/onboarding/domain/mini_lesson.dart`
- `lib/features/onboarding/domain/onboarding_content_catalog.dart`
- `lib/features/onboarding/domain/welcome_topic.dart`
- `lib/features/onboarding/presentation/steps/interests_step.dart`
- `lib/features/onboarding/presentation/steps/learning_goal_step.dart` → `lib/features/onboarding/presentation/steps/exam_timeframe_step.dart`
- `lib/features/onboarding/presentation/steps/mini_lesson_step.dart` → `lib/features/onboarding/presentation/steps/diagnostic_step.dart`
- `test/features/learning/data/course_catalog_test.dart` → `test/features/learning/data/content_test.dart`
- `test/features/onboarding/domain/mini_lesson_attempt_test.dart` → `test/features/learning/domain/assessment_run_test.dart`

## Modified

- `README.md`
- `docs/ARCHITECTURE.md`
- `lib/app/app.dart`
- `lib/app/app_dependencies.dart`
- `lib/core/design_system/design_system.dart`
- `lib/features/dashboard/presentation/home/home_tab.dart`
- `lib/features/dashboard/presentation/home/widgets/continue_learning_card.dart`
- `lib/features/dashboard/presentation/home/widgets/home_header.dart`
- `lib/features/dashboard/presentation/main_shell.dart`
- `lib/features/dashboard/presentation/main_tab.dart`
- `lib/features/dashboard/presentation/profile/profile_tab.dart`
- `lib/features/dashboard/presentation/state/dashboard_controller.dart`
- `lib/features/dashboard/presentation/state/dashboard_kit_script.dart`
- `lib/features/dashboard/presentation/widgets/course_card.dart`
- `lib/features/learner/data/learner_profile_mapper.dart`
- `lib/features/learner/data/learner_profile_record.dart`
- `lib/features/learner/domain/learner_profile.dart`
- `lib/features/learning/domain/course.dart`
- `lib/features/learning/domain/learning_summary.dart`
- `lib/features/learning/domain/lesson.dart`
- `lib/features/learning/domain/multiple_choice_question.dart`
- `lib/features/learning/domain/progress_calculator.dart`
- `lib/features/learning/presentation/activities/choice_tone.dart`
- `lib/features/learning/presentation/activities/concept_activity_view.dart`
- `lib/features/learning/presentation/activities/fill_in_blank_activity_view.dart`
- `lib/features/learning/presentation/activities/lesson_activity_view.dart`
- `lib/features/learning/presentation/activities/multiple_choice_activity_view.dart`
- `lib/features/learning/presentation/lesson_screen.dart`
- `lib/features/learning/presentation/state/lesson_session_controller.dart`
- `lib/features/learning/presentation/views/lesson_intro_view.dart`
- `lib/features/onboarding/data/onboarding_progress_mapper.dart`
- `lib/features/onboarding/data/onboarding_progress_record.dart`
- `lib/features/onboarding/domain/onboarding_draft.dart`
- `lib/features/onboarding/domain/onboarding_step.dart`
- `lib/features/onboarding/presentation/onboarding_screen.dart`
- `lib/features/onboarding/presentation/state/fox_script.dart`
- `lib/features/onboarding/presentation/state/onboarding_controller.dart`
- `lib/features/onboarding/presentation/steps/daily_goal_step.dart`
- `lib/features/onboarding/presentation/steps/ready_step.dart`
- `lib/features/onboarding/presentation/steps/welcome_step.dart`
- `lib/features/onboarding/presentation/views/onboarding_view.dart`
- `lib/features/onboarding/presentation/widgets/answer_feedback_panel.dart`
- `lib/features/onboarding/presentation/widgets/fox_stage.dart`
- `lib/features/onboarding/presentation/widgets/onboarding_action_bar.dart`
- `lib/features/onboarding/presentation/widgets/onboarding_step_switcher.dart`
- `pubspec.yaml`
- `test/features/dashboard/presentation/dashboard_controller_test.dart`
- `test/features/learner/data/learner_profile_mapper_test.dart`
- `test/features/learning/domain/lesson_run_test.dart`
- `test/features/learning/domain/progress_calculator_test.dart`
- `test/features/learning/presentation/lesson_session_controller_test.dart`
- `test/features/onboarding/data/onboarding_progress_mapper_test.dart`
- `test/features/onboarding/domain/onboarding_draft_test.dart`
- `test/features/onboarding/presentation/onboarding_controller_test.dart`
- `test/helpers/test_data.dart`

## New

- `assets/content/cmat/diagnostic.json`
- `assets/content/cmat/exam.json`
- `assets/content/cmat/sections/general.json`
- `assets/content/cmat/sections/logical.json`
- `assets/content/cmat/sections/quant.json`
- `assets/content/cmat/sections/verbal.json`
- `docs/CONTENT.md`
- `lib/core/design_system/tokens/app_icons.dart`
- `lib/features/dashboard/presentation/home/widgets/sections_card.dart`
- `lib/features/dashboard/presentation/practice/practice_tab.dart`
- `lib/features/learner/domain/diagnostic_result.dart`
- `lib/features/learner/domain/exam_timeframe.dart`
- `lib/features/learning/data/bundled_content_repository.dart`
- `lib/features/learning/data/content_parser.dart`
- `lib/features/learning/domain/assessment.dart`
- `lib/features/learning/domain/content_repository.dart`
- `lib/features/learning/domain/exam_pattern.dart`
- `lib/features/learning/presentation/activities/content_snippet.dart`
- `lib/features/learning/presentation/activities/question_activity_view.dart`
- `lib/features/onboarding/domain/diagnostic_status.dart`
- `lib/features/onboarding/presentation/steps/diagnostic_step.dart`
- `lib/features/onboarding/presentation/steps/exam_timeframe_step.dart`
- `test/features/learning/data/content_test.dart`
- `test/features/learning/domain/assessment_run_test.dart`
