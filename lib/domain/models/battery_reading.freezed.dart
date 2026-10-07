// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battery_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BatteryReading _$BatteryReadingFromJson(Map<String, dynamic> json) {
  return _BatteryReading.fromJson(json);
}

/// @nodoc
mixin _$BatteryReading {
  double get currentMa => throw _privateConstructorUsedError;
  int get voltageMv => throw _privateConstructorUsedError;
  double get temperatureC => throw _privateConstructorUsedError;
  int get percent => throw _privateConstructorUsedError;
  BatteryStatus get status => throw _privateConstructorUsedError;
  PlugType get plugType => throw _privateConstructorUsedError;
  BatteryHealth get health => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get technology => throw _privateConstructorUsedError;
  int get designCapacityMah => throw _privateConstructorUsedError;
  int get chargeCounterUah => throw _privateConstructorUsedError;
  int get chargeTimeRemainingMs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BatteryReadingCopyWith<BatteryReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatteryReadingCopyWith<$Res> {
  factory $BatteryReadingCopyWith(
          BatteryReading value, $Res Function(BatteryReading) then) =
      _$BatteryReadingCopyWithImpl<$Res, BatteryReading>;
  @useResult
  $Res call(
      {double currentMa,
      int voltageMv,
      double temperatureC,
      int percent,
      BatteryStatus status,
      PlugType plugType,
      BatteryHealth health,
      DateTime timestamp,
      String technology,
      int designCapacityMah,
      int chargeCounterUah,
      int chargeTimeRemainingMs});
}

/// @nodoc
class _$BatteryReadingCopyWithImpl<$Res, $Val extends BatteryReading>
    implements $BatteryReadingCopyWith<$Res> {
  _$BatteryReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMa = null,
    Object? voltageMv = null,
    Object? temperatureC = null,
    Object? percent = null,
    Object? status = null,
    Object? plugType = null,
    Object? health = null,
    Object? timestamp = null,
    Object? technology = null,
    Object? designCapacityMah = null,
    Object? chargeCounterUah = null,
    Object? chargeTimeRemainingMs = null,
  }) {
    return _then(_value.copyWith(
      currentMa: null == currentMa
          ? _value.currentMa
          : currentMa // ignore: cast_nullable_to_non_nullable
              as double,
      voltageMv: null == voltageMv
          ? _value.voltageMv
          : voltageMv // ignore: cast_nullable_to_non_nullable
              as int,
      temperatureC: null == temperatureC
          ? _value.temperatureC
          : temperatureC // ignore: cast_nullable_to_non_nullable
              as double,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BatteryStatus,
      plugType: null == plugType
          ? _value.plugType
          : plugType // ignore: cast_nullable_to_non_nullable
              as PlugType,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as BatteryHealth,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      technology: null == technology
          ? _value.technology
          : technology // ignore: cast_nullable_to_non_nullable
              as String,
      designCapacityMah: null == designCapacityMah
          ? _value.designCapacityMah
          : designCapacityMah // ignore: cast_nullable_to_non_nullable
              as int,
      chargeCounterUah: null == chargeCounterUah
          ? _value.chargeCounterUah
          : chargeCounterUah // ignore: cast_nullable_to_non_nullable
              as int,
      chargeTimeRemainingMs: null == chargeTimeRemainingMs
          ? _value.chargeTimeRemainingMs
          : chargeTimeRemainingMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatteryReadingImplCopyWith<$Res>
    implements $BatteryReadingCopyWith<$Res> {
  factory _$$BatteryReadingImplCopyWith(_$BatteryReadingImpl value,
          $Res Function(_$BatteryReadingImpl) then) =
      __$$BatteryReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentMa,
      int voltageMv,
      double temperatureC,
      int percent,
      BatteryStatus status,
      PlugType plugType,
      BatteryHealth health,
      DateTime timestamp,
      String technology,
      int designCapacityMah,
      int chargeCounterUah,
      int chargeTimeRemainingMs});
}

/// @nodoc
class __$$BatteryReadingImplCopyWithImpl<$Res>
    extends _$BatteryReadingCopyWithImpl<$Res, _$BatteryReadingImpl>
    implements _$$BatteryReadingImplCopyWith<$Res> {
  __$$BatteryReadingImplCopyWithImpl(
      _$BatteryReadingImpl _value, $Res Function(_$BatteryReadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMa = null,
    Object? voltageMv = null,
    Object? temperatureC = null,
    Object? percent = null,
    Object? status = null,
    Object? plugType = null,
    Object? health = null,
    Object? timestamp = null,
    Object? technology = null,
    Object? designCapacityMah = null,
    Object? chargeCounterUah = null,
    Object? chargeTimeRemainingMs = null,
  }) {
    return _then(_$BatteryReadingImpl(
      currentMa: null == currentMa
          ? _value.currentMa
          : currentMa // ignore: cast_nullable_to_non_nullable
              as double,
      voltageMv: null == voltageMv
          ? _value.voltageMv
          : voltageMv // ignore: cast_nullable_to_non_nullable
              as int,
      temperatureC: null == temperatureC
          ? _value.temperatureC
          : temperatureC // ignore: cast_nullable_to_non_nullable
              as double,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BatteryStatus,
      plugType: null == plugType
          ? _value.plugType
          : plugType // ignore: cast_nullable_to_non_nullable
              as PlugType,
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as BatteryHealth,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      technology: null == technology
          ? _value.technology
          : technology // ignore: cast_nullable_to_non_nullable
              as String,
      designCapacityMah: null == designCapacityMah
          ? _value.designCapacityMah
          : designCapacityMah // ignore: cast_nullable_to_non_nullable
              as int,
      chargeCounterUah: null == chargeCounterUah
          ? _value.chargeCounterUah
          : chargeCounterUah // ignore: cast_nullable_to_non_nullable
              as int,
      chargeTimeRemainingMs: null == chargeTimeRemainingMs
          ? _value.chargeTimeRemainingMs
          : chargeTimeRemainingMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatteryReadingImpl extends _BatteryReading {
  const _$BatteryReadingImpl(
      {required this.currentMa,
      required this.voltageMv,
      required this.temperatureC,
      required this.percent,
      required this.status,
      required this.plugType,
      required this.health,
      required this.timestamp,
      this.technology = 'Li-ion',
      this.designCapacityMah = 0,
      this.chargeCounterUah = 0,
      this.chargeTimeRemainingMs = -1})
      : super._();

  factory _$BatteryReadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatteryReadingImplFromJson(json);

  @override
  final double currentMa;
  @override
  final int voltageMv;
  @override
  final double temperatureC;
  @override
  final int percent;
  @override
  final BatteryStatus status;
  @override
  final PlugType plugType;
  @override
  final BatteryHealth health;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final String technology;
  @override
  @JsonKey()
  final int designCapacityMah;
  @override
  @JsonKey()
  final int chargeCounterUah;
  @override
  @JsonKey()
  final int chargeTimeRemainingMs;

  @override
  String toString() {
    return 'BatteryReading(currentMa: $currentMa, voltageMv: $voltageMv, temperatureC: $temperatureC, percent: $percent, status: $status, plugType: $plugType, health: $health, timestamp: $timestamp, technology: $technology, designCapacityMah: $designCapacityMah, chargeCounterUah: $chargeCounterUah, chargeTimeRemainingMs: $chargeTimeRemainingMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatteryReadingImpl &&
            (identical(other.currentMa, currentMa) ||
                other.currentMa == currentMa) &&
            (identical(other.voltageMv, voltageMv) ||
                other.voltageMv == voltageMv) &&
            (identical(other.temperatureC, temperatureC) ||
                other.temperatureC == temperatureC) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.plugType, plugType) ||
                other.plugType == plugType) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.technology, technology) ||
                other.technology == technology) &&
            (identical(other.designCapacityMah, designCapacityMah) ||
                other.designCapacityMah == designCapacityMah) &&
            (identical(other.chargeCounterUah, chargeCounterUah) ||
                other.chargeCounterUah == chargeCounterUah) &&
            (identical(other.chargeTimeRemainingMs, chargeTimeRemainingMs) ||
                other.chargeTimeRemainingMs == chargeTimeRemainingMs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentMa,
      voltageMv,
      temperatureC,
      percent,
      status,
      plugType,
      health,
      timestamp,
      technology,
      designCapacityMah,
      chargeCounterUah,
      chargeTimeRemainingMs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BatteryReadingImplCopyWith<_$BatteryReadingImpl> get copyWith =>
      __$$BatteryReadingImplCopyWithImpl<_$BatteryReadingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatteryReadingImplToJson(
      this,
    );
  }
}

abstract class _BatteryReading extends BatteryReading {
  const factory _BatteryReading(
      {required final double currentMa,
      required final int voltageMv,
      required final double temperatureC,
      required final int percent,
      required final BatteryStatus status,
      required final PlugType plugType,
      required final BatteryHealth health,
      required final DateTime timestamp,
      final String technology,
      final int designCapacityMah,
      final int chargeCounterUah,
      final int chargeTimeRemainingMs}) = _$BatteryReadingImpl;
  const _BatteryReading._() : super._();

  factory _BatteryReading.fromJson(Map<String, dynamic> json) =
      _$BatteryReadingImpl.fromJson;

  @override
  double get currentMa;
  @override
  int get voltageMv;
  @override
  double get temperatureC;
  @override
  int get percent;
  @override
  BatteryStatus get status;
  @override
  PlugType get plugType;
  @override
  BatteryHealth get health;
  @override
  DateTime get timestamp;
  @override
  String get technology;
  @override
  int get designCapacityMah;
  @override
  int get chargeCounterUah;
  @override
  int get chargeTimeRemainingMs;
  @override
  @JsonKey(ignore: true)
  _$$BatteryReadingImplCopyWith<_$BatteryReadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
