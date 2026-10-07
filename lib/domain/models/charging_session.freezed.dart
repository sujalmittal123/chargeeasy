// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charging_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChargingSession _$ChargingSessionFromJson(Map<String, dynamic> json) {
  return _ChargingSession.fromJson(json);
}

/// @nodoc
mixin _$ChargingSession {
  int get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  int get startPercent => throw _privateConstructorUsedError;
  int? get endPercent => throw _privateConstructorUsedError;
  double? get avgPowerW => throw _privateConstructorUsedError;
  double? get peakPowerW => throw _privateConstructorUsedError;
  double? get avgMa => throw _privateConstructorUsedError;
  double? get maxTempC => throw _privateConstructorUsedError;
  int? get chargerId => throw _privateConstructorUsedError;
  String get chargerType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChargingSessionCopyWith<ChargingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargingSessionCopyWith<$Res> {
  factory $ChargingSessionCopyWith(
          ChargingSession value, $Res Function(ChargingSession) then) =
      _$ChargingSessionCopyWithImpl<$Res, ChargingSession>;
  @useResult
  $Res call(
      {int id,
      DateTime startTime,
      DateTime? endTime,
      int startPercent,
      int? endPercent,
      double? avgPowerW,
      double? peakPowerW,
      double? avgMa,
      double? maxTempC,
      int? chargerId,
      String chargerType});
}

/// @nodoc
class _$ChargingSessionCopyWithImpl<$Res, $Val extends ChargingSession>
    implements $ChargingSessionCopyWith<$Res> {
  _$ChargingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? startPercent = null,
    Object? endPercent = freezed,
    Object? avgPowerW = freezed,
    Object? peakPowerW = freezed,
    Object? avgMa = freezed,
    Object? maxTempC = freezed,
    Object? chargerId = freezed,
    Object? chargerType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startPercent: null == startPercent
          ? _value.startPercent
          : startPercent // ignore: cast_nullable_to_non_nullable
              as int,
      endPercent: freezed == endPercent
          ? _value.endPercent
          : endPercent // ignore: cast_nullable_to_non_nullable
              as int?,
      avgPowerW: freezed == avgPowerW
          ? _value.avgPowerW
          : avgPowerW // ignore: cast_nullable_to_non_nullable
              as double?,
      peakPowerW: freezed == peakPowerW
          ? _value.peakPowerW
          : peakPowerW // ignore: cast_nullable_to_non_nullable
              as double?,
      avgMa: freezed == avgMa
          ? _value.avgMa
          : avgMa // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTempC: freezed == maxTempC
          ? _value.maxTempC
          : maxTempC // ignore: cast_nullable_to_non_nullable
              as double?,
      chargerId: freezed == chargerId
          ? _value.chargerId
          : chargerId // ignore: cast_nullable_to_non_nullable
              as int?,
      chargerType: null == chargerType
          ? _value.chargerType
          : chargerType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChargingSessionImplCopyWith<$Res>
    implements $ChargingSessionCopyWith<$Res> {
  factory _$$ChargingSessionImplCopyWith(_$ChargingSessionImpl value,
          $Res Function(_$ChargingSessionImpl) then) =
      __$$ChargingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime startTime,
      DateTime? endTime,
      int startPercent,
      int? endPercent,
      double? avgPowerW,
      double? peakPowerW,
      double? avgMa,
      double? maxTempC,
      int? chargerId,
      String chargerType});
}

