// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_progress_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetOnboardingProgressRecordCollection on Isar {
  IsarCollection<OnboardingProgressRecord> get onboardingProgressRecords =>
      this.collection();
}

const OnboardingProgressRecordSchema = CollectionSchema(
  name: r'OnboardingProgressRecord',
  id: -3610037207924302672,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'currentStepName': PropertySchema(
      id: 1,
      name: r'currentStepName',
      type: IsarType.string,
    ),
    r'dailyGoalMinutes': PropertySchema(
      id: 2,
      name: r'dailyGoalMinutes',
      type: IsarType.long,
    ),
    r'diagnosticCorrect': PropertySchema(
      id: 3,
      name: r'diagnosticCorrect',
      type: IsarType.longList,
    ),
    r'diagnosticSectionIds': PropertySchema(
      id: 4,
      name: r'diagnosticSectionIds',
      type: IsarType.stringList,
    ),
    r'diagnosticStatusName': PropertySchema(
      id: 5,
      name: r'diagnosticStatusName',
      type: IsarType.string,
    ),
    r'diagnosticTotals': PropertySchema(
      id: 6,
      name: r'diagnosticTotals',
      type: IsarType.longList,
    ),
    r'earnedXp': PropertySchema(id: 7, name: r'earnedXp', type: IsarType.long),
    r'examTimeframeKey': PropertySchema(
      id: 8,
      name: r'examTimeframeKey',
      type: IsarType.string,
    ),
    r'isCompleted': PropertySchema(
      id: 9,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 10, name: r'name', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _onboardingProgressRecordEstimateSize,
  serialize: _onboardingProgressRecordSerialize,
  deserialize: _onboardingProgressRecordDeserialize,
  deserializeProp: _onboardingProgressRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _onboardingProgressRecordGetId,
  getLinks: _onboardingProgressRecordGetLinks,
  attach: _onboardingProgressRecordAttach,
  version: '3.4.1',
);

int _onboardingProgressRecordEstimateSize(
  OnboardingProgressRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currentStepName.length * 3;
  bytesCount += 3 + object.diagnosticCorrect.length * 8;
  bytesCount += 3 + object.diagnosticSectionIds.length * 3;
  {
    for (var i = 0; i < object.diagnosticSectionIds.length; i++) {
      final value = object.diagnosticSectionIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.diagnosticStatusName.length * 3;
  bytesCount += 3 + object.diagnosticTotals.length * 8;
  {
    final value = object.examTimeframeKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _onboardingProgressRecordSerialize(
  OnboardingProgressRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeString(offsets[1], object.currentStepName);
  writer.writeLong(offsets[2], object.dailyGoalMinutes);
  writer.writeLongList(offsets[3], object.diagnosticCorrect);
  writer.writeStringList(offsets[4], object.diagnosticSectionIds);
  writer.writeString(offsets[5], object.diagnosticStatusName);
  writer.writeLongList(offsets[6], object.diagnosticTotals);
  writer.writeLong(offsets[7], object.earnedXp);
  writer.writeString(offsets[8], object.examTimeframeKey);
  writer.writeBool(offsets[9], object.isCompleted);
  writer.writeString(offsets[10], object.name);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

OnboardingProgressRecord _onboardingProgressRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OnboardingProgressRecord();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.currentStepName = reader.readString(offsets[1]);
  object.dailyGoalMinutes = reader.readLongOrNull(offsets[2]);
  object.diagnosticCorrect = reader.readLongList(offsets[3]) ?? [];
  object.diagnosticSectionIds = reader.readStringList(offsets[4]) ?? [];
  object.diagnosticStatusName = reader.readString(offsets[5]);
  object.diagnosticTotals = reader.readLongList(offsets[6]) ?? [];
  object.earnedXp = reader.readLong(offsets[7]);
  object.examTimeframeKey = reader.readStringOrNull(offsets[8]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[9]);
  object.name = reader.readString(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  return object;
}

P _onboardingProgressRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? []) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongList(offset) ?? []) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _onboardingProgressRecordGetId(OnboardingProgressRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _onboardingProgressRecordGetLinks(
  OnboardingProgressRecord object,
) {
  return [];
}

void _onboardingProgressRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  OnboardingProgressRecord object,
) {
  object.id = id;
}

extension OnboardingProgressRecordQueryWhereSort
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QWhere
        > {
  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OnboardingProgressRecordQueryWhere
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QWhereClause
        > {
  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterWhereClause
  >
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension OnboardingProgressRecordQueryFilter
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QFilterCondition
        > {
  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  completedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  completedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentStepName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentStepName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentStepName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentStepName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'currentStepName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'currentStepName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'currentStepName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'currentStepName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentStepName', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  currentStepNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currentStepName', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dailyGoalMinutes'),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dailyGoalMinutes'),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailyGoalMinutes', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dailyGoalMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dailyGoalMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dailyGoalMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'diagnosticCorrect', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'diagnosticCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'diagnosticCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'diagnosticCorrect',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', length, true, length, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', 0, true, 0, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', 0, true, length, include);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticCorrect',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticCorrect',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'diagnosticSectionIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'diagnosticSectionIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'diagnosticSectionIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'diagnosticSectionIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'diagnosticSectionIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'diagnosticSectionIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'diagnosticSectionIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'diagnosticSectionIds',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'diagnosticSectionIds', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'diagnosticSectionIds',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticSectionIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticSectionIds', 0, true, 0, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticSectionIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticSectionIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticSectionIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticSectionIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'diagnosticStatusName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'diagnosticStatusName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'diagnosticStatusName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'diagnosticStatusName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'diagnosticStatusName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'diagnosticStatusName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'diagnosticStatusName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'diagnosticStatusName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'diagnosticStatusName', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticStatusNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'diagnosticStatusName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'diagnosticTotals', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'diagnosticTotals',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'diagnosticTotals',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'diagnosticTotals',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', length, true, length, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', 0, true, 0, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', 0, true, length, include);
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticTotals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diagnosticTotals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  earnedXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'earnedXp', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  earnedXpGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'earnedXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  earnedXpLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'earnedXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  earnedXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'earnedXp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'examTimeframeKey'),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'examTimeframeKey'),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'examTimeframeKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'examTimeframeKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'examTimeframeKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'examTimeframeKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'examTimeframeKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'examTimeframeKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'examTimeframeKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'examTimeframeKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'examTimeframeKey', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'examTimeframeKey', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCompleted', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    OnboardingProgressRecord,
    OnboardingProgressRecord,
    QAfterFilterCondition
  >
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension OnboardingProgressRecordQueryObject
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QFilterCondition
        > {}

extension OnboardingProgressRecordQueryLinks
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QFilterCondition
        > {}

extension OnboardingProgressRecordQuerySortBy
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QSortBy
        > {
  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByCurrentStepName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepName', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByCurrentStepNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepName', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByDailyGoalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByDiagnosticStatusName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosticStatusName', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByDiagnosticStatusNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosticStatusName', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByEarnedXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'earnedXp', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByEarnedXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'earnedXp', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByExamTimeframeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByExamTimeframeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OnboardingProgressRecordQuerySortThenBy
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QSortThenBy
        > {
  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByCurrentStepName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepName', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByCurrentStepNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStepName', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByDailyGoalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByDiagnosticStatusName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosticStatusName', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByDiagnosticStatusNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosticStatusName', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByEarnedXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'earnedXp', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByEarnedXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'earnedXp', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByExamTimeframeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByExamTimeframeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OnboardingProgressRecordQueryWhereDistinct
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QDistinct
        > {
  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByCurrentStepName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'currentStepName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyGoalMinutes');
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByDiagnosticCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnosticCorrect');
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByDiagnosticSectionIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnosticSectionIds');
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByDiagnosticStatusName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'diagnosticStatusName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByDiagnosticTotals() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnosticTotals');
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByEarnedXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'earnedXp');
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByExamTimeframeKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'examTimeframeKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OnboardingProgressRecord, OnboardingProgressRecord, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension OnboardingProgressRecordQueryProperty
    on
        QueryBuilder<
          OnboardingProgressRecord,
          OnboardingProgressRecord,
          QQueryProperty
        > {
  QueryBuilder<OnboardingProgressRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OnboardingProgressRecord, DateTime?, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<OnboardingProgressRecord, String, QQueryOperations>
  currentStepNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStepName');
    });
  }

  QueryBuilder<OnboardingProgressRecord, int?, QQueryOperations>
  dailyGoalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyGoalMinutes');
    });
  }

  QueryBuilder<OnboardingProgressRecord, List<int>, QQueryOperations>
  diagnosticCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosticCorrect');
    });
  }

  QueryBuilder<OnboardingProgressRecord, List<String>, QQueryOperations>
  diagnosticSectionIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosticSectionIds');
    });
  }

  QueryBuilder<OnboardingProgressRecord, String, QQueryOperations>
  diagnosticStatusNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosticStatusName');
    });
  }

  QueryBuilder<OnboardingProgressRecord, List<int>, QQueryOperations>
  diagnosticTotalsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosticTotals');
    });
  }

  QueryBuilder<OnboardingProgressRecord, int, QQueryOperations>
  earnedXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'earnedXp');
    });
  }

  QueryBuilder<OnboardingProgressRecord, String?, QQueryOperations>
  examTimeframeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'examTimeframeKey');
    });
  }

  QueryBuilder<OnboardingProgressRecord, bool, QQueryOperations>
  isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<OnboardingProgressRecord, String, QQueryOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<OnboardingProgressRecord, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
