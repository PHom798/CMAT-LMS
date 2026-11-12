import 'package:flutter/foundation.dart';

import 'package:w3_lms/features/learner/domain/daily_goal.dart';
import 'package:w3_lms/features/learner/domain/diagnostic_result.dart';
import 'package:w3_lms/features/learner/domain/exam_timeframe.dart';
import 'package:w3_lms/features/learner/domain/learner_profile.dart';
import 'package:w3_lms/features/onboarding/domain/diagnostic_status.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_step.dart';

/// Answers collected so far. Immutable: every change returns a new draft,
/// which keeps state changes explicit and easy to test.
@immutable
class OnboardingDraft {
  const OnboardingDraft({
    this.name = '',
    this.examTimeframe,
    this.dailyGoal,
    this.diagnosticStatus = DiagnosticStatus.notTaken,
    this.diagnosticResult,
    this.earnedXp = 0,
  });

  static const maxNameLength = 24;

  final String name;
  final ExamTimeframe? examTimeframe;
  final DailyGoal? dailyGoal;
  final DiagnosticStatus diagnosticStatus;

  /// Present only when [diagnosticStatus] is completed.
  final DiagnosticResult? diagnosticResult;
  final int earnedXp;

  /// First word of the trimmed name, e.g. "  Hom Bahadur " -> "Hom".
  String get firstName {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '' : trimmed.split(RegExp(r'\s+')).first;
  }

  bool get isComplete =>
      firstName.isNotEmpty &&
      examTimeframe != null &&
      dailyGoal != null &&
      diagnosticStatus != DiagnosticStatus.notTaken;

  /// Whether the data a step asks for has been provided.
  bool hasAnswered(OnboardingStep step) => switch (step) {
        OnboardingStep.name => firstName.isNotEmpty,
        OnboardingStep.examTimeframe => examTimeframe != null,
        OnboardingStep.diagnostic => diagnosticStatus != DiagnosticStatus.notTaken,
        OnboardingStep.dailyGoal => dailyGoal != null,
        OnboardingStep.welcome || OnboardingStep.ready => true,
      };

  OnboardingDraft copyWith({String? name, ExamTimeframe? examTimeframe, DailyGoal? dailyGoal}) {
    return OnboardingDraft(
      name: name ?? this.name,
      examTimeframe: examTimeframe ?? this.examTimeframe,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      diagnosticStatus: diagnosticStatus,
      diagnosticResult: diagnosticResult,
      earnedXp: earnedXp,
    );
  }

  OnboardingDraft withDiagnosticCompleted(DiagnosticResult result) => OnboardingDraft(
        name: name,
        examTimeframe: examTimeframe,
        dailyGoal: dailyGoal,
        diagnosticStatus: DiagnosticStatus.completed,
        diagnosticResult: result,
        earnedXp: DiagnosticScoring.xpFor(result.correct),
      );

  OnboardingDraft withDiagnosticSkipped() => OnboardingDraft(
        name: name,
        examTimeframe: examTimeframe,
        dailyGoal: dailyGoal,
        diagnosticStatus: DiagnosticStatus.skipped,
      );

  /// Converts a complete draft into the app-level profile.
  /// Throws [StateError] if called before every answer is present.
  LearnerProfile toLearnerProfile() {
    if (!isComplete) {
      throw StateError('Cannot create a LearnerProfile from an incomplete draft.');
    }
    return LearnerProfile(
      name: firstName,
      examTimeframe: examTimeframe!,
      dailyGoal: dailyGoal!,
      onboardingXp: earnedXp,
      diagnostic: diagnosticResult,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is OnboardingDraft &&
      other.name == name &&
      other.examTimeframe == examTimeframe &&
      other.dailyGoal == dailyGoal &&
      other.diagnosticStatus == diagnosticStatus &&
      other.diagnosticResult == diagnosticResult &&
      other.earnedXp == earnedXp;

  @override
  int get hashCode =>
      Object.hash(name, examTimeframe, dailyGoal, diagnosticStatus, diagnosticResult, earnedXp);
}
