import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

import '../../../providers/settings_provider.dart';
import '../../../providers/health_provider.dart';
import '../../../providers/battery_provider.dart';
import '../../../providers/session_provider.dart';
import '../../../domain/use_cases/export_sessions.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();
    final healthSnapshotsAsync = ref.watch(healthSnapshotsProvider);
    final snapshots = healthSnapshotsAsync.valueOrNull ?? [];
    final latestSnapshot = snapshots.lastOrNull;

    final batteryAsync = ref.watch(batteryStreamProvider);
    final hardwareCap = batteryAsync.valueOrNull?.designCapacityMah ?? 0;
    final designCapacity = settings.designCapacityMah > 0
        ? settings.designCapacityMah
        : (hardwareCap > 0 ? hardwareCap : 0);

    final sessionsAsync = ref.watch(sessionsProvider);
    final sessions = sessionsAsync.valueOrNull ?? [];

    // Calculate full cycle equivalents from real DB sessions: sum(end - start) / 100
    final totalCyclePct = sessions.fold<int>(0, (sum, s) {
      final end = s.endPct ?? s.startPct;
      final diff = end - s.startPct;
      return diff > 0 ? sum + diff : sum;
    });
    final cyclesFromDb = (totalCyclePct / 100.0);
    final cycleDisplay = sessions.isNotEmpty ? cyclesFromDb.toStringAsFixed(1) : '0';

    // Health calculation from qualifying sessions (>= 30% level change) or snapshot
    final qualifyingSessions = sessions.where((s) {
      final end = s.endPct ?? s.startPct;
      return (end - s.startPct) >= 30;
    }).toList();

    double? healthPercent;
    int? estimatedCapacity;

    if (latestSnapshot != null && latestSnapshot.healthPct > 0) {
      healthPercent = latestSnapshot.healthPct;
      estimatedCapacity = latestSnapshot.estCapacityMah;
    } else if (qualifyingSessions.isNotEmpty && designCapacity > 0) {
      // Estimate from qualifying session
      final s = qualifyingSessions.last;
      final deltaPct = ((s.endPct ?? s.startPct) - s.startPct);
      final avgMa = s.avgMa ?? 1500.0;
      final durHours = ((s.endTs ?? s.startTs) - s.startTs) / 3600000.0;
      final mahGained = avgMa * durHours;
      if (deltaPct > 0 && mahGained > 0) {
        estimatedCapacity = ((mahGained / deltaPct) * 100).toInt();
        healthPercent = ((estimatedCapacity / designCapacity) * 100).clamp(50.0, 100.0);
      }
    }

    final hasHealthData = healthPercent != null && estimatedCapacity != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Health & Lifespan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Export Battery Report',
            onPressed: () async {
              try {
                final pdfPath = await ExportSessionsUseCase().exportToPdf(sessions);
                await Share.shareXFiles([XFile(pdfPath)], text: 'Charge Tracker Battery Health Report');
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Export error: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: hasHealthData ? (healthPercent / 100.0) : 0.0,
                      ),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, _) {
                        return CircularProgressIndicator(
                          value: hasHealthData ? value : null,
                          strokeWidth: 14,
                          color: hasHealthData ? Colors.greenAccent.shade700 : Colors.grey,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          strokeCap: StrokeCap.round,
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Health', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      Text(
                        hasHealthData ? '${healthPercent.toInt()}%' : '--',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: hasHealthData ? Colors.greenAccent.shade700 : Colors.grey,
                            ),
                      ),
                      Text(
                        hasHealthData
                            ? (healthPercent >= 80 ? 'Good Condition' : 'Service Recommended')
                            : 'Need ≥ 30% Session',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (!hasHealthData)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Need at least 1 session with >= 30% charge to calculate health. Plug in and charge now.',
                style: TextStyle(color: Colors.amber.shade400, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 24),

          // 3 key metrics
          Row(
            children: [
              Expanded(
                child: _buildHealthStat(
                  context,
                  'Est. Capacity',
                  estimatedCapacity != null ? '$estimatedCapacity mAh' : '--',
                ),
              ),
              Expanded(
                child: _buildHealthStat(
                  context,
                  'Design Capacity',
                  designCapacity > 0 ? '$designCapacity mAh' : '--',
                ),
              ),
              Expanded(
                child: _buildHealthStat(
                  context,
                  'Charge Cycles',
                  cycleDisplay,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Trend chart
          Text(
            'Health Degradation Trend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: snapshots.length < 2
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'Collecting data — check back in a few days',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true, horizontalInterval: 5),
                      minY: 60,
                      maxY: 100,
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            getTitlesWidget: (v, m) => Text('${v.toInt()}%', style: const TextStyle(fontSize: 10)),
                          ),
                        ),
                        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: snapshots
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value.healthPct))
                              .toList(),
                          isCurved: true,
                          color: Colors.greenAccent.shade700,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.greenAccent.shade700.withValues(alpha: 0.25),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Condition card with theme support
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        hasHealthData && healthPercent >= 80 ? Icons.check_circle_outline : Icons.info_outline,
                        color: hasHealthData && healthPercent >= 80 ? Colors.greenAccent.shade700 : Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hasHealthData
                            ? (healthPercent >= 80 ? 'Good Battery Longevity' : 'Noticeable Degradation')
                            : 'Collecting Health Telemetry',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: hasHealthData && healthPercent >= 80 ? Colors.greenAccent.shade700 : Colors.amber,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasHealthData
                        ? 'Your battery retains ${healthPercent.toInt()}% of its rated capacity with $cycleDisplay full cycle equivalents. Keep daily charge between 20% and 80% to maximize lifespan.'
                        : 'Charge Tracker measures capacity over full charge sessions (≥ 30% delta). Connect your charger to start calculating true battery capacity.',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHealthStat(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00E5FF))),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }
}
