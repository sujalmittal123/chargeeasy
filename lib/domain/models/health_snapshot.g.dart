// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthSnapshotModelImpl _$$HealthSnapshotModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthSnapshotModelImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      estCapacityMah: (json['estCapacityMah'] as num).toInt(),
      healthPct: (json['healthPct'] as num).toDouble(),
      cycleCount: (json['cycleCount'] as num).toInt(),
    );

Map<String, dynamic> _$$HealthSnapshotModelImplToJson(
        _$HealthSnapshotModelImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'estCapacityMah': instance.estCapacityMah,
      'healthPct': instance.healthPct,
      'cycleCount': instance.cycleCount,
    };
