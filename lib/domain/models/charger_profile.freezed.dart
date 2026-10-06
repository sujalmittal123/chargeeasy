// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'charger_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChargerProfile _$ChargerProfileFromJson(Map<String, dynamic> json) {
  return _ChargerProfile.fromJson(json);
}

/// @nodoc
mixin _$ChargerProfile {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get ratedW => throw _privateConstructorUsedError;
  double? get avgScore => throw _privateConstructorUsedError;
  int get sessionsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChargerProfileCopyWith<ChargerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChargerProfileCopyWith<$Res> {
  factory $ChargerProfileCopyWith(
          ChargerProfile value, $Res Function(ChargerProfile) then) =
      _$ChargerProfileCopyWithImpl<$Res, ChargerProfile>;
  @useResult
  $Res call(
      {int id,
      String name,
      double ratedW,
      double? avgScore,
      int sessionsCount});
}

/// @nodoc
class _$ChargerProfileCopyWithImpl<$Res, $Val extends ChargerProfile>
    implements $ChargerProfileCopyWith<$Res> {
  _$ChargerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ratedW = null,
    Object? avgScore = freezed,
    Object? sessionsCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ratedW: null == ratedW
          ? _value.ratedW
          : ratedW // ignore: cast_nullable_to_non_nullable
              as double,
      avgScore: freezed == avgScore
          ? _value.avgScore
          : avgScore // ignore: cast_nullable_to_non_nullable
              as double?,
      sessionsCount: null == sessionsCount
          ? _value.sessionsCount
          : sessionsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChargerProfileImplCopyWith<$Res>
    implements $ChargerProfileCopyWith<$Res> {
  factory _$$ChargerProfileImplCopyWith(_$ChargerProfileImpl value,
          $Res Function(_$ChargerProfileImpl) then) =
      __$$ChargerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      double ratedW,
      double? avgScore,
      int sessionsCount});
}

/// @nodoc
class __$$ChargerProfileImplCopyWithImpl<$Res>
    extends _$ChargerProfileCopyWithImpl<$Res, _$ChargerProfileImpl>
    implements _$$ChargerProfileImplCopyWith<$Res> {
  __$$ChargerProfileImplCopyWithImpl(
      _$ChargerProfileImpl _value, $Res Function(_$ChargerProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ratedW = null,
    Object? avgScore = freezed,
    Object? sessionsCount = null,
  }) {
    return _then(_$ChargerProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ratedW: null == ratedW
          ? _value.ratedW
          : ratedW // ignore: cast_nullable_to_non_nullable
              as double,
      avgScore: freezed == avgScore
          ? _value.avgScore
          : avgScore // ignore: cast_nullable_to_non_nullable
              as double?,
      sessionsCount: null == sessionsCount
          ? _value.sessionsCount
          : sessionsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChargerProfileImpl implements _ChargerProfile {
  const _$ChargerProfileImpl(
      {required this.id,
      required this.name,
      required this.ratedW,
      this.avgScore,
      required this.sessionsCount});

  factory _$ChargerProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChargerProfileImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final double ratedW;
  @override
  final double? avgScore;
  @override
  final int sessionsCount;

  @override
  String toString() {
    return 'ChargerProfile(id: $id, name: $name, ratedW: $ratedW, avgScore: $avgScore, sessionsCount: $sessionsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargerProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ratedW, ratedW) || other.ratedW == ratedW) &&
            (identical(other.avgScore, avgScore) ||
                other.avgScore == avgScore) &&
            (identical(other.sessionsCount, sessionsCount) ||
                other.sessionsCount == sessionsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, ratedW, avgScore, sessionsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargerProfileImplCopyWith<_$ChargerProfileImpl> get copyWith =>
      __$$ChargerProfileImplCopyWithImpl<_$ChargerProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChargerProfileImplToJson(
      this,
    );
  }
}

abstract class _ChargerProfile implements ChargerProfile {
  const factory _ChargerProfile(
      {required final int id,
      required final String name,
      required final double ratedW,
      final double? avgScore,
      required final int sessionsCount}) = _$ChargerProfileImpl;

  factory _ChargerProfile.fromJson(Map<String, dynamic> json) =
      _$ChargerProfileImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  double get ratedW;
  @override
  double? get avgScore;
  @override
  int get sessionsCount;
  @override
  @JsonKey(ignore: true)
  _$$ChargerProfileImplCopyWith<_$ChargerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
