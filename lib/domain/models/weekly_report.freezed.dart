// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyReport _$WeeklyReportFromJson(Map<String, dynamic> json) {
  return _WeeklyReport.fromJson(json);
}

/// @nodoc
mixin _$WeeklyReport {
  double get avgSpeedW => throw _privateConstructorUsedError;
  int get timesChargedTo100 => throw _privateConstructorUsedError;
  int get timesOverLimit => throw _privateConstructorUsedError;
  double get avgMaxTempC => throw _privateConstructorUsedError;
  double get totalChargeEnergyWh => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyReportCopyWith<WeeklyReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyReportCopyWith<$Res> {
  factory $WeeklyReportCopyWith(
          WeeklyReport value, $Res Function(WeeklyReport) then) =
      _$WeeklyReportCopyWithImpl<$Res, WeeklyReport>;
  @useResult
  $Res call(
      {double avgSpeedW,
      int timesChargedTo100,
      int timesOverLimit,
      double avgMaxTempC,
      double totalChargeEnergyWh,
      List<String> insights});
}

/// @nodoc
class _$WeeklyReportCopyWithImpl<$Res, $Val extends WeeklyReport>
    implements $WeeklyReportCopyWith<$Res> {
  _$WeeklyReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgSpeedW = null,
    Object? timesChargedTo100 = null,
    Object? timesOverLimit = null,
    Object? avgMaxTempC = null,
    Object? totalChargeEnergyWh = null,
    Object? insights = null,
  }) {
    return _then(_value.copyWith(
      avgSpeedW: null == avgSpeedW
          ? _value.avgSpeedW
          : avgSpeedW // ignore: cast_nullable_to_non_nullable
              as double,
      timesChargedTo100: null == timesChargedTo100
          ? _value.timesChargedTo100
          : timesChargedTo100 // ignore: cast_nullable_to_non_nullable
              as int,
      timesOverLimit: null == timesOverLimit
          ? _value.timesOverLimit
          : timesOverLimit // ignore: cast_nullable_to_non_nullable
              as int,
      avgMaxTempC: null == avgMaxTempC
          ? _value.avgMaxTempC
          : avgMaxTempC // ignore: cast_nullable_to_non_nullable
              as double,
      totalChargeEnergyWh: null == totalChargeEnergyWh
          ? _value.totalChargeEnergyWh
          : totalChargeEnergyWh // ignore: cast_nullable_to_non_nullable
              as double,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyReportImplCopyWith<$Res>
    implements $WeeklyReportCopyWith<$Res> {
  factory _$$WeeklyReportImplCopyWith(
          _$WeeklyReportImpl value, $Res Function(_$WeeklyReportImpl) then) =
      __$$WeeklyReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double avgSpeedW,
      int timesChargedTo100,
      int timesOverLimit,
      double avgMaxTempC,
      double totalChargeEnergyWh,
      List<String> insights});
}

/// @nodoc
class __$$WeeklyReportImplCopyWithImpl<$Res>
    extends _$WeeklyReportCopyWithImpl<$Res, _$WeeklyReportImpl>
    implements _$$WeeklyReportImplCopyWith<$Res> {
  __$$WeeklyReportImplCopyWithImpl(
      _$WeeklyReportImpl _value, $Res Function(_$WeeklyReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgSpeedW = null,
    Object? timesChargedTo100 = null,
    Object? timesOverLimit = null,
    Object? avgMaxTempC = null,
    Object? totalChargeEnergyWh = null,
    Object? insights = null,
  }) {
    return _then(_$WeeklyReportImpl(
      avgSpeedW: null == avgSpeedW
          ? _value.avgSpeedW
          : avgSpeedW // ignore: cast_nullable_to_non_nullable
              as double,
      timesChargedTo100: null == timesChargedTo100
          ? _value.timesChargedTo100
          : timesChargedTo100 // ignore: cast_nullable_to_non_nullable
              as int,
      timesOverLimit: null == timesOverLimit
          ? _value.timesOverLimit
          : timesOverLimit // ignore: cast_nullable_to_non_nullable
              as int,
      avgMaxTempC: null == avgMaxTempC
          ? _value.avgMaxTempC
          : avgMaxTempC // ignore: cast_nullable_to_non_nullable
              as double,
      totalChargeEnergyWh: null == totalChargeEnergyWh
          ? _value.totalChargeEnergyWh
          : totalChargeEnergyWh // ignore: cast_nullable_to_non_nullable
              as double,
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyReportImpl implements _WeeklyReport {
  const _$WeeklyReportImpl(
      {required this.avgSpeedW,
      required this.timesChargedTo100,
      required this.timesOverLimit,
      required this.avgMaxTempC,
      required this.totalChargeEnergyWh,
      required final List<String> insights})
      : _insights = insights;

  factory _$WeeklyReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyReportImplFromJson(json);

  @override
  final double avgSpeedW;
  @override
  final int timesChargedTo100;
  @override
  final int timesOverLimit;
  @override
  final double avgMaxTempC;
  @override
  final double totalChargeEnergyWh;
  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  String toString() {
    return 'WeeklyReport(avgSpeedW: $avgSpeedW, timesChargedTo100: $timesChargedTo100, timesOverLimit: $timesOverLimit, avgMaxTempC: $avgMaxTempC, totalChargeEnergyWh: $totalChargeEnergyWh, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyReportImpl &&
            (identical(other.avgSpeedW, avgSpeedW) ||
                other.avgSpeedW == avgSpeedW) &&
            (identical(other.timesChargedTo100, timesChargedTo100) ||
                other.timesChargedTo100 == timesChargedTo100) &&
            (identical(other.timesOverLimit, timesOverLimit) ||
                other.timesOverLimit == timesOverLimit) &&
            (identical(other.avgMaxTempC, avgMaxTempC) ||
                other.avgMaxTempC == avgMaxTempC) &&
            (identical(other.totalChargeEnergyWh, totalChargeEnergyWh) ||
                other.totalChargeEnergyWh == totalChargeEnergyWh) &&
            const DeepCollectionEquality().equals(other._insights, _insights));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      avgSpeedW,
      timesChargedTo100,
      timesOverLimit,
      avgMaxTempC,
      totalChargeEnergyWh,
      const DeepCollectionEquality().hash(_insights));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyReportImplCopyWith<_$WeeklyReportImpl> get copyWith =>
      __$$WeeklyReportImplCopyWithImpl<_$WeeklyReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyReportImplToJson(
      this,
    );
  }
}

abstract class _WeeklyReport implements WeeklyReport {
  const factory _WeeklyReport(
      {required final double avgSpeedW,
      required final int timesChargedTo100,
      required final int timesOverLimit,
      required final double avgMaxTempC,
      required final double totalChargeEnergyWh,
      required final List<String> insights}) = _$WeeklyReportImpl;

  factory _WeeklyReport.fromJson(Map<String, dynamic> json) =
      _$WeeklyReportImpl.fromJson;

  @override
  double get avgSpeedW;
  @override
  int get timesChargedTo100;
  @override
  int get timesOverLimit;
  @override
  double get avgMaxTempC;
  @override
  double get totalChargeEnergyWh;
  @override
  List<String> get insights;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyReportImplCopyWith<_$WeeklyReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
