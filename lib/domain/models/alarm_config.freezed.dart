// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlarmConfig _$AlarmConfigFromJson(Map<String, dynamic> json) {
  return _AlarmConfig.fromJson(json);
}

/// @nodoc
mixin _$AlarmConfig {
  bool get enabled => throw _privateConstructorUsedError;
  int get targetPercent => throw _privateConstructorUsedError;
  double get maxTempC => throw _privateConstructorUsedError;
  bool get playSound => throw _privateConstructorUsedError;
  bool get vibrate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlarmConfigCopyWith<AlarmConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmConfigCopyWith<$Res> {
  factory $AlarmConfigCopyWith(
          AlarmConfig value, $Res Function(AlarmConfig) then) =
      _$AlarmConfigCopyWithImpl<$Res, AlarmConfig>;
  @useResult
  $Res call(
      {bool enabled,
      int targetPercent,
      double maxTempC,
      bool playSound,
      bool vibrate});
}

/// @nodoc
class _$AlarmConfigCopyWithImpl<$Res, $Val extends AlarmConfig>
    implements $AlarmConfigCopyWith<$Res> {
  _$AlarmConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? targetPercent = null,
    Object? maxTempC = null,
    Object? playSound = null,
    Object? vibrate = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      targetPercent: null == targetPercent
          ? _value.targetPercent
          : targetPercent // ignore: cast_nullable_to_non_nullable
              as int,
      maxTempC: null == maxTempC
          ? _value.maxTempC
          : maxTempC // ignore: cast_nullable_to_non_nullable
              as double,
      playSound: null == playSound
          ? _value.playSound
          : playSound // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrate: null == vibrate
          ? _value.vibrate
          : vibrate // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlarmConfigImplCopyWith<$Res>
    implements $AlarmConfigCopyWith<$Res> {
  factory _$$AlarmConfigImplCopyWith(
          _$AlarmConfigImpl value, $Res Function(_$AlarmConfigImpl) then) =
      __$$AlarmConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      int targetPercent,
      double maxTempC,
      bool playSound,
      bool vibrate});
}

/// @nodoc
class __$$AlarmConfigImplCopyWithImpl<$Res>
    extends _$AlarmConfigCopyWithImpl<$Res, _$AlarmConfigImpl>
    implements _$$AlarmConfigImplCopyWith<$Res> {
  __$$AlarmConfigImplCopyWithImpl(
      _$AlarmConfigImpl _value, $Res Function(_$AlarmConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? targetPercent = null,
    Object? maxTempC = null,
    Object? playSound = null,
    Object? vibrate = null,
  }) {
    return _then(_$AlarmConfigImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      targetPercent: null == targetPercent
          ? _value.targetPercent
          : targetPercent // ignore: cast_nullable_to_non_nullable
              as int,
      maxTempC: null == maxTempC
          ? _value.maxTempC
          : maxTempC // ignore: cast_nullable_to_non_nullable
              as double,
      playSound: null == playSound
          ? _value.playSound
          : playSound // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrate: null == vibrate
          ? _value.vibrate
          : vibrate // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlarmConfigImpl implements _AlarmConfig {
  const _$AlarmConfigImpl(
      {required this.enabled,
      required this.targetPercent,
      required this.maxTempC,
      required this.playSound,
      required this.vibrate});

  factory _$AlarmConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlarmConfigImplFromJson(json);

  @override
  final bool enabled;
  @override
  final int targetPercent;
  @override
  final double maxTempC;
  @override
  final bool playSound;
  @override
  final bool vibrate;

  @override
  String toString() {
    return 'AlarmConfig(enabled: $enabled, targetPercent: $targetPercent, maxTempC: $maxTempC, playSound: $playSound, vibrate: $vibrate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmConfigImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.targetPercent, targetPercent) ||
                other.targetPercent == targetPercent) &&
            (identical(other.maxTempC, maxTempC) ||
                other.maxTempC == maxTempC) &&
            (identical(other.playSound, playSound) ||
                other.playSound == playSound) &&
            (identical(other.vibrate, vibrate) || other.vibrate == vibrate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, enabled, targetPercent, maxTempC, playSound, vibrate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmConfigImplCopyWith<_$AlarmConfigImpl> get copyWith =>
      __$$AlarmConfigImplCopyWithImpl<_$AlarmConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlarmConfigImplToJson(
      this,
    );
  }
}

abstract class _AlarmConfig implements AlarmConfig {
  const factory _AlarmConfig(
      {required final bool enabled,
      required final int targetPercent,
      required final double maxTempC,
      required final bool playSound,
      required final bool vibrate}) = _$AlarmConfigImpl;

  factory _AlarmConfig.fromJson(Map<String, dynamic> json) =
      _$AlarmConfigImpl.fromJson;

  @override
  bool get enabled;
  @override
  int get targetPercent;
  @override
  double get maxTempC;
  @override
  bool get playSound;
  @override
  bool get vibrate;
  @override
  @JsonKey(ignore: true)
  _$$AlarmConfigImplCopyWith<_$AlarmConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
