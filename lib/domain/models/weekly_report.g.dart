// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyReportImpl _$$WeeklyReportImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyReportImpl(
      avgSpeedW: (json['avgSpeedW'] as num).toDouble(),
      timesChargedTo100: (json['timesChargedTo100'] as num).toInt(),
      timesOverLimit: (json['timesOverLimit'] as num).toInt(),
      avgMaxTempC: (json['avgMaxTempC'] as num).toDouble(),
      totalChargeEnergyWh: (json['totalChargeEnergyWh'] as num).toDouble(),
      insights:
          (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$WeeklyReportImplToJson(_$WeeklyReportImpl instance) =>
    <String, dynamic>{
      'avgSpeedW': instance.avgSpeedW,
      'timesChargedTo100': instance.timesChargedTo100,
      'timesOverLimit': instance.timesOverLimit,
      'avgMaxTempC': instance.avgMaxTempC,
      'totalChargeEnergyWh': instance.totalChargeEnergyWh,
      'insights': instance.insights,
    };
