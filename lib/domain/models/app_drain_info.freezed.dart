// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_drain_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppDrainInfo _$AppDrainInfoFromJson(Map<String, dynamic> json) {
  return _AppDrainInfo.fromJson(json);
}

/// @nodoc
mixin _$AppDrainInfo {
  String get packageName => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;
  double get energyConsumedMah => throw _privateConstructorUsedError;
  double get percentOfTotal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppDrainInfoCopyWith<AppDrainInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDrainInfoCopyWith<$Res> {
  factory $AppDrainInfoCopyWith(
          AppDrainInfo value, $Res Function(AppDrainInfo) then) =
      _$AppDrainInfoCopyWithImpl<$Res, AppDrainInfo>;
  @useResult
  $Res call(
      {String packageName,
      String appName,
      double energyConsumedMah,
      double percentOfTotal});
}

/// @nodoc
class _$AppDrainInfoCopyWithImpl<$Res, $Val extends AppDrainInfo>
    implements $AppDrainInfoCopyWith<$Res> {
  _$AppDrainInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? appName = null,
    Object? energyConsumedMah = null,
    Object? percentOfTotal = null,
  }) {
    return _then(_value.copyWith(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      energyConsumedMah: null == energyConsumedMah
          ? _value.energyConsumedMah
          : energyConsumedMah // ignore: cast_nullable_to_non_nullable
              as double,
      percentOfTotal: null == percentOfTotal
          ? _value.percentOfTotal
          : percentOfTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppDrainInfoImplCopyWith<$Res>
    implements $AppDrainInfoCopyWith<$Res> {
  factory _$$AppDrainInfoImplCopyWith(
          _$AppDrainInfoImpl value, $Res Function(_$AppDrainInfoImpl) then) =
      __$$AppDrainInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String packageName,
      String appName,
      double energyConsumedMah,
      double percentOfTotal});
}

/// @nodoc
class __$$AppDrainInfoImplCopyWithImpl<$Res>
    extends _$AppDrainInfoCopyWithImpl<$Res, _$AppDrainInfoImpl>
    implements _$$AppDrainInfoImplCopyWith<$Res> {
  __$$AppDrainInfoImplCopyWithImpl(
      _$AppDrainInfoImpl _value, $Res Function(_$AppDrainInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? appName = null,
    Object? energyConsumedMah = null,
    Object? percentOfTotal = null,
  }) {
    return _then(_$AppDrainInfoImpl(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      energyConsumedMah: null == energyConsumedMah
          ? _value.energyConsumedMah
          : energyConsumedMah // ignore: cast_nullable_to_non_nullable
              as double,
      percentOfTotal: null == percentOfTotal
          ? _value.percentOfTotal
          : percentOfTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppDrainInfoImpl implements _AppDrainInfo {
  const _$AppDrainInfoImpl(
      {required this.packageName,
      required this.appName,
      required this.energyConsumedMah,
      required this.percentOfTotal});

  factory _$AppDrainInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppDrainInfoImplFromJson(json);

  @override
  final String packageName;
  @override
  final String appName;
  @override
  final double energyConsumedMah;
  @override
  final double percentOfTotal;

  @override
  String toString() {
    return 'AppDrainInfo(packageName: $packageName, appName: $appName, energyConsumedMah: $energyConsumedMah, percentOfTotal: $percentOfTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDrainInfoImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.energyConsumedMah, energyConsumedMah) ||
                other.energyConsumedMah == energyConsumedMah) &&
            (identical(other.percentOfTotal, percentOfTotal) ||
                other.percentOfTotal == percentOfTotal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, packageName, appName, energyConsumedMah, percentOfTotal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDrainInfoImplCopyWith<_$AppDrainInfoImpl> get copyWith =>
      __$$AppDrainInfoImplCopyWithImpl<_$AppDrainInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppDrainInfoImplToJson(
      this,
    );
  }
}

abstract class _AppDrainInfo implements AppDrainInfo {
  const factory _AppDrainInfo(
      {required final String packageName,
      required final String appName,
      required final double energyConsumedMah,
      required final double percentOfTotal}) = _$AppDrainInfoImpl;

  factory _AppDrainInfo.fromJson(Map<String, dynamic> json) =
      _$AppDrainInfoImpl.fromJson;

  @override
  String get packageName;
  @override
  String get appName;
  @override
  double get energyConsumedMah;
  @override
  double get percentOfTotal;
  @override
  @JsonKey(ignore: true)
  _$$AppDrainInfoImplCopyWith<_$AppDrainInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
