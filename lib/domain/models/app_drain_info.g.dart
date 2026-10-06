// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_drain_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppDrainInfoImpl _$$AppDrainInfoImplFromJson(Map<String, dynamic> json) =>
    _$AppDrainInfoImpl(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      energyConsumedMah: (json['energyConsumedMah'] as num).toDouble(),
      percentOfTotal: (json['percentOfTotal'] as num).toDouble(),
    );

Map<String, dynamic> _$$AppDrainInfoImplToJson(_$AppDrainInfoImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'appName': instance.appName,
      'energyConsumedMah': instance.energyConsumedMah,
      'percentOfTotal': instance.percentOfTotal,
    };
