# Architecture

Feature-first, three layers per feature, provider for state and DI, Isar as
the local source of truth, and learning content as bundled JSON. The MVP is
a **CMAT entrance-prep app**; 

## Folder structure

```
lib/
  main.dart                     Boot: open DB, pick first route, runApp
  app/                          Composition root (the only layer that knows every feature)
    app_dependencies.dart       Opens Isar, builds data sources + repositories
    app.dart                    MultiProvider + MaterialApp
    app_router.dart             Routes: /onboarding, /home (main shell), /lesson
  core/                         Feature-agnostic building blocks
    design_system/              Tokens (colors, type, spacing, motion, icons), theme,
                                components, motion
      design_system.dart        One import for all of it
    mascot/                     Kit: FoxMascot, SpeechBubble, FoxLine, TrailProgressBar
    database/                   Isar opener + LocalStorageException
    navigation/                 LearningNavigator: open lessons, checkpoints, reviews, paths by id
  features/
    learner/                    Who the learner is (shared by every feature)
      domain/                   LearnerProfile, ExamTimeframe, DailyGoal, DiagnosticResult
      data/                     Isar record, mapper, data source, repository impl
    onboarding/                 Welcome, name, exam timeframe, diagnostic, daily goal, ready
    learning/                   Exam content, lessons and progress
      domain/                   ExamPattern, Course → Topic → Lesson (+ Checkpoint), activity
                                types, JourneyBuilder (paths and unlocks), LearningHistory
                                (attempts, answers, checkpoints), AssessmentRun, LessonRun,
                                scoring, achievements, ProgressCalculator, repository interfaces
      data/                     ContentParser + BundledContentRepository (JSON); Isar records
                                for attempts, answers and checkpoint results; repositories
      presentation/
        activities/             Question and concept views (shared, see rule 1)
        journey/                SectionJourneyScreen: the visual path for one section
        lesson_screen.dart      Lesson: intro, player, completion
        quiz_screen.dart        Topic checkpoint or mistake review
    dashboard/                  The main app after onboarding
      presentation/             MainShell + Home, Practice and Profile tabs
assets/content/cmat/            exam.json, diagnostic.json, sections/*.json (see CONTENT.md)
test/                           Mirrors lib/; fakes and sample data in test/helpers
```

## Layer responsibilities

| Layer | Contains | May import | Must not |
|---|---|---|---|
| **domain** | Entities, value objects, pure rules, repository interfaces | Dart, `foundation`, other features' `domain/` | Flutter widgets, Isar, provider |
| **data** | Isar records, JSON parsing, data sources, repository implementations | its own domain, other features' `domain/`, `core/database` | widgets, controllers |
| **presentation** | Screens, widgets, `ChangeNotifier` controllers | domains, `core/`, provider | Isar, data sources, records |
| **app** | Wiring only | everything | business logic |

Rules that keep features decoupled:

1. A feature may import another feature's **domain only**. One exception:
   `learning/presentation/activities/` (the question views), which lessons,
   the onboarding diagnostic and future mock tests all share so every
   question in the app looks and behaves the same.
2. Features never push each other's routes. They call the
   `LearningNavigator` interface (from `core/`) with ids, and the app layer
   (`AppLearningNavigator`) maps those calls to routes.

## How state flows

```
Widget ──tap──▶ Controller (ChangeNotifier) ──▶ Repository interface
  ▲                    │                              │
  │ context.watch /    │ notifyListeners()            ▼
  │ context.select     │                     Repository impl ─▶ data source ─▶ Isar / JSON
  └────────────────────┘
```

- **App-wide singletons** (repositories) are created once in
  `AppDependencies` and exposed with `Provider<Interface>.value` in `app.dart`.
- **Screen-scoped state** is a `ChangeNotifier` created by the screen with
  `ChangeNotifierProvider(create: …)`: `OnboardingController`,
  `DashboardController` (shared by the three tabs), `LessonSessionController`.
- Widgets use `context.select` / `context.watch` in `build`, and
  `context.read` **only in callbacks or `initState`** (provider asserts on it).
- Pure rules live in immutable or plain-Dart domain classes and are unit
  tested without Flutter. Controllers orchestrate them.

## Content (offline, JSON)

All learning content lives in `assets/content/cmat/` and is read by
`BundledContentRepository` through `ContentParser`:

- `exam.json`: the official pattern (4 × 25 questions, 90 minutes, 40% to
  pass, no negative marking) and the list of section course files. The app
  reads these numbers instead of hardcoding them, so a pattern change is a
  content update.
- `diagnostic.json`: the onboarding questions, tagged by section.
- `sections/*.json`: one course per section with its lessons.

Parsing errors name the exact field (`lessons[0].activities[3].correctIndex`).
`test/features/learning/data/content_test.dart` validates every file. The
writing guide is in [CONTENT.md](CONTENT.md).

## Onboarding

`welcome → name → examTimeframe → diagnostic → dailyGoal → ready`

- Progress is checkpointed to Isar on every step change and when the app is
  backgrounded; restarting resumes at the first unanswered step.
- The **diagnostic** (`AssessmentRun`) asks 2 questions per section with
  instant feedback and no retries, then stores a `DiagnosticResult`. Its
  weakest section becomes the starting point. It can be skipped.
- The exam timeframe pre-selects a suggested daily goal.
- On completion a `LearnerProfile` is written (name, timeframe, daily goal,
  diagnostic, onboarding XP). Other features read only that.

## Learning Journey

Each section's syllabus is a list of **topics**; each topic has lessons and
a **checkpoint** quiz. `JourneyBuilder` turns the syllabus plus history into
a path:

