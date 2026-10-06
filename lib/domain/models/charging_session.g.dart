// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charging_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargingSessionImpl _$$ChargingSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$ChargingSessionImpl(
      id: (json['id'] as num).toInt(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      startPercent: (json['startPercent'] as num).toInt(),
      endPercent: (json['endPercent'] as num?)?.toInt(),
      avgPowerW: (json['avgPowerW'] as num?)?.toDouble(),
      peakPowerW: (json['peakPowerW'] as num?)?.toDouble(),
      maxTempC: (json['maxTempC'] as num?)?.toDouble(),
      chargerId: (json['chargerId'] as num?)?.toInt(),
      chargerType: json['chargerType'] as String,
    );

Map<String, dynamic> _$$ChargingSessionImplToJson(
        _$ChargingSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'startPercent': instance.startPercent,
      'endPercent': instance.endPercent,
      'avgPowerW': instance.avgPowerW,
      'peakPowerW': instance.peakPowerW,
      'maxTempC': instance.maxTempC,
      'chargerId': instance.chargerId,
      'chargerType': instance.chargerType,
    };
