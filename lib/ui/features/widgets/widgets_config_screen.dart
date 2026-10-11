import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/widget_manager_service.dart';
import '../../../domain/models/battery_reading.dart';
import '../../../providers/battery_provider.dart';

class WidgetsConfigScreen extends ConsumerStatefulWidget {
  const WidgetsConfigScreen({super.key});

  @override
  ConsumerState<WidgetsConfigScreen> createState() => _WidgetsConfigScreenState();
}

class _WidgetsConfigScreenState extends ConsumerState<WidgetsConfigScreen> {
  final WidgetManagerService _widgetService = WidgetManagerService();
  bool _isTransparent = true;
  bool _isPinningSupported = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWidgetSettings();
  }

  Future<void> _loadWidgetSettings() async {
    final supported = await _widgetService.isPinningSupported();
    final isTransparent = await _widgetService.getWidgetTransparentTheme();
    if (mounted) {
      setState(() {
        _isPinningSupported = supported;
        _isTransparent = isTransparent;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleTransparentTheme(bool val) async {
    HapticFeedback.lightImpact();
    setState(() => _isTransparent = val);
    await _widgetService.setWidgetTransparentTheme(val);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            val ? 'Switched to Ultra-Transparent Glass' : 'Switched to Obsidian Glass',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _pinWidget(String type, BatteryReading? reading) async {
    HapticFeedback.mediumImpact();
    // Sync latest telemetry before pinning
    if (reading != null) {
      await _widgetService.syncWidgetData(
        percent: reading.percent,
        currentMa: reading.currentMa.toInt(),
        watts: reading.powerW.abs(),
        temperatureC: reading.temperatureC,
        voltageV: reading.voltageMv / 1000.0,
        health: reading.health.name.toUpperCase(),
        isCharging: reading.status == BatteryStatus.charging,
      );
    }

    final success = await _widgetService.requestPinWidget(type);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Adding ${type == '4x2' ? 'Pro Dashboard' : 'Compact'} widget! Tap "Add to Home Screen" on your system prompt.',
          ),
          backgroundColor: const Color(0xFF00E5FF),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _showManualAddDialog(type);
    }
  }

  void _showManualAddDialog(String type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.widgets_outlined, color: Color(0xFF00E5FF)),
            SizedBox(width: 10),
            Text('Add Widget Manually'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your launcher requires adding widgets manually from your home screen:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 14),
            _guideStep('1', 'Go to your Android home screen'),
            _guideStep('2', 'Touch and hold an empty space'),
            _guideStep('3', 'Tap "Widgets" from the menu'),
            _guideStep('4', 'Find "Charge Tracker"'),
            _guideStep(
              '5',
              'Drag the ${type == '4x2' ? '4x2 Pro Dashboard' : '2x1 Compact'} widget to your screen',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it', style: TextStyle(color: Color(0xFF00E5FF))),
          ),
        ],
      ),
    );
  }

  Widget _guideStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final batteryAsync = ref.watch(batteryStreamProvider);
    final reading = batteryAsync.valueOrNull;

    final percent = reading?.percent ?? 82;
    final watts = reading != null ? reading.powerW.abs() : 24.5;
    final current = reading?.currentMa.toInt() ?? 2450;
    final temp = reading?.temperatureC ?? 31.4;
    final voltage = reading != null ? reading.voltageMv / 1000.0 : 4.18;
    final isCharging = reading != null ? reading.status == BatteryStatus.charging : true;
    final healthStr = reading?.health.name.toUpperCase() ?? 'GOOD';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Home Screen Widgets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF00E5FF)),
            tooltip: 'Refresh Widgets',
            onPressed: () async {
              HapticFeedback.lightImpact();
              await _widgetService.refreshWidgets();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Widgets refreshed with live telemetry!'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.dashboard_customize_outlined,
                          color: Color(0xFF00E5FF),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Transparent & Live Telemetry',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isPinningSupported
                                  ? 'Pin sleek widgets directly to your home screen with live watts, temp, health & voltage.'
                                  : 'Customizable widgets for your home screen with live watts, temp, health & voltage.',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Theme Style Switcher
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Widget Appearance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Transparent'),
                          selected: _isTransparent,
                          onSelected: (selected) {
                            if (selected) _toggleTransparentTheme(true);
                          },
                          selectedColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: _isTransparent ? const Color(0xFF00E5FF) : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Obsidian Glass'),
                          selected: !_isTransparent,
                          onSelected: (selected) {
                            if (selected) _toggleTransparentTheme(false);
                          },
                          selectedColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: !_isTransparent ? const Color(0xFF00E5FF) : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── PREVIEW 1: 2x1 Compact Widget ──
                _sectionHeader('1. Compact Widget (2x1)', 'Clean, minimal battery & power tile'),
                const SizedBox(height: 10),
                _buildCompactPreview(
                  percent: percent,
                  watts: watts,
                  current: current,
                  temp: temp,
                  health: healthStr,
                  isCharging: isCharging,
                  isTransparent: _isTransparent,
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => _pinWidget('2x1', reading),
                  icon: const Icon(Icons.add_to_home_screen_rounded, size: 18),
                  label: const Text('Add 2x1 Widget to Home Screen'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── PREVIEW 2: 4x2 Pro Dashboard Widget ──
                _sectionHeader(
                  '2. Pro Dashboard Widget (4x2)',
                  'Full telemetry: watts, temp, health, voltage & sync time',
                ),
                const SizedBox(height: 10),
                _buildLargePreview(
                  percent: percent,
                  watts: watts,
                  current: current,
                  temp: temp,
                  voltage: voltage,
                  health: healthStr,
                  isCharging: isCharging,
                  isTransparent: _isTransparent,
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => _pinWidget('4x2', reading),
                  icon: const Icon(Icons.add_to_home_screen_rounded, size: 18),
                  label: const Text('Add 4x2 Pro Widget to Home Screen'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── MANUAL INSTRUCTIONS GUIDE ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.touch_app_outlined, color: Colors.white70, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'How to Add on Any Launcher',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _guideStep('1', 'Return to your phone home screen.'),
                      _guideStep('2', 'Touch and hold on an empty area of the screen.'),
                      _guideStep('3', 'Select "Widgets" from the bottom sheet.'),
                      _guideStep('4', 'Scroll down and tap "Charge Tracker".'),
                      _guideStep('5', 'Drag your preferred widget into place!'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }

  /// Interactive simulation of 2x1 Native Widget
  Widget _buildCompactPreview({
    required int percent,
    required double watts,
    required int current,
    required double temp,
    required String health,
    required bool isCharging,
    required bool isTransparent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isTransparent
            ? Colors.black.withValues(alpha: 0.2)
            : const Color(0xFF080E18).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isTransparent
              ? Colors.white.withValues(alpha: 0.25)
              : const Color(0xFF00E5FF).withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isCharging ? Icons.bolt_rounded : Icons.battery_charging_full_rounded,
                color: const Color(0xFF00E5FF),
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                '$percent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isCharging ? 'Charging ⚡' : 'Discharging',
                  style: const TextStyle(
                    color: Color(0xFF00E5FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 12,
                child: _pillContainer(
                  '${watts.toStringAsFixed(1)}W · ${current}mA',
                  const Color(0xFF00E5FF),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 8,
                child: _pillContainer(
                  '${temp.toStringAsFixed(1)}°C',
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 8,
                child: _pillContainer(
                  health,
                  Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Interactive simulation of 4x2 Native Widget
  Widget _buildLargePreview({
    required int percent,
    required double watts,
    required int current,
    required double temp,
    required double voltage,
    required String health,
    required bool isCharging,
    required bool isTransparent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTransparent
            ? Colors.black.withValues(alpha: 0.25)
            : const Color(0xFF080E18).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isTransparent
              ? Colors.white.withValues(alpha: 0.3)
              : const Color(0xFF00E5FF).withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Color(0xFF00E5FF), size: 18),
              const SizedBox(width: 6),
              const Text(
                'Charge Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isCharging ? 'Super Fast ⚡' : 'Connected',
                  style: const TextStyle(
                    color: Color(0xFF00E5FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 14),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Hero Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$percent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${watts.toStringAsFixed(1)} W · ${current > 0 ? "+$current" : current} mA',
                      style: const TextStyle(
                        color: Color(0xFF00E5FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isCharging ? '42m remaining until 100%' : '18h 30m estimated battery life',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 12),

          // 4 Telemetry Metrics Grid
          Row(
            children: [
              Expanded(child: _metricColumn('TEMP', '${temp.toStringAsFixed(1)}°C', const Color(0xFF10B981))),
              const SizedBox(width: 6),
              Expanded(child: _metricColumn('HEALTH', health, Colors.white)),
              const SizedBox(width: 6),
              Expanded(child: _metricColumn('VOLTAGE', '${voltage.toStringAsFixed(2)} V', Colors.white)),
              const SizedBox(width: 6),
              Expanded(child: _metricColumn('UPDATED', 'Live', const Color(0xFF00E5FF))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillContainer(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _metricColumn(String label, String value, Color valColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
