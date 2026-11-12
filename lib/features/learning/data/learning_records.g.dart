// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_records.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetLessonAttemptRecordCollection on Isar {
  IsarCollection<LessonAttemptRecord> get lessonAttemptRecords =>
      this.collection();
}

const LessonAttemptRecordSchema = CollectionSchema(
  name: r'LessonAttemptRecord',
  id: -8648718733404671266,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'courseId': PropertySchema(
      id: 1,
      name: r'courseId',
      type: IsarType.string,
    ),
    r'durationSeconds': PropertySchema(
      id: 2,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'estimatedMinutes': PropertySchema(
      id: 3,
      name: r'estimatedMinutes',
      type: IsarType.long,
    ),
    r'firstTryCorrect': PropertySchema(
      id: 4,
      name: r'firstTryCorrect',
      type: IsarType.long,
    ),
    r'lessonId': PropertySchema(
      id: 5,
      name: r'lessonId',
      type: IsarType.string,
    ),
    r'questionCount': PropertySchema(
      id: 6,
      name: r'questionCount',
      type: IsarType.long,
    ),
    r'xpEarned': PropertySchema(id: 7, name: r'xpEarned', type: IsarType.long),
  },

  estimateSize: _lessonAttemptRecordEstimateSize,
  serialize: _lessonAttemptRecordSerialize,
  deserialize: _lessonAttemptRecordDeserialize,
  deserializeProp: _lessonAttemptRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _lessonAttemptRecordGetId,
  getLinks: _lessonAttemptRecordGetLinks,
  attach: _lessonAttemptRecordAttach,
  version: '3.4.1',
);

int _lessonAttemptRecordEstimateSize(
  LessonAttemptRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courseId.length * 3;
  bytesCount += 3 + object.lessonId.length * 3;
  return bytesCount;
}

void _lessonAttemptRecordSerialize(
  LessonAttemptRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeString(offsets[1], object.courseId);
  writer.writeLong(offsets[2], object.durationSeconds);
  writer.writeLong(offsets[3], object.estimatedMinutes);
  writer.writeLong(offsets[4], object.firstTryCorrect);
  writer.writeString(offsets[5], object.lessonId);
  writer.writeLong(offsets[6], object.questionCount);
  writer.writeLong(offsets[7], object.xpEarned);
}

LessonAttemptRecord _lessonAttemptRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LessonAttemptRecord();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.courseId = reader.readString(offsets[1]);
  object.durationSeconds = reader.readLong(offsets[2]);
  object.estimatedMinutes = reader.readLong(offsets[3]);
  object.firstTryCorrect = reader.readLong(offsets[4]);
  object.id = id;
  object.lessonId = reader.readString(offsets[5]);
  object.questionCount = reader.readLong(offsets[6]);
  object.xpEarned = reader.readLong(offsets[7]);
  return object;
}

P _lessonAttemptRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lessonAttemptRecordGetId(LessonAttemptRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lessonAttemptRecordGetLinks(
  LessonAttemptRecord object,
) {
  return [];
}

void _lessonAttemptRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  LessonAttemptRecord object,
) {
  object.id = id;
}

extension LessonAttemptRecordQueryWhereSort
    on QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QWhere> {
  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LessonAttemptRecordQueryWhere
    on QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QWhereClause> {
  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterWhereClause>
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

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterWhereClause>
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

extension LessonAttemptRecordQueryFilter
    on
        QueryBuilder<
          LessonAttemptRecord,
          LessonAttemptRecord,
          QFilterCondition
        > {
  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  completedAtGreaterThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  completedAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  completedAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'courseId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'courseId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'courseId', value: ''),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  courseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'courseId', value: ''),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationSeconds', value: value),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  durationSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  durationSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  estimatedMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'estimatedMinutes', value: value),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  estimatedMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'estimatedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  estimatedMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'estimatedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  estimatedMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'estimatedMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  firstTryCorrectEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'firstTryCorrect', value: value),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  firstTryCorrectGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'firstTryCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  firstTryCorrectLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'firstTryCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  firstTryCorrectBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'firstTryCorrect',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
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

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
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

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
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

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lessonId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lessonId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lessonId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lessonId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lessonId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lessonId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lessonId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lessonId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lessonId', value: ''),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  lessonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lessonId', value: ''),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  questionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'questionCount', value: value),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  questionCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'questionCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  questionCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'questionCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  questionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'questionCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  xpEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'xpEarned', value: value),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  xpEarnedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'xpEarned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  xpEarnedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'xpEarned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterFilterCondition>
  xpEarnedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'xpEarned',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LessonAttemptRecordQueryObject
    on
        QueryBuilder<
          LessonAttemptRecord,
          LessonAttemptRecord,
          QFilterCondition
        > {}

