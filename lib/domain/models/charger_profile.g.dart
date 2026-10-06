// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charger_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargerProfileImpl _$$ChargerProfileImplFromJson(Map<String, dynamic> json) =>
    _$ChargerProfileImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      ratedW: (json['ratedW'] as num).toDouble(),
      avgScore: (json['avgScore'] as num?)?.toDouble(),
      sessionsCount: (json['sessionsCount'] as num).toInt(),
    );

Map<String, dynamic> _$$ChargerProfileImplToJson(
        _$ChargerProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ratedW': instance.ratedW,
      'avgScore': instance.avgScore,
      'sessionsCount': instance.sessionsCount,
    };
