# Writing CMAT content

All content is JSON under `assets/content/cmat/`. No Dart knowledge needed.
After any edit, run `flutter test test/features/learning/data/content_test.dart`:
it checks every file and names the exact field if something is wrong.

> **Status:** everything shipped so far is a **draft** (`"reviewStatus": "draft"`)
> written to build the app against. A subject expert must review every
> question and explanation before release, then set `"reviewStatus": "reviewed"`.
> Questions must be original or properly licensed, never copied from
> coaching books or past papers you don't have rights to.

## Files

| File | What it holds |
|---|---|
| `exam.json` | Exam pattern (duration, pass mark, negative marking) and the 4 sections, each pointing at its course file |
| `diagnostic.json` | Onboarding diagnostic: the same number of questions for every section |
| `sections/<id>.json` | The section's syllabus: topics, their lessons and checkpoints |

## A section file: topics, lessons, checkpoints

Each `sections/<id>.json` is the full syllabus for that section, in teaching order:

```json
{
  "id": "cmat-quant",
  "sectionId": "quant",
  "title": "Quantitative Ability",
  "description": "…",
  "icon": "quant",
  "topics": [
    {
      "id": "quant-percentages",
      "title": "Percentages",
      "description": "One line shown on the path.",
      "lessons": [ { …lesson… } ],
      "checkpoint": { "passPercent": 60, "questions": [ …3 to 5 questions… ] }
    },
    { "id": "quant-ratio", "title": "Ratio and proportion", "description": "…", "lessons": [] }
  ]
}
```

- A topic with `"lessons": []` shows as **Coming soon** on the path. To publish it,
  add its lessons and a checkpoint; nothing else changes.
- The checkpoint is the topic's milestone: students must pass it (`passPercent`, rounded up)
  to master the topic and unlock the next one. Use **new** questions, not ones from the lessons,
  so it tests understanding rather than memory.

## A lesson

```json
{
  "id": "cmat-quant-2",
  "title": "Ratios",
  "objective": "One sentence: what the learner will be able to do.",
  "estimatedMinutes": 5,
  "activities": [ ... ]
}
```

- Lesson, topic and question `id`s are permanent: progress is saved against them.
  Never rename or reuse a shipped id.
- Aim for 2 concept cards + 3 questions, about 5 minutes. A topic usually needs 2 lessons.

## Activity types

**Concept** (read, then Continue)
```json
{ "type": "concept", "title": "…", "body": "…", "example": "optional worked example" }
```

Every question (multiple choice and fill in the blank) needs a unique `"id"`, for example
`"quant-ratio-q4"` or `"quant-ratio-cp2"`. Answers, mastery and the mistake review use it.

**Multiple choice**
```json
{
  "id": "logical-series-q7",
  "type": "multipleChoice",
  "prompt": "What comes next?",
  "snippet": "2, 6, 12, 20, ?",
  "options": ["28", "30", "32"],
  "correctIndex": 1,
  "hint": "optional",
  "explanation": "Shown after answering, right or wrong."
}
```
`correctIndex` counts from 0. Vary its position across questions.

**Fill in the blank** (sentence completion)
```json
{
  "id": "verbal-tenses-agreement-q5",
  "type": "fillInBlank",
  "prompt": "Complete the sentence.",
  "textBefore": "She ",
  "textAfter": " to college every day.",
  "choices": ["go", "goes", "going"],
  "correctIndex": 1,
  "explanation": "…"
}
```

Diagnostic questions use the same shapes plus `"sectionId"`.

## Writing guidelines

- One idea per lesson. Plain, short sentences; students may read in their second language.
- Every explanation says *why* the answer is right, not just what it is.
- Wrong options should be plausible mistakes, not jokes.
- General Awareness: prefer facts that don't go out of date. Anything time-sensitive
  (current office holders, recent events, budgets) needs an owner who updates it.
- Never leave an option ambiguous; if two could be argued, rewrite the question.
