import 'package:flutter_test/flutter_test.dart';
import 'package:w3_lms/features/learner/data/learner_profile_mapper.dart';
import 'package:w3_lms/features/learner/data/learner_profile_record.dart';

import '../../../helpers/test_data.dart';

void main() {
  test('round-trips with a diagnostic baseline', () {
    final profile = testProfile(diagnostic: weakInQuant);
    expect(profile.toRecord().toDomain(), profile);
  });

  test('round-trips a skipped diagnostic as null', () {
    final profile = testProfile();
    final record = profile.toRecord();
    expect(record.diagnosticSectionIds, isEmpty);
    expect(record.toDomain()!.diagnostic, isNull);
  });

  test('stores stable keys, not Dart enum names', () {
    final record = testProfile().toRecord();
    expect(record.examTimeframeKey, '1_to_3_months');
    expect(record.dailyGoalMinutes, 10);
  });

  test('rejects incomplete records instead of crashing', () {
    final broken = testProfile().toRecord()..examTimeframeKey = 'unknown';
    expect(broken.toDomain(), isNull);
  });

  test('keeps createdAt from an existing record', () {
    final existing = LearnerProfileRecord()..createdAt = DateTime(2025);
    expect(testProfile().toRecord(existing: existing).createdAt, DateTime(2025));
  });
}
