import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings_provider.dart';
import '../../../providers/battery_provider.dart';
import '../../../data/services/battery_service.dart';

class CalibrationScreen extends ConsumerStatefulWidget {
  const CalibrationScreen({super.key});

  @override
  ConsumerState<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends ConsumerState<CalibrationScreen> {
  int _currentStep = 0;
  bool _isPositive = true;
  final String _detectedUnit = 'MicroAmperes (µA) auto-detected';
  final TextEditingController _capacityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialCapacity();
  }

  Future<void> _loadInitialCapacity() async {
    final settingsCap = ref.read(settingsProvider).valueOrNull?.designCapacityMah ?? 0;
    if (settingsCap > 0 && mounted) {
      setState(() {
        _capacityController.text = settingsCap.toString();
      });
      return;
    }
    final cap = await BatteryService().getDesignCapacity();
    if (cap > 0 && mounted) {
      setState(() {
        _capacityController.text = cap.toString();
      });
    }
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reading = ref.watch(batteryStreamProvider).valueOrNull;
    final currentStr = reading != null
        ? '${reading.currentMa >= 0 ? "+" : ""}${reading.currentMa.toInt()} mA'
        : 'Reading sensor...';

    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Calibration')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep < 4) {
            setState(() => _currentStep += 1);
          } else {
            // Save calibration results
            final cap = int.tryParse(_capacityController.text) ?? 0;
            if (cap > 0) {
              await ref.read(settingsProvider.notifier).setDesignCapacity(cap);
            }
            await BatteryService().calibrateCurrentSign(_isPositive);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calibration saved: $_detectedUnit, ${cap > 0 ? "${cap}mAh" : "no capacity set"}, sign: ${_isPositive ? "Positive" : "Inverted"}')),
              );
              Navigator.pop(context);
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        steps: [
          Step(
            title: const Text('Connect Charger'),
            content: const Text(
              'Connect your phone to a wall charger or USB cable. Charge Tracker needs live incoming current to calibrate current direction and sensor scale.',
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Current Sign Convention'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Some Android OEMs report charging as negative (-mA). Is charging shown positive on your device?'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: Color(0xFF00E5FF)),
                      const SizedBox(width: 8),
                      Text('Raw Sensor Value: $currentStr', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Positive (+) When Charging'),
                      selected: _isPositive,
                      onSelected: (v) => setState(() => _isPositive = true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Negative (-) When Charging'),
                      selected: !_isPositive,
                      onSelected: (v) => setState(() => _isPositive = false),
                    ),
                  ],
                ),
              ],
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Sensor Unit Detection'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Charge Tracker inspects |CURRENT_NOW|. Values >20,000 are microamps (µA) scaled down by 1,000 into mA.'),
                const SizedBox(height: 8),
                Text('Detected: $_detectedUnit', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Design Capacity (mAh)'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Detected from /sys/class/power_supply/battery/charge_full_design or enter manually:'),
                const SizedBox(height: 16),
                TextField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Design Capacity',
                    suffixText: 'mAh',
                  ),
                ),
              ],
            ),
            isActive: _currentStep >= 3,
          ),
          Step(
            title: const Text('Summary & Save'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ready to apply sensor calibration parameters:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('• Sign normalization: ${_isPositive ? "Positive (+)" : "Inverted (-)"}'),
                Text('• Scale: $_detectedUnit'),
                Text('• Design Capacity: ${_capacityController.text} mAh'),
              ],
            ),
            isActive: _currentStep >= 4,
          ),
        ],
      ),
    );
  }
}
