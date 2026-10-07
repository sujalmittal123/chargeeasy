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
  final List<double> _powerHistory = [];
  final List<({DateTime time, int percent, bool isCharging})> _levelHistory = [];
  final List<({DateTime time, double currentMa})> _currentMaHistory = [];
  bool _isTrackingSession = false;
  bool _useSpeedometerView = true;
  bool _promptedForCapacity = false;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  Future<void> _checkServiceStatus() async {
    try {
      final running = await BatteryService().isForegroundServiceRunning();
      if (mounted) setState(() => _isTrackingSession = running);
    } catch (_) {}
  }

  void _checkPromptDesignCapacity(int detectedFromKernel, int currentSettingsCap) {
    if (_promptedForCapacity) return;
    if (detectedFromKernel <= 0 && currentSettingsCap <= 0) {
      _promptedForCapacity = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDesignCapacityDialog();
      });
    }
  }

  void _showDesignCapacityDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Battery Capacity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your device does not report battery design capacity to Android. Please enter your phone\'s battery size in mAh (check GSMArena or specs):',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Capacity (mAh)',
                hintText: 'e.g. 4500, 5000',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Skip'),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              if (val != null && val >= 500 && val <= 30000) {
                ref.read(settingsProvider.notifier).setDesignCapacity(val);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final batteryAsync = ref.watch(batteryStreamProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();

    final reading = batteryAsync.valueOrNull;
    if (reading == null) {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 16,
          title: const Text(
            'Charge Tracker',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.stars,
                color: settings.isPro ? const Color(0xFF00E5FF) : const Color(0xFFF59E0B),
                size: 24,
              ),
              tooltip: settings.isPro ? 'Charge Tracker Pro Active' : 'Premium - Coming Soon',
              onPressed: () => PremiumSubscriptionSheet.show(context),
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, size: 26),
              tooltip: 'Profile',
              onPressed: () => context.push('/profile'),
            ),
          ],
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Reading device battery sensors...',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

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

    // Dynamic design capacity detection
    final detectedCapacity = reading.designCapacityMah > 0 ? reading.designCapacityMah : 0;
    final designCap = settings.designCapacityMah > 0 ? settings.designCapacityMah : detectedCapacity;

    // Auto-update settings with real device capacity if not yet set
    if (settings.designCapacityMah == 0 && reading.designCapacityMah > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(settingsProvider.notifier).setDesignCapacity(reading.designCapacityMah);
      });
    } else {
      _checkPromptDesignCapacity(reading.designCapacityMah, settings.designCapacityMah);
    }

    // Real charge in mAh
    final hasRealCounter = reading.chargeCounterUah > 0;
    final currentMah = hasRealCounter
        ? (reading.chargeCounterUah / 1000).toInt()
        : (designCap > 0 ? ((reading.percent / 100.0) * designCap).toInt() : 0);

    // Dynamic rate per hour calculation from rolling 10-15 min window
    final now = DateTime.now();
    _levelHistory.removeWhere((item) => now.difference(item.time).inMinutes > 15);
    _levelHistory.add((time: now, percent: reading.percent, isCharging: isCharging));

    double ratePerHour = 0.0;
    final matchingHistory = _levelHistory.where((e) => e.isCharging == isCharging).toList();
    if (matchingHistory.length >= 2) {
      final oldest = matchingHistory.first;
      final elapsedSec = now.difference(oldest.time).inSeconds;
      if (elapsedSec >= 180) {
        final pctDiff = (oldest.percent - reading.percent).abs();
        final hours = elapsedSec / 3600.0;
        if (hours > 0 && pctDiff > 0) {
          ratePerHour = pctDiff / hours;
        }
      }
    }

    // Dynamic time estimate calculation over rolling 5-minute current window
    _currentMaHistory.removeWhere((item) => now.difference(item.time).inMinutes > 5);
    _currentMaHistory.add((time: now, currentMa: reading.currentMa.abs()));

    Duration estimatedTime = Duration.zero;
    if (isCharging && reading.chargeTimeRemainingMs > 0) {
      estimatedTime = Duration(milliseconds: reading.chargeTimeRemainingMs);
    } else if (_currentMaHistory.isNotEmpty) {
      final avgMa = _currentMaHistory.map((e) => e.currentMa).reduce((a, b) => a + b) / _currentMaHistory.length;
      if (avgMa > 20) {
        if (!isCharging && currentMah > 0) {
          final hours = currentMah / avgMa;
          estimatedTime = Duration(minutes: (hours * 60).toInt());
        } else if (isCharging && designCap > currentMah) {
          final hours = (designCap - currentMah) / avgMa;
          estimatedTime = Duration(minutes: (hours * 60).toInt());
        }
      }
    }

    // Charge limit coaching alert
    final isLimitReached = isCharging && reading.percent >= settings.chargeLimitPct;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text(
          'Charge Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        actions: [
          // 1. Crown / Stars button for Premium
          IconButton(
            icon: Icon(
              Icons.stars,
              color: settings.isPro ? const Color(0xFF00E5FF) : const Color(0xFFF59E0B),
              size: 24,
            ),
            tooltip: settings.isPro ? 'Charge Tracker Pro Active' : 'Premium - Coming Soon',
            onPressed: () => PremiumSubscriptionSheet.show(context),
          ),

          // 2. Profile Button
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 26),
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
          ),

          // 3. Overflow Menu for Secondary Actions (Prevents AppBar overlap on all screen sizes)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onSelected: (value) {
              switch (value) {
                case 'calibration':
                  context.push('/calibration');
                  break;
                case 'guard':
                  context.push('/guard');
                  break;
                case 'share':
                  Share.share(
                    '🔋 Charge Tracker Battery Telemetry:\n'
                    'Level: ${reading.percent}%\n'
                    'Current: ${reading.currentMa.toInt()} mA\n'
                    'Power: ${absPowerW.toStringAsFixed(1)} W\n'
                    'Temp: ${reading.temperatureC.toStringAsFixed(1)}°C\n'
                    'Capacity: $designCap mAh\n'
                    'Status: $plugLabel',
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'calibration',
                child: Row(
                  children: [
                    Icon(Icons.tune, size: 20),
                    SizedBox(width: 12),
                    Text('Calibration'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'guard',
                child: Row(
                  children: [
                    Icon(Icons.security_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Guard Mode'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Share Telemetry'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(batteryStreamProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 36.0),
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
                  // 1. Voltage Dial (3.0V - 4.5V single cell, or 6.0V - 9.0V dual cell fast charging)
                  Builder(
                    builder: (context) {
                      final voltV = reading.voltageMv / 1000.0;
                      final isDualCell = voltV > 5.5;
                      final minVolt = isDualCell ? 6.4 : 3.2;
                      final maxVolt = isDualCell ? 9.0 : 4.45;
                      final voltFraction = ((voltV - minVolt) / (maxVolt - minVolt)).clamp(0.0, 1.0);
                      return MiniDialGaugeCard(
                        title: 'Voltage',
                        valueText: '${voltV.toStringAsFixed(2)} V',
                        fraction: voltFraction,
                        arcColors: const [
                          Color(0xFFEAB308),
                          Color(0xFF22C55E),
                          Color(0xFF3B82F6),
                          Color(0xFFEF4444),
                        ],
                      );
                    },
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

                  // 5. Power Dial (dynamically adaptive: 35W, 65W, 120W)
                  Builder(
                    builder: (context) {
                      final maxPowerW = absPowerW > 65.0 ? 120.0 : (absPowerW > 35.0 ? 65.0 : 35.0);
                      return MiniDialGaugeCard(
                        title: 'Power',
                        valueText: isCharging
                            ? '+${absPowerW.toStringAsFixed(2)} W'
                            : '-${absPowerW.toStringAsFixed(2)} W',
                        fraction: (absPowerW / maxPowerW).clamp(0.0, 1.0),
                        arcColors: const [
                          Color(0xFFEF4444),
                          Color(0xFF22C55E),
                        ],
                      );
                    },
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

                  // 8. Technology Card (Dynamic hardware technology e.g. Li-ion, Li-poly)
                  MiniIconTelemetryCard(
                    title: 'Technology',
                    valueText: reading.technology.isNotEmpty ? reading.technology : 'Li-ion',
                    icon: const Icon(
                      Icons.memory,
                      color: Color(0xFF8B5CF6),
                      size: 28,
                    ),
                  ),

                  // 9. Max Capacity Card (Dynamic device design capacity)
                  MiniIconTelemetryCard(
                    title: 'Max Capacity',
                    valueText: designCap > 0 ? '$designCap mAh' : '--',
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
                  label: Text(_isTrackingSession ? 'Stop Charging Monitor' : 'Start Background Monitor'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isTrackingSession ? Colors.redAccent : null,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    final running = await BatteryService().toggleManualTracking();
                    if (!mounted) return;
                    setState(() {
                      _isTrackingSession = running;
                    });
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          running
                              ? 'Foreground battery monitor started!'
                              : 'Foreground battery monitor stopped.',
                        ),
                      ),
                    );
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
