// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BatteryReadingImpl _$$BatteryReadingImplFromJson(Map<String, dynamic> json) =>
    _$BatteryReadingImpl(
      currentMa: (json['currentMa'] as num).toDouble(),
      voltageMv: (json['voltageMv'] as num).toInt(),
      temperatureC: (json['temperatureC'] as num).toDouble(),
      percent: (json['percent'] as num).toInt(),
      status: $enumDecode(_$BatteryStatusEnumMap, json['status']),
      plugType: $enumDecode(_$PlugTypeEnumMap, json['plugType']),
      health: $enumDecode(_$BatteryHealthEnumMap, json['health']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$BatteryReadingImplToJson(
        _$BatteryReadingImpl instance) =>
    <String, dynamic>{
      'currentMa': instance.currentMa,
      'voltageMv': instance.voltageMv,
      'temperatureC': instance.temperatureC,
      'percent': instance.percent,
      'status': _$BatteryStatusEnumMap[instance.status]!,
      'plugType': _$PlugTypeEnumMap[instance.plugType]!,
      'health': _$BatteryHealthEnumMap[instance.health]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$BatteryStatusEnumMap = {
  BatteryStatus.charging: 'charging',
  BatteryStatus.discharging: 'discharging',
  BatteryStatus.full: 'full',
  BatteryStatus.notCharging: 'notCharging',
  BatteryStatus.unknown: 'unknown',
};

const _$PlugTypeEnumMap = {
  PlugType.ac: 'ac',
  PlugType.usb: 'usb',
  PlugType.wireless: 'wireless',
  PlugType.none: 'none',
};

const _$BatteryHealthEnumMap = {
  BatteryHealth.good: 'good',
  BatteryHealth.overheat: 'overheat',
  BatteryHealth.dead: 'dead',
  BatteryHealth.overVoltage: 'overVoltage',
  BatteryHealth.unspecified: 'unspecified',
};
