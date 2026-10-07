import 'package:freezed_annotation/freezed_annotation.dart';

part 'battery_reading.freezed.dart';
part 'battery_reading.g.dart';

enum BatteryStatus { charging, discharging, full, notCharging, unknown }
enum PlugType { ac, usb, wireless, none }
enum BatteryHealth { good, overheat, dead, overVoltage, unspecified }

@freezed
class BatteryReading with _$BatteryReading {
  const BatteryReading._();

  const factory BatteryReading({
    required double currentMa,
    required int voltageMv,
    required double temperatureC,
    required int percent,
    required BatteryStatus status,
    required PlugType plugType,
    required BatteryHealth health,
    required DateTime timestamp,
    @Default('Li-ion') String technology,
    @Default(0) int designCapacityMah,
    @Default(0) int chargeCounterUah,
    @Default(-1) int chargeTimeRemainingMs,
  }) = _BatteryReading;

  factory BatteryReading.fromJson(Map<String, dynamic> json) => _$BatteryReadingFromJson(json);

  double get powerW => (currentMa * voltageMv) / 1000000;
  
  String get chargeLevelLabel {
    if (powerW < 5) return 'slow';
    if (powerW < 15) return 'normal';
    if (powerW < 25) return 'fast';
    return 'superFast';
  }
}
