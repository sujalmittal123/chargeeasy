import 'package:flutter/services.dart';

class WidgetManagerService {
  static const _channel = MethodChannel('chargetracker.app/battery_commands');

  /// Check whether the current device launcher supports programmatically pinning app widgets
  Future<bool> isPinningSupported() async {
    try {
      final res = await _channel.invokeMethod<bool>('isPinningSupported');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Request the OS launcher to pin the widget directly to the user's home screen
  /// [type] can be '2x1' (Compact Glass) or '4x2' (Pro Dashboard)
  Future<bool> requestPinWidget(String type) async {
    try {
      final res = await _channel.invokeMethod<bool>('requestPinWidget', {'type': type});
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Set the transparent glass theme for all active home screen widgets
  Future<bool> setWidgetTransparentTheme(bool isTransparent) async {
    try {
      final res = await _channel.invokeMethod<bool>(
        'setWidgetTransparentTheme',
        {'isTransparent': isTransparent},
      );
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Get current widget theme mode (true = transparent glass, false = obsidian glass)
  Future<bool> getWidgetTransparentTheme() async {
    try {
      final res = await _channel.invokeMethod<bool>('getWidgetTransparentTheme');
      return res ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Push current live telemetry from Flutter to active home screen widgets
  Future<void> syncWidgetData({
    required int percent,
    required int currentMa,
    required double watts,
    required double temperatureC,
    required double voltageV,
    required String health,
    required bool isCharging,
    String? estimate,
  }) async {
    try {
      await _channel.invokeMethod('syncWidgetData', {
        'percent': percent,
        'currentMa': currentMa,
        'watts': watts,
        'temperatureC': temperatureC,
        'voltageV': voltageV,
        'health': health,
        'isCharging': isCharging,
        if (estimate != null) 'estimate': estimate,
      });
    } catch (_) {
      // Ignore sync errors
    }
  }

  /// Force an immediate refresh of all home screen widgets
  Future<void> refreshWidgets() async {
    try {
      await _channel.invokeMethod('refreshWidgets');
    } catch (_) {
      // Ignore
    }
  }
}
