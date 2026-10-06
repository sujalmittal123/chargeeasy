// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlarmConfigImpl _$$AlarmConfigImplFromJson(Map<String, dynamic> json) =>
    _$AlarmConfigImpl(
      enabled: json['enabled'] as bool,
      targetPercent: (json['targetPercent'] as num).toInt(),
      maxTempC: (json['maxTempC'] as num).toDouble(),
      playSound: json['playSound'] as bool,
      vibrate: json['vibrate'] as bool,
    );

Map<String, dynamic> _$$AlarmConfigImplToJson(_$AlarmConfigImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'targetPercent': instance.targetPercent,
      'maxTempC': instance.maxTempC,
      'playSound': instance.playSound,
      'vibrate': instance.vibrate,
    };
