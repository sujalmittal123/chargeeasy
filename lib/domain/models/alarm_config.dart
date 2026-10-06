import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_config.freezed.dart';
part 'alarm_config.g.dart';

@freezed
class AlarmConfig with _$AlarmConfig {
  const factory AlarmConfig({
    required bool enabled,
    required int targetPercent,
    required double maxTempC,
    required bool playSound,
    required bool vibrate,
  }) = _AlarmConfig;

  factory AlarmConfig.fromJson(Map<String, dynamic> json) => _$AlarmConfigFromJson(json);
}
