// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learner_profile_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetLearnerProfileRecordCollection on Isar {
  IsarCollection<LearnerProfileRecord> get learnerProfileRecords =>
      this.collection();
}

const LearnerProfileRecordSchema = CollectionSchema(
  name: r'LearnerProfileRecord',
  id: 9048543666987089962,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dailyGoalMinutes': PropertySchema(
      id: 1,
      name: r'dailyGoalMinutes',
      type: IsarType.long,
    ),
    r'diagnosticCorrect': PropertySchema(
      id: 2,
      name: r'diagnosticCorrect',
      type: IsarType.longList,
    ),
    r'diagnosticSectionIds': PropertySchema(
      id: 3,
      name: r'diagnosticSectionIds',
      type: IsarType.stringList,
    ),
    r'diagnosticTotals': PropertySchema(
      id: 4,
      name: r'diagnosticTotals',
      type: IsarType.longList,
    ),
    r'examTimeframeKey': PropertySchema(
      id: 5,
      name: r'examTimeframeKey',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
    r'onboardingXp': PropertySchema(
      id: 7,
      name: r'onboardingXp',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _learnerProfileRecordEstimateSize,
  serialize: _learnerProfileRecordSerialize,
  deserialize: _learnerProfileRecordDeserialize,
  deserializeProp: _learnerProfileRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _learnerProfileRecordGetId,
  getLinks: _learnerProfileRecordGetLinks,
  attach: _learnerProfileRecordAttach,
  version: '3.4.1',
);

int _learnerProfileRecordEstimateSize(
  LearnerProfileRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.diagnosticCorrect.length * 8;
  bytesCount += 3 + object.diagnosticSectionIds.length * 3;
  {
    for (var i = 0; i < object.diagnosticSectionIds.length; i++) {
      final value = object.diagnosticSectionIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.diagnosticTotals.length * 8;
  bytesCount += 3 + object.examTimeframeKey.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _learnerProfileRecordSerialize(
  LearnerProfileRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.dailyGoalMinutes);
  writer.writeLongList(offsets[2], object.diagnosticCorrect);
  writer.writeStringList(offsets[3], object.diagnosticSectionIds);
  writer.writeLongList(offsets[4], object.diagnosticTotals);
  writer.writeString(offsets[5], object.examTimeframeKey);
  writer.writeString(offsets[6], object.name);
  writer.writeLong(offsets[7], object.onboardingXp);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

LearnerProfileRecord _learnerProfileRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LearnerProfileRecord();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.dailyGoalMinutes = reader.readLong(offsets[1]);
  object.diagnosticCorrect = reader.readLongList(offsets[2]) ?? [];
  object.diagnosticSectionIds = reader.readStringList(offsets[3]) ?? [];
  object.diagnosticTotals = reader.readLongList(offsets[4]) ?? [];
  object.examTimeframeKey = reader.readString(offsets[5]);
  object.id = id;
  object.name = reader.readString(offsets[6]);
  object.onboardingXp = reader.readLong(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _learnerProfileRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readLongList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _learnerProfileRecordGetId(LearnerProfileRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _learnerProfileRecordGetLinks(
  LearnerProfileRecord object,
) {
  return [];
}

void _learnerProfileRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  LearnerProfileRecord object,
) {
  object.id = id;
}

extension LearnerProfileRecordQueryWhereSort
    on QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QWhere> {
  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LearnerProfileRecordQueryWhere
    on QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QWhereClause> {
  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterWhereClause>
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

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterWhereClause>
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

extension LearnerProfileRecordQueryFilter
    on
        QueryBuilder<
          LearnerProfileRecord,
          LearnerProfileRecord,
          QFilterCondition
        > {
  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailyGoalMinutes', value: value),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesGreaterThan(int value, {bool include = false}) {
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesLessThan(int value, {bool include = false}) {
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  dailyGoalMinutesBetween(
    int lower,
    int upper, {
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', length, true, length, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', 0, true, 0, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticCorrectLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticCorrect', 0, true, length, include);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticSectionIds', 0, true, 0, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticSectionIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticSectionIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', length, true, length, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', 0, true, 0, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  diagnosticTotalsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'diagnosticTotals', 0, true, length, include);
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyEqualTo(String value, {bool caseSensitive = true}) {
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyGreaterThan(
    String value, {
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyLessThan(
    String value, {
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  examTimeframeKeyBetween(
    String lower,
    String upper, {
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  onboardingXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'onboardingXp', value: value),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  onboardingXpGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'onboardingXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  onboardingXpLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'onboardingXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
    QAfterFilterCondition
  >
  onboardingXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'onboardingXp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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
    LearnerProfileRecord,
    LearnerProfileRecord,
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

extension LearnerProfileRecordQueryObject
    on
        QueryBuilder<
          LearnerProfileRecord,
          LearnerProfileRecord,
          QFilterCondition
        > {}

extension LearnerProfileRecordQueryLinks
    on
        QueryBuilder<
          LearnerProfileRecord,
          LearnerProfileRecord,
          QFilterCondition
        > {}

extension LearnerProfileRecordQuerySortBy
    on QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QSortBy> {
  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByDailyGoalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByExamTimeframeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByExamTimeframeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByOnboardingXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingXp', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByOnboardingXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingXp', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LearnerProfileRecordQuerySortThenBy
    on QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QSortThenBy> {
  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByDailyGoalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyGoalMinutes', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByExamTimeframeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByExamTimeframeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'examTimeframeKey', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByOnboardingXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingXp', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByOnboardingXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingXp', Sort.desc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LearnerProfileRecordQueryWhereDistinct
    on QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct> {
  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByDailyGoalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyGoalMinutes');
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByDiagnosticCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnosticCorrect');
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByDiagnosticSectionIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnosticSectionIds');
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByDiagnosticTotals() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnosticTotals');
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByExamTimeframeKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'examTimeframeKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByOnboardingXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingXp');
    });
  }

  QueryBuilder<LearnerProfileRecord, LearnerProfileRecord, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LearnerProfileRecordQueryProperty
    on
        QueryBuilder<
          LearnerProfileRecord,
          LearnerProfileRecord,
          QQueryProperty
        > {
  QueryBuilder<LearnerProfileRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LearnerProfileRecord, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LearnerProfileRecord, int, QQueryOperations>
  dailyGoalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyGoalMinutes');
    });
  }

  QueryBuilder<LearnerProfileRecord, List<int>, QQueryOperations>
  diagnosticCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosticCorrect');
    });
  }

  QueryBuilder<LearnerProfileRecord, List<String>, QQueryOperations>
  diagnosticSectionIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosticSectionIds');
    });
  }

  QueryBuilder<LearnerProfileRecord, List<int>, QQueryOperations>
  diagnosticTotalsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosticTotals');
    });
  }

  QueryBuilder<LearnerProfileRecord, String, QQueryOperations>
  examTimeframeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'examTimeframeKey');
    });
  }

  QueryBuilder<LearnerProfileRecord, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LearnerProfileRecord, int, QQueryOperations>
  onboardingXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingXp');
    });
  }

  QueryBuilder<LearnerProfileRecord, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
