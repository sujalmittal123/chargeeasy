import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_snapshot.freezed.dart';
part 'health_snapshot.g.dart';

@freezed
class HealthSnapshotModel with _$HealthSnapshotModel {
  const factory HealthSnapshotModel({
    required DateTime timestamp,
    required int estCapacityMah,
    required double healthPct,
    required int cycleCount,
  }) = _HealthSnapshotModel;

  factory HealthSnapshotModel.fromJson(Map<String, dynamic> json) => _$HealthSnapshotModelFromJson(json);
}