extension LessonAttemptRecordQueryLinks
    on
        QueryBuilder<
          LessonAttemptRecord,
          LessonAttemptRecord,
          QFilterCondition
        > {}

extension LessonAttemptRecordQuerySortBy
    on QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QSortBy> {
  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByEstimatedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByEstimatedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByFirstTryCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTryCorrect', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByFirstTryCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTryCorrect', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByLessonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByLessonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByQuestionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionCount', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByQuestionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionCount', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  sortByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension LessonAttemptRecordQuerySortThenBy
    on QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QSortThenBy> {
  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByEstimatedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByEstimatedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByFirstTryCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTryCorrect', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByFirstTryCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTryCorrect', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByLessonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByLessonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByQuestionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionCount', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByQuestionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionCount', Sort.desc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QAfterSortBy>
  thenByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension LessonAttemptRecordQueryWhereDistinct
    on QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct> {
  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByCourseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByEstimatedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedMinutes');
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByFirstTryCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstTryCorrect');
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByLessonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lessonId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByQuestionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'questionCount');
    });
  }

  QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QDistinct>
  distinctByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xpEarned');
    });
  }
}

extension LessonAttemptRecordQueryProperty
    on QueryBuilder<LessonAttemptRecord, LessonAttemptRecord, QQueryProperty> {
  QueryBuilder<LessonAttemptRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LessonAttemptRecord, DateTime, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<LessonAttemptRecord, String, QQueryOperations>
  courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<LessonAttemptRecord, int, QQueryOperations>
  durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<LessonAttemptRecord, int, QQueryOperations>
  estimatedMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedMinutes');
    });
  }

  QueryBuilder<LessonAttemptRecord, int, QQueryOperations>
  firstTryCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstTryCorrect');
    });
  }

  QueryBuilder<LessonAttemptRecord, String, QQueryOperations>
  lessonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lessonId');
    });
  }

  QueryBuilder<LessonAttemptRecord, int, QQueryOperations>
  questionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'questionCount');
    });
  }

  QueryBuilder<LessonAttemptRecord, int, QQueryOperations> xpEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xpEarned');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetAnswerRecordCollection on Isar {
  IsarCollection<AnswerRecord> get answerRecords => this.collection();
}

const AnswerRecordSchema = CollectionSchema(
  name: r'AnswerRecord',
  id: -783120389370632988,
  properties: {
    r'answeredAt': PropertySchema(
      id: 0,
      name: r'answeredAt',
      type: IsarType.dateTime,
    ),
    r'isCorrect': PropertySchema(
      id: 1,
      name: r'isCorrect',
      type: IsarType.bool,
    ),
    r'questionId': PropertySchema(
      id: 2,
      name: r'questionId',
      type: IsarType.string,
    ),
    r'sourceName': PropertySchema(
      id: 3,
      name: r'sourceName',
      type: IsarType.string,
    ),
  },

  estimateSize: _answerRecordEstimateSize,
  serialize: _answerRecordSerialize,
  deserialize: _answerRecordDeserialize,
  deserializeProp: _answerRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _answerRecordGetId,
  getLinks: _answerRecordGetLinks,
  attach: _answerRecordAttach,
  version: '3.4.1',
);

int _answerRecordEstimateSize(
  AnswerRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.questionId.length * 3;
  bytesCount += 3 + object.sourceName.length * 3;
  return bytesCount;
}

void _answerRecordSerialize(
  AnswerRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.answeredAt);
  writer.writeBool(offsets[1], object.isCorrect);
  writer.writeString(offsets[2], object.questionId);
  writer.writeString(offsets[3], object.sourceName);
}

AnswerRecord _answerRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AnswerRecord();
  object.answeredAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isCorrect = reader.readBool(offsets[1]);
  object.questionId = reader.readString(offsets[2]);
  object.sourceName = reader.readString(offsets[3]);
  return object;
}

P _answerRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _answerRecordGetId(AnswerRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _answerRecordGetLinks(AnswerRecord object) {
  return [];
}

void _answerRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  AnswerRecord object,
) {
  object.id = id;
}