/// @nodoc
class __$$ChargingSessionImplCopyWithImpl<$Res>
    extends _$ChargingSessionCopyWithImpl<$Res, _$ChargingSessionImpl>
    implements _$$ChargingSessionImplCopyWith<$Res> {
  __$$ChargingSessionImplCopyWithImpl(
      _$ChargingSessionImpl _value, $Res Function(_$ChargingSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? startPercent = null,
    Object? endPercent = freezed,
    Object? avgPowerW = freezed,
    Object? peakPowerW = freezed,
    Object? avgMa = freezed,
    Object? maxTempC = freezed,
    Object? chargerId = freezed,
    Object? chargerType = null,
  }) {
    return _then(_$ChargingSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startPercent: null == startPercent
          ? _value.startPercent
          : startPercent // ignore: cast_nullable_to_non_nullable
              as int,
      endPercent: freezed == endPercent
          ? _value.endPercent
          : endPercent // ignore: cast_nullable_to_non_nullable
              as int?,
      avgPowerW: freezed == avgPowerW
          ? _value.avgPowerW
          : avgPowerW // ignore: cast_nullable_to_non_nullable
              as double?,
      peakPowerW: freezed == peakPowerW
          ? _value.peakPowerW
          : peakPowerW // ignore: cast_nullable_to_non_nullable
              as double?,
      avgMa: freezed == avgMa
          ? _value.avgMa
          : avgMa // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTempC: freezed == maxTempC
          ? _value.maxTempC
          : maxTempC // ignore: cast_nullable_to_non_nullable
              as double?,
      chargerId: freezed == chargerId
          ? _value.chargerId
          : chargerId // ignore: cast_nullable_to_non_nullable
              as int?,
      chargerType: null == chargerType
          ? _value.chargerType
          : chargerType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChargingSessionImpl implements _ChargingSession {
  const _$ChargingSessionImpl(
      {required this.id,
      required this.startTime,
      this.endTime,
      required this.startPercent,
      this.endPercent,
      this.avgPowerW,
      this.peakPowerW,
      this.avgMa,
      this.maxTempC,
      this.chargerId,
      required this.chargerType});

  factory _$ChargingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargingSessionImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final int startPercent;
  @override
  final int? endPercent;
  @override
  final double? avgPowerW;
  @override
  final double? peakPowerW;
  @override
  final double? avgMa;
  @override
  final double? maxTempC;
  @override
  final int? chargerId;
  @override
  final String chargerType;

  @override
  String toString() {
    return 'ChargingSession(id: $id, startTime: $startTime, endTime: $endTime, startPercent: $startPercent, endPercent: $endPercent, avgPowerW: $avgPowerW, peakPowerW: $peakPowerW, avgMa: $avgMa, maxTempC: $maxTempC, chargerId: $chargerId, chargerType: $chargerType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.startPercent, startPercent) ||
                other.startPercent == startPercent) &&
            (identical(other.endPercent, endPercent) ||
                other.endPercent == endPercent) &&
            (identical(other.avgPowerW, avgPowerW) ||
                other.avgPowerW == avgPowerW) &&
            (identical(other.peakPowerW, peakPowerW) ||
                other.peakPowerW == peakPowerW) &&
            (identical(other.avgMa, avgMa) || other.avgMa == avgMa) &&
            (identical(other.maxTempC, maxTempC) ||
                other.maxTempC == maxTempC) &&
            (identical(other.chargerId, chargerId) ||
                other.chargerId == chargerId) &&
            (identical(other.chargerType, chargerType) ||
                other.chargerType == chargerType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      startTime,
      endTime,
      startPercent,
      endPercent,
      avgPowerW,
      peakPowerW,
      avgMa,
      maxTempC,
      chargerId,
      chargerType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargingSessionImplCopyWith<_$ChargingSessionImpl> get copyWith =>
      __$$ChargingSessionImplCopyWithImpl<_$ChargingSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargingSessionImplToJson(
      this,
    );
  }
}

abstract class _ChargingSession implements ChargingSession {
  const factory _ChargingSession(
      {required final int id,
      required final DateTime startTime,
      final DateTime? endTime,
      required final int startPercent,
      final int? endPercent,
      final double? avgPowerW,
      final double? peakPowerW,
      final double? avgMa,
      final double? maxTempC,
      final int? chargerId,
      required final String chargerType}) = _$ChargingSessionImpl;

  factory _ChargingSession.fromJson(Map<String, dynamic> json) =
      _$ChargingSessionImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  int get startPercent;
  @override
  int? get endPercent;
  @override
  double? get avgPowerW;
  @override
  double? get peakPowerW;
  @override
  double? get avgMa;
  @override
  double? get maxTempC;
  @override
  int? get chargerId;
  @override
  String get chargerType;
  @override
  @JsonKey(ignore: true)
  _$$ChargingSessionImplCopyWith<_$ChargingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
