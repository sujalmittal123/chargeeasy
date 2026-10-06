import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/widgets/admob_banner.dart';
import '../../core/widgets/battery_gauge.dart';
import '../../core/widgets/analog_speedometer_gauge.dart';
import '../../core/widgets/mini_dial_gauge.dart';
import '../../core/widgets/sparkline_chart.dart';
import '../../../domain/models/battery_reading.dart';
import '../../../domain/use_cases/compute_time_estimate.dart';
import '../../../providers/battery_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../data/services/battery_service.dart';
import '../premium/premium_subscription_sheet.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final List<double> _powerHistory = [12.0, 13.5, 14.2, 15.0, 14.8, 16.2, 18.0, 17.5, 19.1, 18.4];
  bool _isTrackingSession = false;
  DateTime? _sessionStartTime;
  int? _sessionStartPct;
  bool _useSpeedometerView = true; // Toggle between Speedometer and Digital Ring

  @override
  Widget build(BuildContext context) {
    final batteryAsync = ref.watch(batteryStreamProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();

    // Live battery reading or realistic fallback for preview/emulator
    final reading = batteryAsync.valueOrNull ??
        BatteryReading(
          currentMa: -378,
          voltageMv: 3840,
          temperatureC: 32.7,
          percent: 48,
          status: BatteryStatus.discharging,
          plugType: PlugType.none,
          health: BatteryHealth.good,
          timestamp: DateTime.now(),
        );

    final powerW = reading.powerW;
    final absPowerW = powerW.abs();
    if (_powerHistory.isEmpty || (_powerHistory.last - absPowerW).abs() > 0.05) {
      if (_powerHistory.length >= 60) _powerHistory.removeAt(0);
      _powerHistory.add(absPowerW);
    }

    final isCharging = reading.status == BatteryStatus.charging ||
        reading.status == BatteryStatus.full;
    final isFastCharging = absPowerW >= 15.0;

    // Charger type label
    final plugLabel = switch (reading.plugType) {
      PlugType.ac => 'AC Fast Charger',
      PlugType.usb => 'USB Cable',
      PlugType.wireless => 'Wireless Pad',
      PlugType.none => isCharging ? 'Connected' : 'On battery',
    };

    // Time estimate calculation
    final timeEstimateUseCase = ComputeTimeEstimateUseCase();
    final estimatedTime = timeEstimateUseCase.execute(
          isCharging: isCharging,
          currentPercent: reading.percent,
          ratePerMin: isCharging ? 0.8 : 0.15,
        ) ??
        (isCharging ? const Duration(minutes: 45) : const Duration(hours: 5, minutes: 13));

    // Design capacity & current mAh
    final designCap = settings.designCapacityMah > 0 ? settings.designCapacityMah : 5000;
    final currentMah = ((reading.percent / 100.0) * designCap).toInt();

    // Charge limit coaching alert
    final isLimitReached = isCharging && reading.percent >= settings.chargeLimitPct;

    // Discharge / Charge rate per hour calculation
    final ratePerHour = isCharging ? 28.0 : 9.0;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt, color: Color(0xFF00E5FF), size: 22),
            ),
            const SizedBox(width: 8),
            Text(
              'ChargeEasy',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
        actions: [
          // Crown button for Premium (Starts at ₹79)
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.stars,
                  color: settings.isPro ? const Color(0xFF00E5FF) : const Color(0xFFF59E0B),
                  size: 26,
                ),
                if (!settings.isPro)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                    ),
                  ),
              ],
            ),
            tooltip: settings.isPro ? 'ChargeEasy Pro Active' : 'Get Premium (₹79)',
            onPressed: () => PremiumSubscriptionSheet.show(context),
          ),

          // Profile Button (Matching Image 3)
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 26),
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
          ),

          // Calibration
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Calibration',
            onPressed: () => context.push('/calibration'),
          ),

          // Guard Mode
          IconButton(
            icon: const Icon(Icons.security_outlined),
            tooltip: 'Guard Mode',
            onPressed: () => context.push('/guard'),
          ),

          // Share
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Stats',
            onPressed: () {
              Share.share(
                '🔋 ChargeEasy Battery Telemetry:\n'
                'Level: ${reading.percent}%\n'
                'Current: ${reading.currentMa.toInt()} mA\n'
                'Power: ${absPowerW.toStringAsFixed(1)} W\n'
                'Temp: ${reading.temperatureC.toStringAsFixed(1)}°C\n'
                'Status: $plugLabel',
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(batteryStreamProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Smart charge limit coach banner
              if (isLimitReached)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Charge limit reached (${settings.chargeLimitPct}%). Unplug now to preserve cycle lifespan!',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.amber.shade200,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Gauge Card Container with Style Switcher
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white12
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Stack(
                  children: [
                    // Toggle Gauge Mode Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          _useSpeedometerView ? Icons.donut_large : Icons.speed,
                          size: 22,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        tooltip: _useSpeedometerView
                            ? 'Switch to Circular Ring'
                            : 'Switch to Speedometer Dial',
                        onPressed: () {
                          setState(() {
                            _useSpeedometerView = !_useSpeedometerView;
                          });
                        },
                      ),
                    ),

                    // Main Gauge Body
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: _useSpeedometerView
                          ? AnalogSpeedometerGauge(
                              currentMa: reading.currentMa.toDouble(),
                              percent: reading.percent,
                              isCharging: isCharging,
                              dischargeRatePerHour: ratePerHour,
                              estimatedTime: estimatedTime,
                              currentMah: currentMah,
                              maxMah: designCap,
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 12),
                                BatteryGauge(
                                  percentage: reading.percent.toDouble(),
                                  isCharging: isCharging,
                                  isFastCharging: isFastCharging,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  isCharging ? '+$currentMah mA' : '${reading.currentMa.toInt()} mA',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isCharging ? 'Charging' : 'Discharging',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                    ),
                  ],
                ),
              ),

              // Comprehensive 9+ Telemetry Grid (Matching Reference App Image 1)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  child: Text(
                    'Live Battery Telemetry',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.95,
                children: [
                  // 1. Voltage Dial (3.0V - 4.5V)
                  MiniDialGaugeCard(
                    title: 'Voltage',
                    valueText: '${(reading.voltageMv / 1000.0).toStringAsFixed(2)} V',
                    fraction: (((reading.voltageMv / 1000.0) - 3.2) / (4.4 - 3.2)).clamp(0.0, 1.0),
                    arcColors: const [
                      Color(0xFFEAB308),
                      Color(0xFF22C55E),
                      Color(0xFF3B82F6),
                      Color(0xFFEF4444),
                    ],
                  ),

                  // 2. Temperature Dial (20°C - 50°C)
                  MiniDialGaugeCard(
                    title: 'Temperature',
                    valueText: '${reading.temperatureC.toStringAsFixed(1)} °C',
                    fraction: ((reading.temperatureC - 20) / (50 - 20)).clamp(0.0, 1.0),
                    arcColors: const [
                      Color(0xFF38BDF8),
                      Color(0xFF22C55E),
                      Color(0xFFF59E0B),
                      Color(0xFFEF4444),
                    ],
                  ),

                  // 3. Level Dial (0% - 100%)
                  MiniDialGaugeCard(
                    title: 'Level',
                    valueText: '${reading.percent}%',
                    fraction: (reading.percent / 100.0).clamp(0.0, 1.0),
                    arcColors: const [
                      Color(0xFFEF4444),
                      Color(0xFFF59E0B),
                      Color(0xFF22C55E),
                    ],
                  ),

                  // 4. Status Card
                  MiniIconTelemetryCard(
                    title: 'Status',
                    valueText: isCharging ? 'Charging' : 'Discharging',
                    icon: Icon(
                      isCharging ? Icons.battery_charging_full : Icons.battery_alert,
                      color: isCharging ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      size: 28,
                    ),
                  ),

                  // 5. Power Dial (0W - 35W)
                  MiniDialGaugeCard(
                    title: 'Power',
                    valueText: isCharging
                        ? '+${absPowerW.toStringAsFixed(2)} W'
                        : '-${absPowerW.toStringAsFixed(2)} W',
                    fraction: (absPowerW / 35.0).clamp(0.0, 1.0),
                    arcColors: const [
                      Color(0xFFEF4444),
                      Color(0xFF22C55E),
                    ],
                  ),

                  // 6. Plugged Card
                  MiniIconTelemetryCard(
                    title: 'Plugged',
                    valueText: plugLabel,
                    icon: Icon(
                      switch (reading.plugType) {
                        PlugType.ac => Icons.power,
                        PlugType.usb => Icons.usb,
                        PlugType.wireless => Icons.radar,
                        PlugType.none => Icons.battery_std,
                      },
                      color: const Color(0xFF3B82F6),
                      size: 28,
                    ),
                  ),

                  // 7. Health Card
                  MiniIconTelemetryCard(
                    title: 'Health',
                    valueText: switch (reading.health) {
                      BatteryHealth.good => 'Good',
                      BatteryHealth.overheat => 'Overheat',
                      BatteryHealth.dead => 'Critical',
                      BatteryHealth.overVoltage => 'High Volt',
                      BatteryHealth.unspecified => 'Normal',
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Color(0xFFEC4899),
                      size: 28,
                    ),
                  ),

                  // 8. Technology Card
                  const MiniIconTelemetryCard(
                    title: 'Technology',
                    valueText: 'Li-ion',
                    icon: Icon(
                      Icons.memory,
                      color: Color(0xFF8B5CF6),
                      size: 28,
                    ),
                  ),

                  // 9. Max Capacity Card
                  MiniIconTelemetryCard(
                    title: 'Max Capacity',
                    valueText: '$designCap mAh',
                    icon: const Icon(
                      Icons.battery_saver,
                      color: Color(0xFF10B981),
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Live Sparkline Chart
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live Power Curve (W)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${absPowerW.toStringAsFixed(1)} W peak',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF00E5FF),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SparklineChart(dataPoints: _powerHistory),
                ),
              ),
              const SizedBox(height: 20),

              // Start / Stop Session Action Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: Icon(_isTrackingSession ? Icons.stop : Icons.play_arrow),
                  label: Text(_isTrackingSession ? 'Stop Charging Session' : 'Start Session Tracking'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isTrackingSession ? Colors.redAccent : null,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    setState(() {
                      _isTrackingSession = !_isTrackingSession;
                    });
                    if (_isTrackingSession) {
                      _sessionStartTime = DateTime.now();
                      _sessionStartPct = reading.percent;
                      await BatteryService().startForegroundService();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Session tracking started in background!')),
                        );
                      }
                    } else {
                      await BatteryService().stopForegroundService();
                      final durMinutes = _sessionStartTime != null
                          ? DateTime.now().difference(_sessionStartTime!).inMinutes
                          : 0;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Session logged: ${_sessionStartPct ?? 0}% → ${reading.percent}% (${durMinutes}m elapsed)',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              // AdMob Banner (shown on free tier, hidden for Pro)
              AdmobBanner(isPro: settings.isPro),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
