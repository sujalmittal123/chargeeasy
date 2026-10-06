import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings_provider.dart';
import '../../../data/services/battery_service.dart';

class AlarmsScreen extends ConsumerStatefulWidget {
  const AlarmsScreen({super.key});

  @override
  ConsumerState<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends ConsumerState<AlarmsScreen> {
  bool fullCharge = true;
  bool customLimit = true;
  double customLimitValue = 80;
  bool overheat = true;
  double overheatValue = 42;
  bool lowBattery = true;
  double lowBatteryValue = 15;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    customLimit = settings.chargeLimitEnabled;
    customLimitValue = settings.chargeLimitPct.toDouble();
    overheatValue = settings.overheatThresholdC;
    lowBattery = settings.lowBatteryEnabled;
    lowBatteryValue = settings.lowBatteryPct.toDouble();
  }

  void _syncThresholds() {
    BatteryService().setAlarmThresholds({
      'charge_limit': customLimitValue.toInt(),
      'charge_limit_enabled': customLimit,
      'max_temp': overheatValue,
      'low_battery_threshold': lowBatteryValue.toInt(),
      'low_battery_enabled': lowBattery,
    });
    ref.read(settingsProvider.notifier).setChargeLimit(customLimitValue.toInt());
    ref.read(settingsProvider.notifier).setOverheatThreshold(overheatValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alarms & Alerts')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildToggleCard(
            title: 'Full Charge Alert (100%)',
            subtitle: 'Notify with sound & vibration when fully charged',
            icon: Icons.battery_full,
            value: fullCharge,
            onChanged: (v) {
              setState(() => fullCharge = v);
              _syncThresholds();
            },
          ),
          _buildSliderCard(
            title: 'Custom Charge Limit',
            subtitle: 'Recommended: 80% to maximize lithium battery lifespan',
            icon: Icons.battery_charging_full,
            value: customLimit,
            onChanged: (v) {
              setState(() => customLimit = v);
              _syncThresholds();
            },
            sliderValue: customLimitValue,
            min: 60,
            max: 95,
            unit: '%',
            onSliderChanged: (v) {
              setState(() => customLimitValue = v);
              _syncThresholds();
            },
          ),
          _buildSliderCard(
            title: 'Overheat Safety Guard',
            subtitle: 'Triggers notification if temp stays above threshold for 60s',
            icon: Icons.thermostat,
            value: overheat,
            onChanged: (v) {
              setState(() => overheat = v);
              _syncThresholds();
            },
            sliderValue: overheatValue,
            min: 38,
            max: 50,
            unit: '°C',
            onSliderChanged: (v) {
              setState(() => overheatValue = v);
              _syncThresholds();
            },
          ),
          _buildSliderCard(
            title: 'Low Battery Alert',
            subtitle: 'Prompt to plug in before deep discharge occurs',
            icon: Icons.battery_alert,
            value: lowBattery,
            onChanged: (v) {
              setState(() => lowBattery = v);
              _syncThresholds();
            },
            sliderValue: lowBatteryValue,
            min: 5,
            max: 25,
            unit: '%',
            onSliderChanged: (v) {
              setState(() => lowBatteryValue = v);
              _syncThresholds();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 30, color: const Color(0xFF00E5FF)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required double sliderValue,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onSliderChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, size: 30, color: const Color(0xFF00E5FF)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '${sliderValue.toInt()}$unit',
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
              trailing: Switch(value: value, onChanged: onChanged),
            ),
            if (value)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Slider(
                  value: sliderValue,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  label: '${sliderValue.toInt()}$unit',
                  onChanged: onSliderChanged,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