extension AnswerRecordQueryWhereSort
    on QueryBuilder<AnswerRecord, AnswerRecord, QWhere> {
  QueryBuilder<AnswerRecord, AnswerRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AnswerRecordQueryWhere
    on QueryBuilder<AnswerRecord, AnswerRecord, QWhereClause> {
  QueryBuilder<AnswerRecord, AnswerRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterWhereClause> idBetween(
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

extension AnswerRecordQueryFilter
    on QueryBuilder<AnswerRecord, AnswerRecord, QFilterCondition> {
  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  answeredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'answeredAt', value: value),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  answeredAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'answeredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  answeredAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'answeredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  answeredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'answeredAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  isCorrectEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCorrect', value: value),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'questionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'questionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'questionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'questionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'questionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'questionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'questionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'questionId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'questionId', value: ''),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  questionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'questionId', value: ''),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceName', value: ''),
      );
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterFilterCondition>
  sourceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceName', value: ''),
      );
    });
  }
}

extension AnswerRecordQueryObject
    on QueryBuilder<AnswerRecord, AnswerRecord, QFilterCondition> {}

extension AnswerRecordQueryLinks
    on QueryBuilder<AnswerRecord, AnswerRecord, QFilterCondition> {}

extension AnswerRecordQuerySortBy
    on QueryBuilder<AnswerRecord, AnswerRecord, QSortBy> {
  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> sortByAnsweredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answeredAt', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy>
  sortByAnsweredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answeredAt', Sort.desc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> sortByIsCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCorrect', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> sortByIsCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCorrect', Sort.desc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> sortByQuestionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionId', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy>
  sortByQuestionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionId', Sort.desc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> sortBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy>
  sortBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }
}

extension AnswerRecordQuerySortThenBy
    on QueryBuilder<AnswerRecord, AnswerRecord, QSortThenBy> {
  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> thenByAnsweredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answeredAt', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy>
  thenByAnsweredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answeredAt', Sort.desc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> thenByIsCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCorrect', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> thenByIsCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCorrect', Sort.desc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> thenByQuestionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionId', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy>
  thenByQuestionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'questionId', Sort.desc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy> thenBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QAfterSortBy>
  thenBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }
}

extension AnswerRecordQueryWhereDistinct
    on QueryBuilder<AnswerRecord, AnswerRecord, QDistinct> {
  QueryBuilder<AnswerRecord, AnswerRecord, QDistinct> distinctByAnsweredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'answeredAt');
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QDistinct> distinctByIsCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCorrect');
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QDistinct> distinctByQuestionId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'questionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AnswerRecord, AnswerRecord, QDistinct> distinctBySourceName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceName', caseSensitive: caseSensitive);
    });
  }
}

extension AnswerRecordQueryProperty
    on QueryBuilder<AnswerRecord, AnswerRecord, QQueryProperty> {
  QueryBuilder<AnswerRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AnswerRecord, DateTime, QQueryOperations> answeredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'answeredAt');
    });
  }

  QueryBuilder<AnswerRecord, bool, QQueryOperations> isCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCorrect');
    });
  }

  QueryBuilder<AnswerRecord, String, QQueryOperations> questionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'questionId');
    });
  }

  QueryBuilder<AnswerRecord, String, QQueryOperations> sourceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetCheckpointResultRecordCollection on Isar {
  IsarCollection<CheckpointResultRecord> get checkpointResultRecords =>
      this.collection();
}

const CheckpointResultRecordSchema = CollectionSchema(
  name: r'CheckpointResultRecord',
  id: 1134042949554851312,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'correct': PropertySchema(id: 1, name: r'correct', type: IsarType.long),
    r'passed': PropertySchema(id: 2, name: r'passed', type: IsarType.bool),
    r'topicId': PropertySchema(id: 3, name: r'topicId', type: IsarType.string),
    r'total': PropertySchema(id: 4, name: r'total', type: IsarType.long),
    r'xpEarned': PropertySchema(id: 5, name: r'xpEarned', type: IsarType.long),
  },

  estimateSize: _checkpointResultRecordEstimateSize,
  serialize: _checkpointResultRecordSerialize,
  deserialize: _checkpointResultRecordDeserialize,
  deserializeProp: _checkpointResultRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _checkpointResultRecordGetId,
  getLinks: _checkpointResultRecordGetLinks,
  attach: _checkpointResultRecordAttach,
  version: '3.4.1',
);

int _checkpointResultRecordEstimateSize(
  CheckpointResultRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.topicId.length * 3;
  return bytesCount;
}

void _checkpointResultRecordSerialize(
  CheckpointResultRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeLong(offsets[1], object.correct);
  writer.writeBool(offsets[2], object.passed);
  writer.writeString(offsets[3], object.topicId);
  writer.writeLong(offsets[4], object.total);
  writer.writeLong(offsets[5], object.xpEarned);
}

