# Phase 3.6 changes: dashboard engagement pass

Compared with Phase 3.5. Replace `lib/`, `test/`, `docs/` and `README.md` (whole folders).
No new packages, no new assets, no storage changes: existing local data keeps working, so
**no uninstall needed**. Run `flutter analyze && flutter test`.

Summary: 6 new, 17 modified, 4 deleted.

## Deleted

- `lib/features/dashboard/presentation/home/widgets/continue_learning_card.dart` → mission_card.dart
- `lib/features/dashboard/presentation/home/widgets/daily_quests_card.dart` → quests_section.dart (open tinted band)
- `lib/features/dashboard/presentation/home/widgets/kit_greeting.dart` → mission_card.dart (Kit now lives inside the card)
- `lib/features/dashboard/presentation/home/widgets/level_card.dart` → level bar in home_header.dart

## Modified

- `README.md`
- `docs/ARCHITECTURE.md`
- `lib/core/design_system/components/pill_tag.dart`
- `lib/features/dashboard/presentation/home/home_tab.dart`
- `lib/features/dashboard/presentation/home/widgets/home_header.dart`
- `lib/features/dashboard/presentation/home/widgets/sections_card.dart`
- `lib/features/dashboard/presentation/profile/profile_tab.dart`
- `lib/features/dashboard/presentation/state/dashboard_controller.dart`
- `lib/features/dashboard/presentation/state/dashboard_kit_script.dart`
- `lib/features/learning/domain/learning_summary.dart`
- `lib/features/learning/domain/progress_calculator.dart`
- `lib/features/learning/presentation/state/lesson_kit_script.dart`
- `lib/features/learning/presentation/state/lesson_session_controller.dart`
- `lib/features/learning/presentation/views/lesson_complete_view.dart`
- `test/features/dashboard/presentation/dashboard_controller_test.dart`
- `test/features/learning/domain/progress_calculator_test.dart`
- `test/features/learning/presentation/lesson_session_controller_test.dart`

## New

- `lib/features/dashboard/presentation/home/widgets/achievements_row.dart`
- `lib/features/dashboard/presentation/home/widgets/mission_card.dart`
- `lib/features/dashboard/presentation/home/widgets/quests_section.dart`
- `lib/features/dashboard/presentation/home/widgets/streak_week.dart`
- `lib/features/dashboard/presentation/widgets/achievement_medal.dart`
- `lib/features/learning/domain/achievement.dart`
