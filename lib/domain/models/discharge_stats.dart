import 'package:freezed_annotation/freezed_annotation.dart';

part 'discharge_stats.freezed.dart';
part 'discharge_stats.g.dart';

@freezed
class DischargeStats with _$DischargeStats {
  const factory DischargeStats({
    required double screenOnDrainPerHr,
    required double screenOffDrainPerHr,
    required double deepSleepDrainPerHr,
  }) = _DischargeStats;

  factory DischargeStats.fromJson(Map<String, dynamic> json) => _$DischargeStatsFromJson(json);
}