CheckpointResultRecord _checkpointResultRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CheckpointResultRecord();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.correct = reader.readLong(offsets[1]);
  object.id = id;
  object.passed = reader.readBool(offsets[2]);
  object.topicId = reader.readString(offsets[3]);
  object.total = reader.readLong(offsets[4]);
  object.xpEarned = reader.readLong(offsets[5]);
  return object;
}

P _checkpointResultRecordDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _checkpointResultRecordGetId(CheckpointResultRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _checkpointResultRecordGetLinks(
  CheckpointResultRecord object,
) {
  return [];
}

void _checkpointResultRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  CheckpointResultRecord object,
) {
  object.id = id;
}

extension CheckpointResultRecordQueryWhereSort
    on QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QWhere> {
  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CheckpointResultRecordQueryWhere
    on
        QueryBuilder<
          CheckpointResultRecord,
          CheckpointResultRecord,
          QWhereClause
        > {
  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
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
    CheckpointResultRecord,
    CheckpointResultRecord,
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
    CheckpointResultRecord,
    CheckpointResultRecord,
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
    CheckpointResultRecord,
    CheckpointResultRecord,
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

extension CheckpointResultRecordQueryFilter
    on
        QueryBuilder<
          CheckpointResultRecord,
          CheckpointResultRecord,
          QFilterCondition
        > {
  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  completedAtGreaterThan(DateTime value, {bool include = false}) {
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
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  completedAtLessThan(DateTime value, {bool include = false}) {
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
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  completedAtBetween(
    DateTime lower,
    DateTime upper, {
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
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  correctEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'correct', value: value),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  correctGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'correct',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  correctLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'correct',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  correctBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'correct',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
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
    CheckpointResultRecord,
    CheckpointResultRecord,
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
    CheckpointResultRecord,
    CheckpointResultRecord,
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
    CheckpointResultRecord,
    CheckpointResultRecord,
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
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  passedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passed', value: value),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'topicId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'topicId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'topicId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'topicId',
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
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'topicId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'topicId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'topicId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'topicId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'topicId', value: ''),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  topicIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'topicId', value: ''),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  totalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'total', value: value),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  totalGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'total',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  totalLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'total',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  totalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'total',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  xpEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'xpEarned', value: value),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  xpEarnedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'xpEarned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  xpEarnedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'xpEarned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CheckpointResultRecord,
    CheckpointResultRecord,
    QAfterFilterCondition
  >
  xpEarnedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'xpEarned',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CheckpointResultRecordQueryObject
    on
        QueryBuilder<
          CheckpointResultRecord,
          CheckpointResultRecord,
          QFilterCondition
        > {}

extension CheckpointResultRecordQueryLinks
    on
        QueryBuilder<
          CheckpointResultRecord,
          CheckpointResultRecord,
          QFilterCondition
        > {}

extension CheckpointResultRecordQuerySortBy
    on QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QSortBy> {
  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByPassed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passed', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByPassedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passed', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByTopicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByTopicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  sortByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension CheckpointResultRecordQuerySortThenBy
    on
        QueryBuilder<
          CheckpointResultRecord,
          CheckpointResultRecord,
          QSortThenBy
        > {
  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByPassed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passed', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByPassedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passed', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByTopicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByTopicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.asc);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QAfterSortBy>
  thenByXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpEarned', Sort.desc);
    });
  }
}

extension CheckpointResultRecordQueryWhereDistinct
    on QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QDistinct> {
  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QDistinct>
  distinctByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correct');
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QDistinct>
  distinctByPassed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passed');
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QDistinct>
  distinctByTopicId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topicId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QDistinct>
  distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }

  QueryBuilder<CheckpointResultRecord, CheckpointResultRecord, QDistinct>
  distinctByXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xpEarned');
    });
  }
}

extension CheckpointResultRecordQueryProperty
    on
        QueryBuilder<
          CheckpointResultRecord,
          CheckpointResultRecord,
          QQueryProperty
        > {
  QueryBuilder<CheckpointResultRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CheckpointResultRecord, DateTime, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<CheckpointResultRecord, int, QQueryOperations>
  correctProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correct');
    });
  }

  QueryBuilder<CheckpointResultRecord, bool, QQueryOperations>
  passedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passed');
    });
  }

  QueryBuilder<CheckpointResultRecord, String, QQueryOperations>
  topicIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topicId');
    });
  }

  QueryBuilder<CheckpointResultRecord, int, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }

  QueryBuilder<CheckpointResultRecord, int, QQueryOperations>
  xpEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xpEarned');
    });
  }
}
