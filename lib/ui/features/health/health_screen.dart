import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../providers/settings_provider.dart';
import '../../../providers/health_provider.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();
    final healthSnapshotsAsync = ref.watch(healthSnapshotsProvider);
    final latestSnapshot = healthSnapshotsAsync.valueOrNull?.lastOrNull;

    final designCapacity = settings.designCapacityMah > 0 ? settings.designCapacityMah : 5000;
    final estimatedCapacity = latestSnapshot?.estCapacityMah ?? (designCapacity * 0.92).toInt();
    final healthPercent = latestSnapshot?.healthPct.toInt() ?? 92;
    final cycleCount = latestSnapshot?.cycleCount ?? 245;

    return Scaffold(
      appBar: AppBar(title: const Text('Battery Health & Lifespan')),
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
                      tween: Tween<double>(begin: 0, end: healthPercent / 100.0),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, _) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeWidth: 14,
                          color: Colors.greenAccent.shade700,
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
                        '$healthPercent%',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent.shade700,
                            ),
                      ),
                      const Text('Good Condition', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 3 key metrics
          Row(
            children: [
              Expanded(child: _buildHealthStat(context, 'Est. Capacity', '$estimatedCapacity mAh')),
              Expanded(child: _buildHealthStat(context, 'Design Capacity', '$designCapacity mAh')),
              Expanded(child: _buildHealthStat(context, 'Charge Cycles', '$cycleCount')),
            ],
          ),
          const SizedBox(height: 32),

          DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Degradation Trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const TabBar(
                  tabs: [Tab(text: '30 Days'), Tab(text: '90 Days'), Tab(text: '1 Year')],
                ),
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true, horizontalInterval: 5),
                        minY: 85,
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
                            spots: const [
                              FlSpot(0, 99),
                              FlSpot(1, 98),
                              FlSpot(2, 96),
                              FlSpot(3, 94),
                              FlSpot(4, 92),
                            ],
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
                ),
              ],
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
                      Icon(Icons.check_circle_outline, color: Colors.greenAccent.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Excellent Battery Longevity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your battery retains 92% of its factory design capacity. Keep charge levels between 20% and 80% to preserve cell health and slow chemical aging.',
                    style: TextStyle(fontSize: 13),
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
