// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discharge_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DischargeStats _$DischargeStatsFromJson(Map<String, dynamic> json) {
  return _DischargeStats.fromJson(json);
}

/// @nodoc
mixin _$DischargeStats {
  double get screenOnDrainPerHr => throw _privateConstructorUsedError;
  double get screenOffDrainPerHr => throw _privateConstructorUsedError;
  double get deepSleepDrainPerHr => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DischargeStatsCopyWith<DischargeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DischargeStatsCopyWith<$Res> {
  factory $DischargeStatsCopyWith(
          DischargeStats value, $Res Function(DischargeStats) then) =
      _$DischargeStatsCopyWithImpl<$Res, DischargeStats>;
  @useResult
  $Res call(
      {double screenOnDrainPerHr,
      double screenOffDrainPerHr,
      double deepSleepDrainPerHr});
}

/// @nodoc
class _$DischargeStatsCopyWithImpl<$Res, $Val extends DischargeStats>
    implements $DischargeStatsCopyWith<$Res> {
  _$DischargeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenOnDrainPerHr = null,
    Object? screenOffDrainPerHr = null,
    Object? deepSleepDrainPerHr = null,
  }) {
    return _then(_value.copyWith(
      screenOnDrainPerHr: null == screenOnDrainPerHr
          ? _value.screenOnDrainPerHr
          : screenOnDrainPerHr // ignore: cast_nullable_to_non_nullable
              as double,
      screenOffDrainPerHr: null == screenOffDrainPerHr
          ? _value.screenOffDrainPerHr
          : screenOffDrainPerHr // ignore: cast_nullable_to_non_nullable
              as double,
      deepSleepDrainPerHr: null == deepSleepDrainPerHr
          ? _value.deepSleepDrainPerHr
          : deepSleepDrainPerHr // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DischargeStatsImplCopyWith<$Res>
    implements $DischargeStatsCopyWith<$Res> {
  factory _$$DischargeStatsImplCopyWith(_$DischargeStatsImpl value,
          $Res Function(_$DischargeStatsImpl) then) =
      __$$DischargeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double screenOnDrainPerHr,
      double screenOffDrainPerHr,
      double deepSleepDrainPerHr});
}

/// @nodoc
class __$$DischargeStatsImplCopyWithImpl<$Res>
    extends _$DischargeStatsCopyWithImpl<$Res, _$DischargeStatsImpl>
    implements _$$DischargeStatsImplCopyWith<$Res> {
  __$$DischargeStatsImplCopyWithImpl(
      _$DischargeStatsImpl _value, $Res Function(_$DischargeStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? screenOnDrainPerHr = null,
    Object? screenOffDrainPerHr = null,
    Object? deepSleepDrainPerHr = null,
  }) {
    return _then(_$DischargeStatsImpl(
      screenOnDrainPerHr: null == screenOnDrainPerHr
          ? _value.screenOnDrainPerHr
          : screenOnDrainPerHr // ignore: cast_nullable_to_non_nullable
              as double,
      screenOffDrainPerHr: null == screenOffDrainPerHr
          ? _value.screenOffDrainPerHr
          : screenOffDrainPerHr // ignore: cast_nullable_to_non_nullable
              as double,
      deepSleepDrainPerHr: null == deepSleepDrainPerHr
          ? _value.deepSleepDrainPerHr
          : deepSleepDrainPerHr // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DischargeStatsImpl implements _DischargeStats {
  const _$DischargeStatsImpl(
      {required this.screenOnDrainPerHr,
      required this.screenOffDrainPerHr,
      required this.deepSleepDrainPerHr});

  factory _$DischargeStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DischargeStatsImplFromJson(json);

  @override
  final double screenOnDrainPerHr;
  @override
  final double screenOffDrainPerHr;
  @override
  final double deepSleepDrainPerHr;

  @override
  String toString() {
    return 'DischargeStats(screenOnDrainPerHr: $screenOnDrainPerHr, screenOffDrainPerHr: $screenOffDrainPerHr, deepSleepDrainPerHr: $deepSleepDrainPerHr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DischargeStatsImpl &&
            (identical(other.screenOnDrainPerHr, screenOnDrainPerHr) ||
                other.screenOnDrainPerHr == screenOnDrainPerHr) &&
            (identical(other.screenOffDrainPerHr, screenOffDrainPerHr) ||
                other.screenOffDrainPerHr == screenOffDrainPerHr) &&
            (identical(other.deepSleepDrainPerHr, deepSleepDrainPerHr) ||
                other.deepSleepDrainPerHr == deepSleepDrainPerHr));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, screenOnDrainPerHr,
      screenOffDrainPerHr, deepSleepDrainPerHr);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DischargeStatsImplCopyWith<_$DischargeStatsImpl> get copyWith =>
      __$$DischargeStatsImplCopyWithImpl<_$DischargeStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DischargeStatsImplToJson(
      this,
    );
  }
}

abstract class _DischargeStats implements DischargeStats {
  const factory _DischargeStats(
      {required final double screenOnDrainPerHr,
      required final double screenOffDrainPerHr,
      required final double deepSleepDrainPerHr}) = _$DischargeStatsImpl;

  factory _DischargeStats.fromJson(Map<String, dynamic> json) =
      _$DischargeStatsImpl.fromJson;

  @override
  double get screenOnDrainPerHr;
  @override
  double get screenOffDrainPerHr;
  @override
  double get deepSleepDrainPerHr;
  @override
  @JsonKey(ignore: true)
  _$$DischargeStatsImplCopyWith<_$DischargeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
