# Phase 4 changes: Learning Journey

Compared with Phase 3.6. Replace `lib/`, `test/`, `docs/`, `assets/content/` and `README.md`
(whole folders), then run build_runner: there are two new Isar collections.
No new packages. Existing lesson progress is kept (lesson ids are unchanged); just run
`dart run build_runner build --delete-conflicting-outputs`, then `flutter analyze && flutter test`.

Summary: 20 new, 43 modified, 4 deleted.

## Deleted

- `lib/features/dashboard/presentation/widgets/course_card.dart` → path cards in practice_tab.dart
- `lib/features/learning/data/lesson_attempt_mapper.dart` → learning_mappers.dart
- `lib/features/learning/data/lesson_attempt_record.dart` → learning_records.dart (now also answers and checkpoint results)
- `test/features/learning/data/lesson_attempt_mapper_test.dart` → learning_mappers_test.dart

## Modified

- `README.md`
- `assets/content/cmat/diagnostic.json`
- `assets/content/cmat/sections/general.json`
- `assets/content/cmat/sections/logical.json`
- `assets/content/cmat/sections/quant.json`
- `assets/content/cmat/sections/verbal.json`
- `docs/ARCHITECTURE.md`
- `docs/CONTENT.md`
- `lib/app/app.dart`
- `lib/app/app_dependencies.dart`
- `lib/app/app_router.dart`
- `lib/features/dashboard/presentation/home/home_tab.dart`
- `lib/features/dashboard/presentation/home/widgets/home_header.dart`
- `lib/features/dashboard/presentation/home/widgets/mission_card.dart`
- `lib/features/dashboard/presentation/home/widgets/sections_card.dart`
- `lib/features/dashboard/presentation/main_shell.dart`
- `lib/features/dashboard/presentation/practice/practice_tab.dart`
- `lib/features/dashboard/presentation/state/dashboard_controller.dart`
- `lib/features/dashboard/presentation/state/dashboard_kit_script.dart`
- `lib/features/dashboard/presentation/widgets/achievement_medal.dart`
- `lib/features/learning/data/bundled_content_repository.dart`
- `lib/features/learning/data/content_parser.dart`
- `lib/features/learning/data/learning_progress_local_data_source.dart`
- `lib/features/learning/data/learning_progress_repository_impl.dart`
- `lib/features/learning/domain/achievement.dart`
- `lib/features/learning/domain/assessment.dart`
- `lib/features/learning/domain/content_repository.dart`
- `lib/features/learning/domain/course.dart`
- `lib/features/learning/domain/learning_progress_repository.dart`
- `lib/features/learning/domain/learning_summary.dart`
- `lib/features/learning/domain/lesson.dart`
- `lib/features/learning/domain/lesson_run.dart`
- `lib/features/learning/domain/multiple_choice_question.dart`
- `lib/features/learning/domain/progress_calculator.dart`
- `lib/features/learning/presentation/state/lesson_session_controller.dart`
- `lib/features/learning/presentation/widgets/lesson_kit_row.dart`
- `test/features/dashboard/presentation/dashboard_controller_test.dart`
- `test/features/learning/data/content_test.dart`
- `test/features/learning/domain/assessment_run_test.dart`
- `test/features/learning/domain/lesson_run_test.dart`
- `test/features/learning/domain/progress_calculator_test.dart`
- `test/features/learning/presentation/lesson_session_controller_test.dart`
- `test/helpers/fake_repositories.dart`

## New

- `lib/app/app_learning_navigator.dart`
- `lib/core/navigation/learning_navigator.dart`
- `lib/features/dashboard/presentation/home/widgets/review_mistakes.dart`
- `lib/features/learning/data/learning_mappers.dart`
- `lib/features/learning/data/learning_records.dart`
- `lib/features/learning/domain/journey.dart`
- `lib/features/learning/domain/learning_history.dart`
- `lib/features/learning/domain/quiz_request.dart`
- `lib/features/learning/presentation/journey/section_journey_screen.dart`
- `lib/features/learning/presentation/journey/topic_path.dart`
- `lib/features/learning/presentation/quiz_screen.dart`
- `lib/features/learning/presentation/state/journey_kit_script.dart`
- `lib/features/learning/presentation/state/quiz_kit_script.dart`
- `lib/features/learning/presentation/state/quiz_session_controller.dart`
- `lib/features/learning/presentation/state/section_journey_controller.dart`
- `lib/features/learning/presentation/widgets/kit_row.dart`
- `test/features/learning/data/learning_mappers_test.dart`
- `test/features/learning/domain/journey_builder_test.dart`
- `test/features/learning/domain/learning_history_test.dart`
- `test/features/learning/presentation/quiz_session_controller_test.dart`
