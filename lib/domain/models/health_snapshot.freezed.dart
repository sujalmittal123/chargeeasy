// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HealthSnapshotModel _$HealthSnapshotModelFromJson(Map<String, dynamic> json) {
  return _HealthSnapshotModel.fromJson(json);
}

/// @nodoc
mixin _$HealthSnapshotModel {
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get estCapacityMah => throw _privateConstructorUsedError;
  double get healthPct => throw _privateConstructorUsedError;
  int get cycleCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HealthSnapshotModelCopyWith<HealthSnapshotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthSnapshotModelCopyWith<$Res> {
  factory $HealthSnapshotModelCopyWith(
          HealthSnapshotModel value, $Res Function(HealthSnapshotModel) then) =
      _$HealthSnapshotModelCopyWithImpl<$Res, HealthSnapshotModel>;
  @useResult
  $Res call(
      {DateTime timestamp,
      int estCapacityMah,
      double healthPct,
      int cycleCount});
}

/// @nodoc
class _$HealthSnapshotModelCopyWithImpl<$Res, $Val extends HealthSnapshotModel>
    implements $HealthSnapshotModelCopyWith<$Res> {
  _$HealthSnapshotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? estCapacityMah = null,
    Object? healthPct = null,
    Object? cycleCount = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      estCapacityMah: null == estCapacityMah
          ? _value.estCapacityMah
          : estCapacityMah // ignore: cast_nullable_to_non_nullable
              as int,
      healthPct: null == healthPct
          ? _value.healthPct
          : healthPct // ignore: cast_nullable_to_non_nullable
              as double,
      cycleCount: null == cycleCount
          ? _value.cycleCount
          : cycleCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthSnapshotModelImplCopyWith<$Res>
    implements $HealthSnapshotModelCopyWith<$Res> {
  factory _$$HealthSnapshotModelImplCopyWith(_$HealthSnapshotModelImpl value,
          $Res Function(_$HealthSnapshotModelImpl) then) =
      __$$HealthSnapshotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      int estCapacityMah,
      double healthPct,
      int cycleCount});
}

/// @nodoc
class __$$HealthSnapshotModelImplCopyWithImpl<$Res>
    extends _$HealthSnapshotModelCopyWithImpl<$Res, _$HealthSnapshotModelImpl>
    implements _$$HealthSnapshotModelImplCopyWith<$Res> {
  __$$HealthSnapshotModelImplCopyWithImpl(_$HealthSnapshotModelImpl _value,
      $Res Function(_$HealthSnapshotModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? estCapacityMah = null,
    Object? healthPct = null,
    Object? cycleCount = null,
  }) {
    return _then(_$HealthSnapshotModelImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      estCapacityMah: null == estCapacityMah
          ? _value.estCapacityMah
          : estCapacityMah // ignore: cast_nullable_to_non_nullable
              as int,
      healthPct: null == healthPct
          ? _value.healthPct
          : healthPct // ignore: cast_nullable_to_non_nullable
              as double,
      cycleCount: null == cycleCount
          ? _value.cycleCount
          : cycleCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthSnapshotModelImpl implements _HealthSnapshotModel {
  const _$HealthSnapshotModelImpl(
      {required this.timestamp,
      required this.estCapacityMah,
      required this.healthPct,
      required this.cycleCount});

  factory _$HealthSnapshotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthSnapshotModelImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final int estCapacityMah;
  @override
  final double healthPct;
  @override
  final int cycleCount;

  @override
  String toString() {
    return 'HealthSnapshotModel(timestamp: $timestamp, estCapacityMah: $estCapacityMah, healthPct: $healthPct, cycleCount: $cycleCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthSnapshotModelImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.estCapacityMah, estCapacityMah) ||
                other.estCapacityMah == estCapacityMah) &&
            (identical(other.healthPct, healthPct) ||
                other.healthPct == healthPct) &&
            (identical(other.cycleCount, cycleCount) ||
                other.cycleCount == cycleCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, timestamp, estCapacityMah, healthPct, cycleCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthSnapshotModelImplCopyWith<_$HealthSnapshotModelImpl> get copyWith =>
      __$$HealthSnapshotModelImplCopyWithImpl<_$HealthSnapshotModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthSnapshotModelImplToJson(
      this,
    );
  }
}

abstract class _HealthSnapshotModel implements HealthSnapshotModel {
  const factory _HealthSnapshotModel(
      {required final DateTime timestamp,
      required final int estCapacityMah,
      required final double healthPct,
      required final int cycleCount}) = _$HealthSnapshotModelImpl;

  factory _HealthSnapshotModel.fromJson(Map<String, dynamic> json) =
      _$HealthSnapshotModelImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  int get estCapacityMah;
  @override
  double get healthPct;
  @override
  int get cycleCount;
  @override
  @JsonKey(ignore: true)
  _$$HealthSnapshotModelImplCopyWith<_$HealthSnapshotModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
