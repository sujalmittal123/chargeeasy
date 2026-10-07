import 'package:flutter/services.dart';
import '../../domain/models/battery_reading.dart';
import '../../domain/models/app_drain_info.dart';


class BatteryService {
  static const EventChannel _eventChannel =
      EventChannel('chargetracker.app/battery_stream');
  static const MethodChannel _methodChannel =
      MethodChannel('chargetracker.app/battery_commands');

  // ── EventChannel stream ───────────────────────────────────────────────────
  Stream<BatteryReading> get batteryStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final m = Map<String, dynamic>.from(event as Map);

      // Status: Android constants → enum
      final statusInt = (m['status'] as int?) ?? 0;
      final status = _parseStatus(statusInt);

      // Plugged: 1=AC, 2=USB, 4=Wireless, 0=None
      final pluggedInt = (m['plugged'] as int?) ?? 0;
      final plugType = _parsePlugType(pluggedInt);

      // Health: Android constants → enum
      final healthInt = (m['health'] as int?) ?? 1;
      final health = _parseHealth(healthInt);

      final technology = (m['technology'] as String?) ?? 'Li-ion';
      final designCapacityMah = (m['designCapacityMah'] as int?) ?? 0;
      final chargeCounterUah = (m['chargeCounterUah'] as int?) ?? 0;
      final chargeTimeRemainingMs = (m['chargeTimeRemainingMs'] as int?) ??
          ((m['chargeTimeRemainingMs'] as num?)?.toInt() ?? -1);

      return BatteryReading(
        currentMa:              (m['currentMa'] as num?)?.toDouble() ?? 0.0,
        voltageMv:              (m['voltageMv'] as int?) ?? 0,
        temperatureC:           (m['temperatureC'] as num?)?.toDouble() ?? 0.0,
        percent:                (m['percent'] as int?) ?? 0,
        status:                 status,
        plugType:               plugType,
        health:                 health,
        technology:             technology.isNotEmpty ? technology : 'Li-ion',
        designCapacityMah:      designCapacityMah > 0 ? designCapacityMah : 0,
        chargeCounterUah:       chargeCounterUah,
        chargeTimeRemainingMs:  chargeTimeRemainingMs,
        timestamp:              DateTime.fromMillisecondsSinceEpoch(
                                  (m['timestamp'] as int?) ??
                                  DateTime.now().millisecondsSinceEpoch,),
      );
    });
  }

  // ── MethodChannel calls ───────────────────────────────────────────────────
  Future<int> getDesignCapacity() async =>
      await _methodChannel.invokeMethod<int>('getDesignCapacity') ?? -1;

  Future<bool> isForegroundServiceRunning() async =>
      await _methodChannel.invokeMethod<bool>('isForegroundServiceRunning') ?? false;

  Future<void> startForegroundService() =>
      _methodChannel.invokeMethod('startForegroundService');

  Future<void> stopForegroundService() =>
      _methodChannel.invokeMethod('stopForegroundService');

  Future<bool> toggleManualTracking() async =>
      await _methodChannel.invokeMethod<bool>('toggleManualTracking') ?? false;

  Future<void> setGuardMode(bool enabled) =>
      _methodChannel.invokeMethod('setGuardMode', enabled);

  Future<void> setAlarmThresholds(Map<String, dynamic> config) =>
      _methodChannel.invokeMethod('setAlarmThresholds', config);

  Future<void> calibrateCurrentSign(bool isPositiveWhenCharging) =>
      _methodChannel.invokeMethod('calibrateCurrentSign', isPositiveWhenCharging);

  Future<List<AppDrainInfo>> getUsageStats() async {
    final result =
        await _methodChannel.invokeMethod<List<dynamic>>('getUsageStats');
    if (result == null) return [];
    return result
        .map((e) => AppDrainInfo.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> requestIgnoreBatteryOptimizations() =>
      _methodChannel.invokeMethod('requestIgnoreBatteryOptimizations');

  Future<Map<String, dynamic>> checkOemOptimizationStatus() async {
    final result = await _methodChannel
        .invokeMethod<Map<dynamic, dynamic>>('checkOemOptimizationStatus');
    return result == null
        ? {}
        : Map<String, dynamic>.from(result);
  }

  // ── Enum parsers (Android BatteryManager integer constants) ──────────────
  static BatteryStatus _parseStatus(int v) => switch (v) {
        2 => BatteryStatus.charging,
        3 => BatteryStatus.discharging,
        4 => BatteryStatus.notCharging,
        5 => BatteryStatus.full,
        _ => BatteryStatus.unknown,
      };

  static PlugType _parsePlugType(int v) => switch (v) {
        1 => PlugType.ac,
        2 => PlugType.usb,
        4 => PlugType.wireless,
        _ => PlugType.none,
      };

  static BatteryHealth _parseHealth(int v) => switch (v) {
        2 => BatteryHealth.good,
        3 => BatteryHealth.overheat,
        4 => BatteryHealth.dead,
        6 => BatteryHealth.overVoltage,
        _ => BatteryHealth.unspecified,
      };
}
