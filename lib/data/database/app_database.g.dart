// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startTsMeta =
      const VerificationMeta('startTs');
  @override
  late final GeneratedColumn<int> startTs = GeneratedColumn<int>(
      'start_ts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTsMeta = const VerificationMeta('endTs');
  @override
  late final GeneratedColumn<int> endTs = GeneratedColumn<int>(
      'end_ts', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _startPctMeta =
      const VerificationMeta('startPct');
  @override
  late final GeneratedColumn<int> startPct = GeneratedColumn<int>(
      'start_pct', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endPctMeta = const VerificationMeta('endPct');
  @override
  late final GeneratedColumn<int> endPct = GeneratedColumn<int>(
      'end_pct', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _avgWMeta = const VerificationMeta('avgW');
  @override
  late final GeneratedColumn<double> avgW = GeneratedColumn<double>(
      'avg_w', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _peakWMeta = const VerificationMeta('peakW');
  @override
  late final GeneratedColumn<double> peakW = GeneratedColumn<double>(
      'peak_w', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _avgMaMeta = const VerificationMeta('avgMa');
  @override
  late final GeneratedColumn<double> avgMa = GeneratedColumn<double>(
      'avg_ma', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _maxTempMeta =
      const VerificationMeta('maxTemp');
  @override
  late final GeneratedColumn<double> maxTemp = GeneratedColumn<double>(
      'max_temp', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _chargerIdMeta =
      const VerificationMeta('chargerId');
  @override
  late final GeneratedColumn<int> chargerId = GeneratedColumn<int>(
      'charger_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _chargerTypeMeta =
      const VerificationMeta('chargerType');
  @override
  late final GeneratedColumn<String> chargerType = GeneratedColumn<String>(
      'charger_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startTs,
        endTs,
        startPct,
        endPct,
        avgW,
        peakW,
        avgMa,
        maxTemp,
        chargerId,
        chargerType
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_ts')) {
      context.handle(_startTsMeta,
          startTs.isAcceptableOrUnknown(data['start_ts']!, _startTsMeta));
    } else if (isInserting) {
      context.missing(_startTsMeta);
    }
    if (data.containsKey('end_ts')) {
      context.handle(
          _endTsMeta, endTs.isAcceptableOrUnknown(data['end_ts']!, _endTsMeta));
    }
    if (data.containsKey('start_pct')) {
      context.handle(_startPctMeta,
          startPct.isAcceptableOrUnknown(data['start_pct']!, _startPctMeta));
    } else if (isInserting) {
      context.missing(_startPctMeta);
    }
    if (data.containsKey('end_pct')) {
      context.handle(_endPctMeta,
          endPct.isAcceptableOrUnknown(data['end_pct']!, _endPctMeta));
    }
    if (data.containsKey('avg_w')) {
      context.handle(
          _avgWMeta, avgW.isAcceptableOrUnknown(data['avg_w']!, _avgWMeta));
    }
    if (data.containsKey('peak_w')) {
      context.handle(
          _peakWMeta, peakW.isAcceptableOrUnknown(data['peak_w']!, _peakWMeta));
    }
    if (data.containsKey('avg_ma')) {
      context.handle(
          _avgMaMeta, avgMa.isAcceptableOrUnknown(data['avg_ma']!, _avgMaMeta));
    }
    if (data.containsKey('max_temp')) {
      context.handle(_maxTempMeta,
          maxTemp.isAcceptableOrUnknown(data['max_temp']!, _maxTempMeta));
    }
    if (data.containsKey('charger_id')) {
      context.handle(_chargerIdMeta,
          chargerId.isAcceptableOrUnknown(data['charger_id']!, _chargerIdMeta));
    }
    if (data.containsKey('charger_type')) {
      context.handle(
          _chargerTypeMeta,
          chargerType.isAcceptableOrUnknown(
              data['charger_type']!, _chargerTypeMeta));
    } else if (isInserting) {
      context.missing(_chargerTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startTs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ts'])!,
      endTs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_ts']),
      startPct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_pct'])!,
      endPct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_pct']),
      avgW: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_w']),
      peakW: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}peak_w']),
      avgMa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_ma']),
      maxTemp: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_temp']),
      chargerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}charger_id']),
      chargerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}charger_type'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int startTs;
  final int? endTs;
  final int startPct;
  final int? endPct;
  final double? avgW;
  final double? peakW;
  final double? avgMa;
  final double? maxTemp;
  final int? chargerId;
  final String chargerType;
  const Session(
      {required this.id,
      required this.startTs,
      this.endTs,
      required this.startPct,
      this.endPct,
      this.avgW,
      this.peakW,
      this.avgMa,
      this.maxTemp,
      this.chargerId,
      required this.chargerType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_ts'] = Variable<int>(startTs);
    if (!nullToAbsent || endTs != null) {
      map['end_ts'] = Variable<int>(endTs);
    }
    map['start_pct'] = Variable<int>(startPct);
    if (!nullToAbsent || endPct != null) {
      map['end_pct'] = Variable<int>(endPct);
    }
    if (!nullToAbsent || avgW != null) {
      map['avg_w'] = Variable<double>(avgW);
    }
    if (!nullToAbsent || peakW != null) {
      map['peak_w'] = Variable<double>(peakW);
    }
    if (!nullToAbsent || avgMa != null) {
      map['avg_ma'] = Variable<double>(avgMa);
    }
    if (!nullToAbsent || maxTemp != null) {
      map['max_temp'] = Variable<double>(maxTemp);
    }
    if (!nullToAbsent || chargerId != null) {
      map['charger_id'] = Variable<int>(chargerId);
    }
    map['charger_type'] = Variable<String>(chargerType);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      startTs: Value(startTs),
      endTs:
          endTs == null && nullToAbsent ? const Value.absent() : Value(endTs),
      startPct: Value(startPct),
      endPct:
          endPct == null && nullToAbsent ? const Value.absent() : Value(endPct),
      avgW: avgW == null && nullToAbsent ? const Value.absent() : Value(avgW),
      peakW:
          peakW == null && nullToAbsent ? const Value.absent() : Value(peakW),
      avgMa:
          avgMa == null && nullToAbsent ? const Value.absent() : Value(avgMa),
      maxTemp: maxTemp == null && nullToAbsent
          ? const Value.absent()
          : Value(maxTemp),
      chargerId: chargerId == null && nullToAbsent
          ? const Value.absent()
          : Value(chargerId),
      chargerType: Value(chargerType),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      startTs: serializer.fromJson<int>(json['startTs']),
      endTs: serializer.fromJson<int?>(json['endTs']),
      startPct: serializer.fromJson<int>(json['startPct']),
      endPct: serializer.fromJson<int?>(json['endPct']),
      avgW: serializer.fromJson<double?>(json['avgW']),
      peakW: serializer.fromJson<double?>(json['peakW']),
      avgMa: serializer.fromJson<double?>(json['avgMa']),
      maxTemp: serializer.fromJson<double?>(json['maxTemp']),
      chargerId: serializer.fromJson<int?>(json['chargerId']),
      chargerType: serializer.fromJson<String>(json['chargerType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTs': serializer.toJson<int>(startTs),
      'endTs': serializer.toJson<int?>(endTs),
      'startPct': serializer.toJson<int>(startPct),
      'endPct': serializer.toJson<int?>(endPct),
      'avgW': serializer.toJson<double?>(avgW),
      'peakW': serializer.toJson<double?>(peakW),
      'avgMa': serializer.toJson<double?>(avgMa),
      'maxTemp': serializer.toJson<double?>(maxTemp),
      'chargerId': serializer.toJson<int?>(chargerId),
      'chargerType': serializer.toJson<String>(chargerType),
    };
  }

  Session copyWith(
          {int? id,
          int? startTs,
          Value<int?> endTs = const Value.absent(),
          int? startPct,
          Value<int?> endPct = const Value.absent(),
          Value<double?> avgW = const Value.absent(),
          Value<double?> peakW = const Value.absent(),
          Value<double?> avgMa = const Value.absent(),
          Value<double?> maxTemp = const Value.absent(),
          Value<int?> chargerId = const Value.absent(),
          String? chargerType}) =>
      Session(
        id: id ?? this.id,
        startTs: startTs ?? this.startTs,
        endTs: endTs.present ? endTs.value : this.endTs,
        startPct: startPct ?? this.startPct,
        endPct: endPct.present ? endPct.value : this.endPct,
        avgW: avgW.present ? avgW.value : this.avgW,
        peakW: peakW.present ? peakW.value : this.peakW,
        avgMa: avgMa.present ? avgMa.value : this.avgMa,
        maxTemp: maxTemp.present ? maxTemp.value : this.maxTemp,
        chargerId: chargerId.present ? chargerId.value : this.chargerId,
        chargerType: chargerType ?? this.chargerType,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      startTs: data.startTs.present ? data.startTs.value : this.startTs,
      endTs: data.endTs.present ? data.endTs.value : this.endTs,
      startPct: data.startPct.present ? data.startPct.value : this.startPct,
      endPct: data.endPct.present ? data.endPct.value : this.endPct,
      avgW: data.avgW.present ? data.avgW.value : this.avgW,
      peakW: data.peakW.present ? data.peakW.value : this.peakW,
      avgMa: data.avgMa.present ? data.avgMa.value : this.avgMa,
      maxTemp: data.maxTemp.present ? data.maxTemp.value : this.maxTemp,
      chargerId: data.chargerId.present ? data.chargerId.value : this.chargerId,
      chargerType:
          data.chargerType.present ? data.chargerType.value : this.chargerType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('startTs: $startTs, ')
          ..write('endTs: $endTs, ')
          ..write('startPct: $startPct, ')
          ..write('endPct: $endPct, ')
          ..write('avgW: $avgW, ')
          ..write('peakW: $peakW, ')
          ..write('avgMa: $avgMa, ')
          ..write('maxTemp: $maxTemp, ')
          ..write('chargerId: $chargerId, ')
          ..write('chargerType: $chargerType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startTs, endTs, startPct, endPct, avgW,
      peakW, avgMa, maxTemp, chargerId, chargerType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.startTs == this.startTs &&
          other.endTs == this.endTs &&
          other.startPct == this.startPct &&
          other.endPct == this.endPct &&
          other.avgW == this.avgW &&
          other.peakW == this.peakW &&
          other.avgMa == this.avgMa &&
          other.maxTemp == this.maxTemp &&
          other.chargerId == this.chargerId &&
          other.chargerType == this.chargerType);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> startTs;
  final Value<int?> endTs;
  final Value<int> startPct;
  final Value<int?> endPct;
  final Value<double?> avgW;
  final Value<double?> peakW;
  final Value<double?> avgMa;
  final Value<double?> maxTemp;
  final Value<int?> chargerId;
  final Value<String> chargerType;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.startTs = const Value.absent(),
    this.endTs = const Value.absent(),
    this.startPct = const Value.absent(),
    this.endPct = const Value.absent(),
    this.avgW = const Value.absent(),
    this.peakW = const Value.absent(),
    this.avgMa = const Value.absent(),
    this.maxTemp = const Value.absent(),
    this.chargerId = const Value.absent(),
    this.chargerType = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int startTs,
    this.endTs = const Value.absent(),
    required int startPct,
    this.endPct = const Value.absent(),
    this.avgW = const Value.absent(),
    this.peakW = const Value.absent(),
    this.avgMa = const Value.absent(),
    this.maxTemp = const Value.absent(),
    this.chargerId = const Value.absent(),
    required String chargerType,
  })  : startTs = Value(startTs),
        startPct = Value(startPct),
        chargerType = Value(chargerType);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? startTs,
    Expression<int>? endTs,
    Expression<int>? startPct,
    Expression<int>? endPct,
    Expression<double>? avgW,
    Expression<double>? peakW,
    Expression<double>? avgMa,
    Expression<double>? maxTemp,
    Expression<int>? chargerId,
    Expression<String>? chargerType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTs != null) 'start_ts': startTs,
      if (endTs != null) 'end_ts': endTs,
      if (startPct != null) 'start_pct': startPct,
      if (endPct != null) 'end_pct': endPct,
      if (avgW != null) 'avg_w': avgW,
      if (peakW != null) 'peak_w': peakW,
      if (avgMa != null) 'avg_ma': avgMa,
      if (maxTemp != null) 'max_temp': maxTemp,
      if (chargerId != null) 'charger_id': chargerId,
      if (chargerType != null) 'charger_type': chargerType,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? startTs,
      Value<int?>? endTs,
      Value<int>? startPct,
      Value<int?>? endPct,
      Value<double?>? avgW,
      Value<double?>? peakW,
      Value<double?>? avgMa,
      Value<double?>? maxTemp,
      Value<int?>? chargerId,
      Value<String>? chargerType}) {
    return SessionsCompanion(
      id: id ?? this.id,
      startTs: startTs ?? this.startTs,
      endTs: endTs ?? this.endTs,
      startPct: startPct ?? this.startPct,
      endPct: endPct ?? this.endPct,
      avgW: avgW ?? this.avgW,
      peakW: peakW ?? this.peakW,
      avgMa: avgMa ?? this.avgMa,
      maxTemp: maxTemp ?? this.maxTemp,
      chargerId: chargerId ?? this.chargerId,
      chargerType: chargerType ?? this.chargerType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTs.present) {
      map['start_ts'] = Variable<int>(startTs.value);
    }
    if (endTs.present) {
      map['end_ts'] = Variable<int>(endTs.value);
    }
    if (startPct.present) {
      map['start_pct'] = Variable<int>(startPct.value);
    }
    if (endPct.present) {
      map['end_pct'] = Variable<int>(endPct.value);
    }
    if (avgW.present) {
      map['avg_w'] = Variable<double>(avgW.value);
    }
    if (peakW.present) {
      map['peak_w'] = Variable<double>(peakW.value);
    }
    if (avgMa.present) {
      map['avg_ma'] = Variable<double>(avgMa.value);
    }
    if (maxTemp.present) {
      map['max_temp'] = Variable<double>(maxTemp.value);
    }
    if (chargerId.present) {
      map['charger_id'] = Variable<int>(chargerId.value);
    }
    if (chargerType.present) {
      map['charger_type'] = Variable<String>(chargerType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTs: $startTs, ')
          ..write('endTs: $endTs, ')
          ..write('startPct: $startPct, ')
          ..write('endPct: $endPct, ')
          ..write('avgW: $avgW, ')
          ..write('peakW: $peakW, ')
          ..write('avgMa: $avgMa, ')
          ..write('maxTemp: $maxTemp, ')
          ..write('chargerId: $chargerId, ')
          ..write('chargerType: $chargerType')
          ..write(')'))
        .toString();
  }
}

class $SamplesTable extends Samples with TableInfo<$SamplesTable, Sample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
      'session_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<int> ts = GeneratedColumn<int>(
      'ts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maMeta = const VerificationMeta('ma');
  @override
  late final GeneratedColumn<double> ma = GeneratedColumn<double>(
      'ma', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mvMeta = const VerificationMeta('mv');
  @override
  late final GeneratedColumn<double> mv = GeneratedColumn<double>(
      'mv', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tempMeta = const VerificationMeta('temp');
  @override
  late final GeneratedColumn<double> temp = GeneratedColumn<double>(
      'temp', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pctMeta = const VerificationMeta('pct');
  @override
  late final GeneratedColumn<int> pct = GeneratedColumn<int>(
      'pct', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, ts, ma, mv, temp, pct];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'samples';
  @override
  VerificationContext validateIntegrity(Insertable<Sample> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('ma')) {
      context.handle(_maMeta, ma.isAcceptableOrUnknown(data['ma']!, _maMeta));
    } else if (isInserting) {
      context.missing(_maMeta);
    }
    if (data.containsKey('mv')) {
      context.handle(_mvMeta, mv.isAcceptableOrUnknown(data['mv']!, _mvMeta));
    } else if (isInserting) {
      context.missing(_mvMeta);
    }
    if (data.containsKey('temp')) {
      context.handle(
          _tempMeta, temp.isAcceptableOrUnknown(data['temp']!, _tempMeta));
    } else if (isInserting) {
      context.missing(_tempMeta);
    }
    if (data.containsKey('pct')) {
      context.handle(
          _pctMeta, pct.isAcceptableOrUnknown(data['pct']!, _pctMeta));
    } else if (isInserting) {
      context.missing(_pctMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sample(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}session_id'])!,
      ts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ts'])!,
      ma: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ma'])!,
      mv: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mv'])!,
      temp: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temp'])!,
      pct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pct'])!,
    );
  }

  @override
  $SamplesTable createAlias(String alias) {
    return $SamplesTable(attachedDatabase, alias);
  }
}

class Sample extends DataClass implements Insertable<Sample> {
  final int id;
  final int sessionId;
  final int ts;
  final double ma;
  final double mv;
  final double temp;
  final int pct;
  const Sample(
      {required this.id,
      required this.sessionId,
      required this.ts,
      required this.ma,
      required this.mv,
      required this.temp,
      required this.pct});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['ts'] = Variable<int>(ts);
    map['ma'] = Variable<double>(ma);
    map['mv'] = Variable<double>(mv);
    map['temp'] = Variable<double>(temp);
    map['pct'] = Variable<int>(pct);
    return map;
  }

  SamplesCompanion toCompanion(bool nullToAbsent) {
    return SamplesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      ts: Value(ts),
      ma: Value(ma),
      mv: Value(mv),
      temp: Value(temp),
      pct: Value(pct),
    );
  }

  factory Sample.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sample(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      ts: serializer.fromJson<int>(json['ts']),
      ma: serializer.fromJson<double>(json['ma']),
      mv: serializer.fromJson<double>(json['mv']),
      temp: serializer.fromJson<double>(json['temp']),
      pct: serializer.fromJson<int>(json['pct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'ts': serializer.toJson<int>(ts),
      'ma': serializer.toJson<double>(ma),
      'mv': serializer.toJson<double>(mv),
      'temp': serializer.toJson<double>(temp),
      'pct': serializer.toJson<int>(pct),
    };
  }

  Sample copyWith(
          {int? id,
          int? sessionId,
          int? ts,
          double? ma,
          double? mv,
          double? temp,
          int? pct}) =>
      Sample(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        ts: ts ?? this.ts,
        ma: ma ?? this.ma,
        mv: mv ?? this.mv,
        temp: temp ?? this.temp,
        pct: pct ?? this.pct,
      );
  Sample copyWithCompanion(SamplesCompanion data) {
    return Sample(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      ts: data.ts.present ? data.ts.value : this.ts,
      ma: data.ma.present ? data.ma.value : this.ma,
      mv: data.mv.present ? data.mv.value : this.mv,
      temp: data.temp.present ? data.temp.value : this.temp,
      pct: data.pct.present ? data.pct.value : this.pct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sample(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('ts: $ts, ')
          ..write('ma: $ma, ')
          ..write('mv: $mv, ')
          ..write('temp: $temp, ')
          ..write('pct: $pct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, ts, ma, mv, temp, pct);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sample &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.ts == this.ts &&
          other.ma == this.ma &&
          other.mv == this.mv &&
          other.temp == this.temp &&
          other.pct == this.pct);
}

class SamplesCompanion extends UpdateCompanion<Sample> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> ts;
  final Value<double> ma;
  final Value<double> mv;
  final Value<double> temp;
  final Value<int> pct;
  const SamplesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.ts = const Value.absent(),
    this.ma = const Value.absent(),
    this.mv = const Value.absent(),
    this.temp = const Value.absent(),
    this.pct = const Value.absent(),
  });
  SamplesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int ts,
    required double ma,
    required double mv,
    required double temp,
    required int pct,
  })  : sessionId = Value(sessionId),
        ts = Value(ts),
        ma = Value(ma),
        mv = Value(mv),
        temp = Value(temp),
        pct = Value(pct);
  static Insertable<Sample> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? ts,
    Expression<double>? ma,
    Expression<double>? mv,
    Expression<double>? temp,
    Expression<int>? pct,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (ts != null) 'ts': ts,
      if (ma != null) 'ma': ma,
      if (mv != null) 'mv': mv,
      if (temp != null) 'temp': temp,
      if (pct != null) 'pct': pct,
    });
  }

  SamplesCompanion copyWith(
      {Value<int>? id,
      Value<int>? sessionId,
      Value<int>? ts,
      Value<double>? ma,
      Value<double>? mv,
      Value<double>? temp,
      Value<int>? pct}) {
    return SamplesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      ts: ts ?? this.ts,
      ma: ma ?? this.ma,
      mv: mv ?? this.mv,
      temp: temp ?? this.temp,
      pct: pct ?? this.pct,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (ts.present) {
      map['ts'] = Variable<int>(ts.value);
    }
    if (ma.present) {
      map['ma'] = Variable<double>(ma.value);
    }
    if (mv.present) {
      map['mv'] = Variable<double>(mv.value);
    }
    if (temp.present) {
      map['temp'] = Variable<double>(temp.value);
    }
    if (pct.present) {
      map['pct'] = Variable<int>(pct.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SamplesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('ts: $ts, ')
          ..write('ma: $ma, ')
          ..write('mv: $mv, ')
          ..write('temp: $temp, ')
          ..write('pct: $pct')
          ..write(')'))
        .toString();
  }
}

class $ChargersTable extends Chargers with TableInfo<$ChargersTable, Charger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ratedWMeta = const VerificationMeta('ratedW');
  @override
  late final GeneratedColumn<double> ratedW = GeneratedColumn<double>(
      'rated_w', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avgScoreMeta =
      const VerificationMeta('avgScore');
  @override
  late final GeneratedColumn<double> avgScore = GeneratedColumn<double>(
      'avg_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sessionsCountMeta =
      const VerificationMeta('sessionsCount');
  @override
  late final GeneratedColumn<int> sessionsCount = GeneratedColumn<int>(
      'sessions_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, ratedW, avgScore, sessionsCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chargers';
  @override
  VerificationContext validateIntegrity(Insertable<Charger> instance,
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
    if (data.containsKey('rated_w')) {
      context.handle(_ratedWMeta,
          ratedW.isAcceptableOrUnknown(data['rated_w']!, _ratedWMeta));
    } else if (isInserting) {
      context.missing(_ratedWMeta);
    }
    if (data.containsKey('avg_score')) {
      context.handle(_avgScoreMeta,
          avgScore.isAcceptableOrUnknown(data['avg_score']!, _avgScoreMeta));
    }
    if (data.containsKey('sessions_count')) {
      context.handle(
          _sessionsCountMeta,
          sessionsCount.isAcceptableOrUnknown(
              data['sessions_count']!, _sessionsCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Charger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Charger(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ratedW: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rated_w'])!,
      avgScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_score']),
      sessionsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sessions_count'])!,
    );
  }

  @override
  $ChargersTable createAlias(String alias) {
    return $ChargersTable(attachedDatabase, alias);
  }
}

class Charger extends DataClass implements Insertable<Charger> {
  final int id;
  final String name;
  final double ratedW;
  final double? avgScore;
  final int sessionsCount;
  const Charger(
      {required this.id,
      required this.name,
      required this.ratedW,
      this.avgScore,
      required this.sessionsCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['rated_w'] = Variable<double>(ratedW);
    if (!nullToAbsent || avgScore != null) {
      map['avg_score'] = Variable<double>(avgScore);
    }
    map['sessions_count'] = Variable<int>(sessionsCount);
    return map;
  }

  ChargersCompanion toCompanion(bool nullToAbsent) {
    return ChargersCompanion(
      id: Value(id),
      name: Value(name),
      ratedW: Value(ratedW),
      avgScore: avgScore == null && nullToAbsent
          ? const Value.absent()
          : Value(avgScore),
      sessionsCount: Value(sessionsCount),
    );
  }

  factory Charger.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Charger(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ratedW: serializer.fromJson<double>(json['ratedW']),
      avgScore: serializer.fromJson<double?>(json['avgScore']),
      sessionsCount: serializer.fromJson<int>(json['sessionsCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ratedW': serializer.toJson<double>(ratedW),
      'avgScore': serializer.toJson<double?>(avgScore),
      'sessionsCount': serializer.toJson<int>(sessionsCount),
    };
  }

  Charger copyWith(
          {int? id,
          String? name,
          double? ratedW,
          Value<double?> avgScore = const Value.absent(),
          int? sessionsCount}) =>
      Charger(
        id: id ?? this.id,
        name: name ?? this.name,
        ratedW: ratedW ?? this.ratedW,
        avgScore: avgScore.present ? avgScore.value : this.avgScore,
        sessionsCount: sessionsCount ?? this.sessionsCount,
      );
  Charger copyWithCompanion(ChargersCompanion data) {
    return Charger(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ratedW: data.ratedW.present ? data.ratedW.value : this.ratedW,
      avgScore: data.avgScore.present ? data.avgScore.value : this.avgScore,
      sessionsCount: data.sessionsCount.present
          ? data.sessionsCount.value
          : this.sessionsCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Charger(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ratedW: $ratedW, ')
          ..write('avgScore: $avgScore, ')
          ..write('sessionsCount: $sessionsCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, ratedW, avgScore, sessionsCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Charger &&
          other.id == this.id &&
          other.name == this.name &&
          other.ratedW == this.ratedW &&
          other.avgScore == this.avgScore &&
          other.sessionsCount == this.sessionsCount);
}

class ChargersCompanion extends UpdateCompanion<Charger> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> ratedW;
  final Value<double?> avgScore;
  final Value<int> sessionsCount;
  const ChargersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ratedW = const Value.absent(),
    this.avgScore = const Value.absent(),
    this.sessionsCount = const Value.absent(),
  });
  ChargersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double ratedW,
    this.avgScore = const Value.absent(),
    this.sessionsCount = const Value.absent(),
  })  : name = Value(name),
        ratedW = Value(ratedW);
  static Insertable<Charger> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? ratedW,
    Expression<double>? avgScore,
    Expression<int>? sessionsCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ratedW != null) 'rated_w': ratedW,
      if (avgScore != null) 'avg_score': avgScore,
      if (sessionsCount != null) 'sessions_count': sessionsCount,
    });
  }

  ChargersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? ratedW,
      Value<double?>? avgScore,
      Value<int>? sessionsCount}) {
    return ChargersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ratedW: ratedW ?? this.ratedW,
      avgScore: avgScore ?? this.avgScore,
      sessionsCount: sessionsCount ?? this.sessionsCount,
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
    if (ratedW.present) {
      map['rated_w'] = Variable<double>(ratedW.value);
    }
    if (avgScore.present) {
      map['avg_score'] = Variable<double>(avgScore.value);
    }
    if (sessionsCount.present) {
      map['sessions_count'] = Variable<int>(sessionsCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ratedW: $ratedW, ')
          ..write('avgScore: $avgScore, ')
          ..write('sessionsCount: $sessionsCount')
          ..write(')'))
        .toString();
  }
}

class $HealthSnapshotsTable extends HealthSnapshots
    with TableInfo<$HealthSnapshotsTable, HealthSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<int> ts = GeneratedColumn<int>(
      'ts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _estCapacityMahMeta =
      const VerificationMeta('estCapacityMah');
  @override
  late final GeneratedColumn<int> estCapacityMah = GeneratedColumn<int>(
      'est_capacity_mah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _healthPctMeta =
      const VerificationMeta('healthPct');
  @override
  late final GeneratedColumn<double> healthPct = GeneratedColumn<double>(
      'health_pct', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cycleCountMeta =
      const VerificationMeta('cycleCount');
  @override
  late final GeneratedColumn<int> cycleCount = GeneratedColumn<int>(
      'cycle_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [ts, estCapacityMah, healthPct, cycleCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<HealthSnapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    }
    if (data.containsKey('est_capacity_mah')) {
      context.handle(
          _estCapacityMahMeta,
          estCapacityMah.isAcceptableOrUnknown(
              data['est_capacity_mah']!, _estCapacityMahMeta));
    } else if (isInserting) {
      context.missing(_estCapacityMahMeta);
    }
    if (data.containsKey('health_pct')) {
      context.handle(_healthPctMeta,
          healthPct.isAcceptableOrUnknown(data['health_pct']!, _healthPctMeta));
    } else if (isInserting) {
      context.missing(_healthPctMeta);
    }
    if (data.containsKey('cycle_count')) {
      context.handle(
          _cycleCountMeta,
          cycleCount.isAcceptableOrUnknown(
              data['cycle_count']!, _cycleCountMeta));
    } else if (isInserting) {
      context.missing(_cycleCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ts};
  @override
  HealthSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthSnapshot(
      ts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ts'])!,
      estCapacityMah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}est_capacity_mah'])!,
      healthPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}health_pct'])!,
      cycleCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycle_count'])!,
    );
  }

  @override
  $HealthSnapshotsTable createAlias(String alias) {
    return $HealthSnapshotsTable(attachedDatabase, alias);
  }
}

class HealthSnapshot extends DataClass implements Insertable<HealthSnapshot> {
  final int ts;
  final int estCapacityMah;
  final double healthPct;
  final int cycleCount;
  const HealthSnapshot(
      {required this.ts,
      required this.estCapacityMah,
      required this.healthPct,
      required this.cycleCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ts'] = Variable<int>(ts);
    map['est_capacity_mah'] = Variable<int>(estCapacityMah);
    map['health_pct'] = Variable<double>(healthPct);
    map['cycle_count'] = Variable<int>(cycleCount);
    return map;
  }

  HealthSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return HealthSnapshotsCompanion(
      ts: Value(ts),
      estCapacityMah: Value(estCapacityMah),
      healthPct: Value(healthPct),
      cycleCount: Value(cycleCount),
    );
  }

  factory HealthSnapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthSnapshot(
      ts: serializer.fromJson<int>(json['ts']),
      estCapacityMah: serializer.fromJson<int>(json['estCapacityMah']),
      healthPct: serializer.fromJson<double>(json['healthPct']),
      cycleCount: serializer.fromJson<int>(json['cycleCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ts': serializer.toJson<int>(ts),
      'estCapacityMah': serializer.toJson<int>(estCapacityMah),
      'healthPct': serializer.toJson<double>(healthPct),
      'cycleCount': serializer.toJson<int>(cycleCount),
    };
  }

  HealthSnapshot copyWith(
          {int? ts, int? estCapacityMah, double? healthPct, int? cycleCount}) =>
      HealthSnapshot(
        ts: ts ?? this.ts,
        estCapacityMah: estCapacityMah ?? this.estCapacityMah,
        healthPct: healthPct ?? this.healthPct,
        cycleCount: cycleCount ?? this.cycleCount,
      );
  HealthSnapshot copyWithCompanion(HealthSnapshotsCompanion data) {
    return HealthSnapshot(
      ts: data.ts.present ? data.ts.value : this.ts,
      estCapacityMah: data.estCapacityMah.present
          ? data.estCapacityMah.value
          : this.estCapacityMah,
      healthPct: data.healthPct.present ? data.healthPct.value : this.healthPct,
      cycleCount:
          data.cycleCount.present ? data.cycleCount.value : this.cycleCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthSnapshot(')
          ..write('ts: $ts, ')
          ..write('estCapacityMah: $estCapacityMah, ')
          ..write('healthPct: $healthPct, ')
          ..write('cycleCount: $cycleCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ts, estCapacityMah, healthPct, cycleCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthSnapshot &&
          other.ts == this.ts &&
          other.estCapacityMah == this.estCapacityMah &&
          other.healthPct == this.healthPct &&
          other.cycleCount == this.cycleCount);
}

class HealthSnapshotsCompanion extends UpdateCompanion<HealthSnapshot> {
  final Value<int> ts;
  final Value<int> estCapacityMah;
  final Value<double> healthPct;
  final Value<int> cycleCount;
  const HealthSnapshotsCompanion({
    this.ts = const Value.absent(),
    this.estCapacityMah = const Value.absent(),
    this.healthPct = const Value.absent(),
    this.cycleCount = const Value.absent(),
  });
  HealthSnapshotsCompanion.insert({
    this.ts = const Value.absent(),
    required int estCapacityMah,
    required double healthPct,
    required int cycleCount,
  })  : estCapacityMah = Value(estCapacityMah),
        healthPct = Value(healthPct),
        cycleCount = Value(cycleCount);
  static Insertable<HealthSnapshot> custom({
    Expression<int>? ts,
    Expression<int>? estCapacityMah,
    Expression<double>? healthPct,
    Expression<int>? cycleCount,
  }) {
    return RawValuesInsertable({
      if (ts != null) 'ts': ts,
      if (estCapacityMah != null) 'est_capacity_mah': estCapacityMah,
      if (healthPct != null) 'health_pct': healthPct,
      if (cycleCount != null) 'cycle_count': cycleCount,
    });
  }

  HealthSnapshotsCompanion copyWith(
      {Value<int>? ts,
      Value<int>? estCapacityMah,
      Value<double>? healthPct,
      Value<int>? cycleCount}) {
    return HealthSnapshotsCompanion(
      ts: ts ?? this.ts,
      estCapacityMah: estCapacityMah ?? this.estCapacityMah,
      healthPct: healthPct ?? this.healthPct,
      cycleCount: cycleCount ?? this.cycleCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ts.present) {
      map['ts'] = Variable<int>(ts.value);
    }
    if (estCapacityMah.present) {
      map['est_capacity_mah'] = Variable<int>(estCapacityMah.value);
    }
    if (healthPct.present) {
      map['health_pct'] = Variable<double>(healthPct.value);
    }
    if (cycleCount.present) {
      map['cycle_count'] = Variable<int>(cycleCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthSnapshotsCompanion(')
          ..write('ts: $ts, ')
          ..write('estCapacityMah: $estCapacityMah, ')
          ..write('healthPct: $healthPct, ')
          ..write('cycleCount: $cycleCount')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SamplesTable samples = $SamplesTable(this);
  late final $ChargersTable chargers = $ChargersTable(this);
  late final $HealthSnapshotsTable healthSnapshots =
      $HealthSnapshotsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  late final SampleDao sampleDao = SampleDao(this as AppDatabase);
  late final ChargerDao chargerDao = ChargerDao(this as AppDatabase);
  late final HealthDao healthDao = HealthDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sessions, samples, chargers, healthSnapshots, settings];
}

typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int startTs,
  Value<int?> endTs,
  required int startPct,
  Value<int?> endPct,
  Value<double?> avgW,
  Value<double?> peakW,
  Value<double?> avgMa,
  Value<double?> maxTemp,
  Value<int?> chargerId,
  required String chargerType,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> startTs,
  Value<int?> endTs,
  Value<int> startPct,
  Value<int?> endPct,
  Value<double?> avgW,
  Value<double?> peakW,
  Value<double?> avgMa,
  Value<double?> maxTemp,
  Value<int?> chargerId,
  Value<String> chargerType,
});

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SessionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> startTs = const Value.absent(),
            Value<int?> endTs = const Value.absent(),
            Value<int> startPct = const Value.absent(),
            Value<int?> endPct = const Value.absent(),
            Value<double?> avgW = const Value.absent(),
            Value<double?> peakW = const Value.absent(),
            Value<double?> avgMa = const Value.absent(),
            Value<double?> maxTemp = const Value.absent(),
            Value<int?> chargerId = const Value.absent(),
            Value<String> chargerType = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            startTs: startTs,
            endTs: endTs,
            startPct: startPct,
            endPct: endPct,
            avgW: avgW,
            peakW: peakW,
            avgMa: avgMa,
            maxTemp: maxTemp,
            chargerId: chargerId,
            chargerType: chargerType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int startTs,
            Value<int?> endTs = const Value.absent(),
            required int startPct,
            Value<int?> endPct = const Value.absent(),
            Value<double?> avgW = const Value.absent(),
            Value<double?> peakW = const Value.absent(),
            Value<double?> avgMa = const Value.absent(),
            Value<double?> maxTemp = const Value.absent(),
            Value<int?> chargerId = const Value.absent(),
            required String chargerType,
          }) =>
              SessionsCompanion.insert(
            id: id,
            startTs: startTs,
            endTs: endTs,
            startPct: startPct,
            endPct: endPct,
            avgW: avgW,
            peakW: peakW,
            avgMa: avgMa,
            maxTemp: maxTemp,
            chargerId: chargerId,
            chargerType: chargerType,
          ),
        ));
}

class $$SessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startTs => $state.composableBuilder(
      column: $state.table.startTs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endTs => $state.composableBuilder(
      column: $state.table.endTs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startPct => $state.composableBuilder(
      column: $state.table.startPct,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endPct => $state.composableBuilder(
      column: $state.table.endPct,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get avgW => $state.composableBuilder(
      column: $state.table.avgW,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get peakW => $state.composableBuilder(
      column: $state.table.peakW,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get avgMa => $state.composableBuilder(
      column: $state.table.avgMa,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get maxTemp => $state.composableBuilder(
      column: $state.table.maxTemp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get chargerId => $state.composableBuilder(
      column: $state.table.chargerId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get chargerType => $state.composableBuilder(
      column: $state.table.chargerType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startTs => $state.composableBuilder(
      column: $state.table.startTs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endTs => $state.composableBuilder(
      column: $state.table.endTs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startPct => $state.composableBuilder(
      column: $state.table.startPct,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endPct => $state.composableBuilder(
      column: $state.table.endPct,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get avgW => $state.composableBuilder(
      column: $state.table.avgW,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get peakW => $state.composableBuilder(
      column: $state.table.peakW,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get avgMa => $state.composableBuilder(
      column: $state.table.avgMa,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get maxTemp => $state.composableBuilder(
      column: $state.table.maxTemp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get chargerId => $state.composableBuilder(
      column: $state.table.chargerId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get chargerType => $state.composableBuilder(
      column: $state.table.chargerType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SamplesTableCreateCompanionBuilder = SamplesCompanion Function({
  Value<int> id,
  required int sessionId,
  required int ts,
  required double ma,
  required double mv,
  required double temp,
  required int pct,
});
typedef $$SamplesTableUpdateCompanionBuilder = SamplesCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<int> ts,
  Value<double> ma,
  Value<double> mv,
  Value<double> temp,
  Value<int> pct,
});

class $$SamplesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SamplesTable,
    Sample,
    $$SamplesTableFilterComposer,
    $$SamplesTableOrderingComposer,
    $$SamplesTableCreateCompanionBuilder,
    $$SamplesTableUpdateCompanionBuilder> {
  $$SamplesTableTableManager(_$AppDatabase db, $SamplesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SamplesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SamplesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sessionId = const Value.absent(),
            Value<int> ts = const Value.absent(),
            Value<double> ma = const Value.absent(),
            Value<double> mv = const Value.absent(),
            Value<double> temp = const Value.absent(),
            Value<int> pct = const Value.absent(),
          }) =>
              SamplesCompanion(
            id: id,
            sessionId: sessionId,
            ts: ts,
            ma: ma,
            mv: mv,
            temp: temp,
            pct: pct,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sessionId,
            required int ts,
            required double ma,
            required double mv,
            required double temp,
            required int pct,
          }) =>
              SamplesCompanion.insert(
            id: id,
            sessionId: sessionId,
            ts: ts,
            ma: ma,
            mv: mv,
            temp: temp,
            pct: pct,
          ),
        ));
}

class $$SamplesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sessionId => $state.composableBuilder(
      column: $state.table.sessionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ts => $state.composableBuilder(
      column: $state.table.ts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get ma => $state.composableBuilder(
      column: $state.table.ma,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get mv => $state.composableBuilder(
      column: $state.table.mv,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get temp => $state.composableBuilder(
      column: $state.table.temp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get pct => $state.composableBuilder(
      column: $state.table.pct,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SamplesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SamplesTable> {
  $$SamplesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sessionId => $state.composableBuilder(
      column: $state.table.sessionId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ts => $state.composableBuilder(
      column: $state.table.ts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get ma => $state.composableBuilder(
      column: $state.table.ma,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get mv => $state.composableBuilder(
      column: $state.table.mv,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get temp => $state.composableBuilder(
      column: $state.table.temp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get pct => $state.composableBuilder(
      column: $state.table.pct,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ChargersTableCreateCompanionBuilder = ChargersCompanion Function({
  Value<int> id,
  required String name,
  required double ratedW,
  Value<double?> avgScore,
  Value<int> sessionsCount,
});
typedef $$ChargersTableUpdateCompanionBuilder = ChargersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> ratedW,
  Value<double?> avgScore,
  Value<int> sessionsCount,
});

class $$ChargersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChargersTable,
    Charger,
    $$ChargersTableFilterComposer,
    $$ChargersTableOrderingComposer,
    $$ChargersTableCreateCompanionBuilder,
    $$ChargersTableUpdateCompanionBuilder> {
  $$ChargersTableTableManager(_$AppDatabase db, $ChargersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ChargersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ChargersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> ratedW = const Value.absent(),
            Value<double?> avgScore = const Value.absent(),
            Value<int> sessionsCount = const Value.absent(),
          }) =>
              ChargersCompanion(
            id: id,
            name: name,
            ratedW: ratedW,
            avgScore: avgScore,
            sessionsCount: sessionsCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double ratedW,
            Value<double?> avgScore = const Value.absent(),
            Value<int> sessionsCount = const Value.absent(),
          }) =>
              ChargersCompanion.insert(
            id: id,
            name: name,
            ratedW: ratedW,
            avgScore: avgScore,
            sessionsCount: sessionsCount,
          ),
        ));
}

class $$ChargersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ChargersTable> {
  $$ChargersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get ratedW => $state.composableBuilder(
      column: $state.table.ratedW,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get avgScore => $state.composableBuilder(
      column: $state.table.avgScore,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sessionsCount => $state.composableBuilder(
      column: $state.table.sessionsCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ChargersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ChargersTable> {
  $$ChargersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get ratedW => $state.composableBuilder(
      column: $state.table.ratedW,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get avgScore => $state.composableBuilder(
      column: $state.table.avgScore,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sessionsCount => $state.composableBuilder(
      column: $state.table.sessionsCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$HealthSnapshotsTableCreateCompanionBuilder = HealthSnapshotsCompanion
    Function({
  Value<int> ts,
  required int estCapacityMah,
  required double healthPct,
  required int cycleCount,
});
typedef $$HealthSnapshotsTableUpdateCompanionBuilder = HealthSnapshotsCompanion
    Function({
  Value<int> ts,
  Value<int> estCapacityMah,
  Value<double> healthPct,
  Value<int> cycleCount,
});

class $$HealthSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HealthSnapshotsTable,
    HealthSnapshot,
    $$HealthSnapshotsTableFilterComposer,
    $$HealthSnapshotsTableOrderingComposer,
    $$HealthSnapshotsTableCreateCompanionBuilder,
    $$HealthSnapshotsTableUpdateCompanionBuilder> {
  $$HealthSnapshotsTableTableManager(
      _$AppDatabase db, $HealthSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HealthSnapshotsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HealthSnapshotsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> ts = const Value.absent(),
            Value<int> estCapacityMah = const Value.absent(),
            Value<double> healthPct = const Value.absent(),
            Value<int> cycleCount = const Value.absent(),
          }) =>
              HealthSnapshotsCompanion(
            ts: ts,
            estCapacityMah: estCapacityMah,
            healthPct: healthPct,
            cycleCount: cycleCount,
          ),
          createCompanionCallback: ({
            Value<int> ts = const Value.absent(),
            required int estCapacityMah,
            required double healthPct,
            required int cycleCount,
          }) =>
              HealthSnapshotsCompanion.insert(
            ts: ts,
            estCapacityMah: estCapacityMah,
            healthPct: healthPct,
            cycleCount: cycleCount,
          ),
        ));
}

class $$HealthSnapshotsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HealthSnapshotsTable> {
  $$HealthSnapshotsTableFilterComposer(super.$state);
  ColumnFilters<int> get ts => $state.composableBuilder(
      column: $state.table.ts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get estCapacityMah => $state.composableBuilder(
      column: $state.table.estCapacityMah,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get healthPct => $state.composableBuilder(
      column: $state.table.healthPct,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get cycleCount => $state.composableBuilder(
      column: $state.table.cycleCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HealthSnapshotsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HealthSnapshotsTable> {
  $$HealthSnapshotsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get ts => $state.composableBuilder(
      column: $state.table.ts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get estCapacityMah => $state.composableBuilder(
      column: $state.table.estCapacityMah,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get healthPct => $state.composableBuilder(
      column: $state.table.healthPct,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get cycleCount => $state.composableBuilder(
      column: $state.table.cycleCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SettingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
        ));
}

class $$SettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer(super.$state);
  ColumnFilters<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SamplesTableTableManager get samples =>
      $$SamplesTableTableManager(_db, _db.samples);
  $$ChargersTableTableManager get chargers =>
      $$ChargersTableTableManager(_db, _db.chargers);
  $$HealthSnapshotsTableTableManager get healthSnapshots =>
      $$HealthSnapshotsTableTableManager(_db, _db.healthSnapshots);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