- Steps open one at a time in syllabus order: a topic's lessons, then its
  checkpoint, then the next topic. Completed steps can always be replayed.
- Passing a checkpoint (pass mark from content, rounded up) **masters** the
  topic: +20 XP the first time, and the "Topic master" achievement.
- Topics without lessons are shown as **Coming soon** and never block the
  topics after them.
- **Mastery** of a topic = share of its questions whose latest answer is right.
- **Mistakes** = questions whose latest answer is wrong. A mistake review
  (`MistakeReviewQuiz`) asks them again; each fix gives +2 XP and removes it.

## Learning progress

Everything comes from three append-only tables (`LearningHistory`): lesson
attempts, every answer (by stable question id), and checkpoint results.
Nothing else about progress is stored.

```
LearningHistory ────┐
LearnerProfile ─────┼─▶ ProgressCalculator.summarize(now) ─▶ LearningSummary
Courses (content) ──┘        (pure, unit-tested)              XP, level, streak, quests,
                                                              paths, mistakes, next step
```

- **Total XP** = onboarding XP + lesson attempts + first checkpoint passes +
  fixed mistakes + daily quests completed on any day + earned achievements.
- **Lesson XP**: 10 for finishing + 2 per first-try answer + 5 if perfect;
  replays earn half. Wrong answers return at the end of the lesson.
- **Daily quests**: complete a lesson, 6 first-try answers, reach the daily
  goal (lesson minutes). **Streak**: consecutive days with a lesson.
- **Next step** (the mission): in the unfinished section studied most
  recently, else the weakest diagnostic section, else the first unfinished
  one, the next step on its path (a lesson or a checkpoint).

- **Achievements** (`AchievementRules`): first lesson, flawless lesson,
  a 3-day streak, mastering each section, and an all-rounder badge for
  completing a lesson in every section. They are calculated from history
  like everything else, and their XP is part of total XP.
- **Week activity**: the last 7 days, for the streak strip on Home.

`LearningProgressRepository.watchHistory()` merges change signals from the
three Isar collections. `DashboardController` and `SectionJourneyController`
listen to it, so Home, Practice and an open path update the moment anything
is saved. Lessons and checkpoints save their answers in the same transaction.

## Home and Kit's roles

Home answers three questions, in order: *what next* (Kit's mission card),
*why come back* (daily quests, the 7-day streak strip) and *what have I
achieved* (section progress, achievement medals). Layouts vary on purpose:
open header, white mission card, tinted quest band, open streak strip,
white sections card, open medal shelf.

Kit has a job in each place, with one script function per place:

| Where | Kit's role | Art used today |
|---|---|---|
| Mission card | Briefs the next mission, reacts to XP and achievements, gives exam tips when tapped | Full body peeking over the card |
| Daily quests | Narrates what's left today | Head avatar |
| Lessons | Reacts to every answer | Full body beside a bubble |
| Lesson complete | Celebrates, announces achievements | Large full body + confetti |

**Poses to commission** (drop into `FoxAssets.poses`, no code changes):
waving, thinking (paw on chin), cheering (arms up), oops (sheepish), and
pointing (for "next mission"). Export each at about 800 × 1200 px, with a
transparent background, matching the current illustration.

## Navigation

```
/onboarding ──completed──▶ /home (MainShell: Home | Practice | Profile)
                               │  LearningNavigator
                               ├──▶ /section (a path) ──▶ /lesson, /quiz
                               ├──▶ /lesson   (mission) ──pop(true)──▶ Home, Kit cheers
                               └──▶ /quiz     (checkpoint or mistake review)
```

## Storage

| Collection | Owner | Written | Read by |
|---|---|---|---|
| `OnboardingProgressRecord` | onboarding | step changes, app backgrounded | onboarding, `main.dart` |
| `LearnerProfileRecord` | learner | once, when onboarding completes | dashboard, lessons |
| `LessonAttemptRecord` | learning | once per finished lesson | dashboard, paths, lessons |
| `AnswerRecord` | learning | every first-try lesson answer, every checkpoint and review answer | mastery, mistakes |
| `CheckpointResultRecord` | learning | once per finished checkpoint | paths, XP |

Enums are stored by stable keys; unknown keys are dropped safely. Records
carry `updatedAt` for future sync.

## Offline-first and future sync

Isar is the source of truth and all content and fonts are bundled, so the
whole app works with no network. When sync or downloadable content arrives,
add a remote data source next to the local one inside the repository
implementation; interfaces, controllers and widgets don't change.

## Adding things

- **A lesson or course:** edit JSON (see CONTENT.md), run `flutter test`.
- **A question type:** add a `LessonActivity` subclass in
  `learning/domain/lesson.dart`, parse it in `content_parser.dart`, render it
  in `presentation/activities/`. The sealed class makes the compiler flag
  every switch you missed.
- **A feature** (e.g. mock tests): `lib/features/<name>/{domain,data,presentation}`,
  a controller taking repository interfaces, a screen that provides it, a
  route in `app_router.dart`. Register any new Isar schema in
  `AppDependencies._schemas`, then run build_runner.

## Conventions

- Files `snake_case.dart`; package imports only (`package:w3_lms/...`).
- Controllers end in `Controller`, repositories in `Repository` /
  `RepositoryImpl`, Isar classes in `Record`, data sources in `DataSource`.
- Colors, text styles, spacing, radii, durations and content icons come
  from design-system tokens.
- Kit's lines live in one "script" function per feature
  (`fox_script.dart`, `lesson_kit_script.dart`, `dashboard_kit_script.dart`).
