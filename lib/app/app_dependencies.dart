import 'package:flutter/services.dart';
import 'package:isar_community/isar.dart';

import 'package:w3_lms/core/database/isar_database.dart';
import 'package:w3_lms/features/learner/data/learner_profile_local_data_source.dart';
import 'package:w3_lms/features/learner/data/learner_profile_record.dart';
import 'package:w3_lms/features/learner/data/learner_profile_repository_impl.dart';
import 'package:w3_lms/features/learner/domain/learner_profile_repository.dart';
import 'package:w3_lms/features/learning/data/bundled_content_repository.dart';
import 'package:w3_lms/features/learning/data/learning_progress_local_data_source.dart';
import 'package:w3_lms/features/learning/data/learning_progress_repository_impl.dart';
import 'package:w3_lms/features/learning/data/learning_records.dart';
import 'package:w3_lms/features/learning/domain/content_repository.dart';
import 'package:w3_lms/features/learning/domain/learning_progress_repository.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_local_data_source.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_progress_record.dart';
import 'package:w3_lms/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:w3_lms/features/onboarding/domain/onboarding_repository.dart';

/// Composition root: the ONE place that knows about concrete implementations.
///
/// Everything else depends on repository interfaces received through
/// provider. To add a feature: register its Isar schema in [_schemas],
/// build its repository in [initialize], expose it in `app.dart`.
class AppDependencies {
  const AppDependencies({
    required this.learnerProfileRepository,
    required this.onboardingRepository,
    required this.contentRepository,
    required this.learningProgressRepository,
  });

  final LearnerProfileRepository learnerProfileRepository;
  final OnboardingRepository onboardingRepository;
  final ContentRepository contentRepository;
  final LearningProgressRepository learningProgressRepository;

  static final List<CollectionSchema<dynamic>> _schemas = [
    LearnerProfileRecordSchema,
    OnboardingProgressRecordSchema,
    LessonAttemptRecordSchema,
    AnswerRecordSchema,
    CheckpointResultRecordSchema,
  ];

  static Future<AppDependencies> initialize() async {
    final isar = await IsarDatabase.open(_schemas);
    return AppDependencies(
      learnerProfileRepository: LearnerProfileRepositoryImpl(LearnerProfileLocalDataSource(isar)),
      onboardingRepository: OnboardingRepositoryImpl(OnboardingLocalDataSource(isar)),
      contentRepository: BundledContentRepository(rootBundle.loadString),
      learningProgressRepository: LearningProgressRepositoryImpl(LearningProgressLocalDataSource(isar)),
    );
  }
}
