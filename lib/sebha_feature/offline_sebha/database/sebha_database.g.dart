// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sebha_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Tasbeeh extends DataClass implements Insertable<Tasbeeh> {
  final int id;
  final String name;
  final String note;
  final int totalCounter;
  final int counted;
  Tasbeeh(
      {required this.id,
      required this.name,
      required this.note,
      required this.totalCounter,
      required this.counted});
  factory Tasbeeh.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Tasbeeh(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      note: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}note'])!,
      totalCounter: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_counter'])!,
      counted: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}counted'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['note'] = Variable<String>(note);
    map['total_counter'] = Variable<int>(totalCounter);
    map['counted'] = Variable<int>(counted);
    return map;
  }

  TsabeehCompanion toCompanion(bool nullToAbsent) {
    return TsabeehCompanion(
      id: Value(id),
      name: Value(name),
      note: Value(note),
      totalCounter: Value(totalCounter),
      counted: Value(counted),
    );
  }

  factory Tasbeeh.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Tasbeeh(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      note: serializer.fromJson<String>(json['note']),
      totalCounter: serializer.fromJson<int>(json['totalCounter']),
      counted: serializer.fromJson<int>(json['counted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'note': serializer.toJson<String>(note),
      'totalCounter': serializer.toJson<int>(totalCounter),
      'counted': serializer.toJson<int>(counted),
    };
  }

  Tasbeeh copyWith(
          {int? id,
          String? name,
          String? note,
          int? totalCounter,
          int? counted}) =>
      Tasbeeh(
        id: id ?? this.id,
        name: name ?? this.name,
        note: note ?? this.note,
        totalCounter: totalCounter ?? this.totalCounter,
        counted: counted ?? this.counted,
      );
  @override
  String toString() {
    return (StringBuffer('Tasbeeh(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('totalCounter: $totalCounter, ')
          ..write('counted: $counted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, note, totalCounter, counted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tasbeeh &&
          other.id == this.id &&
          other.name == this.name &&
          other.note == this.note &&
          other.totalCounter == this.totalCounter &&
          other.counted == this.counted);
}

class TsabeehCompanion extends UpdateCompanion<Tasbeeh> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> note;
  final Value<int> totalCounter;
  final Value<int> counted;
  const TsabeehCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.totalCounter = const Value.absent(),
    this.counted = const Value.absent(),
  });
  TsabeehCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String note,
    required int totalCounter,
    required int counted,
  })  : name = Value(name),
        note = Value(note),
        totalCounter = Value(totalCounter),
        counted = Value(counted);
  static Insertable<Tasbeeh> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? note,
    Expression<int>? totalCounter,
    Expression<int>? counted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
      if (totalCounter != null) 'total_counter': totalCounter,
      if (counted != null) 'counted': counted,
    });
  }

  TsabeehCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? note,
      Value<int>? totalCounter,
      Value<int>? counted}) {
    return TsabeehCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      totalCounter: totalCounter ?? this.totalCounter,
      counted: counted ?? this.counted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (totalCounter.present) {
      map['total_counter'] = Variable<int>(totalCounter.value);
    }
    if (counted.present) {
      map['counted'] = Variable<int>(counted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TsabeehCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('totalCounter: $totalCounter, ')
          ..write('counted: $counted')
          ..write(')'))
        .toString();
  }
}

class $TsabeehTable extends Tsabeeh with TableInfo<$TsabeehTable, Tasbeeh> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TsabeehTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String?> note = GeneratedColumn<String?>(
      'note', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _totalCounterMeta =
      const VerificationMeta('totalCounter');
  @override
  late final GeneratedColumn<int?> totalCounter = GeneratedColumn<int?>(
      'total_counter', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _countedMeta = const VerificationMeta('counted');
  @override
  late final GeneratedColumn<int?> counted = GeneratedColumn<int?>(
      'counted', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, note, totalCounter, counted];
  @override
  String get aliasedName => _alias ?? 'tsabeeh';
  @override
  String get actualTableName => 'tsabeeh';
  @override
  VerificationContext validateIntegrity(Insertable<Tasbeeh> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('total_counter')) {
      context.handle(
          _totalCounterMeta,
          totalCounter.isAcceptableOrUnknown(
              data['total_counter']!, _totalCounterMeta));
    } else if (isInserting) {
      context.missing(_totalCounterMeta);
    }
    if (data.containsKey('counted')) {
      context.handle(_countedMeta,
          counted.isAcceptableOrUnknown(data['counted']!, _countedMeta));
    } else if (isInserting) {
      context.missing(_countedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tasbeeh map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Tasbeeh.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TsabeehTable createAlias(String alias) {
    return $TsabeehTable(attachedDatabase, alias);
  }
}

abstract class _$SebhaDataBase extends GeneratedDatabase {
  _$SebhaDataBase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TsabeehTable tsabeeh = $TsabeehTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tsabeeh];
}
