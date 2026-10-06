// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DischargeStatsImpl _$$DischargeStatsImplFromJson(Map<String, dynamic> json) =>
    _$DischargeStatsImpl(
      screenOnDrainPerHr: (json['screenOnDrainPerHr'] as num).toDouble(),
      screenOffDrainPerHr: (json['screenOffDrainPerHr'] as num).toDouble(),
      deepSleepDrainPerHr: (json['deepSleepDrainPerHr'] as num).toDouble(),
    );

Map<String, dynamic> _$$DischargeStatsImplToJson(
        _$DischargeStatsImpl instance) =>
    <String, dynamic>{
      'screenOnDrainPerHr': instance.screenOnDrainPerHr,
      'screenOffDrainPerHr': instance.screenOffDrainPerHr,
      'deepSleepDrainPerHr': instance.deepSleepDrainPerHr,
    };
