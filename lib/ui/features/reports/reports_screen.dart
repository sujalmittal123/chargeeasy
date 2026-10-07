import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/widgets/stat_card.dart';
import '../../../providers/session_provider.dart';
import '../../../domain/use_cases/export_sessions.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _selectedPeriod = 'This Week';

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(sessionsProvider);
    final allSessions = sessionsAsync.valueOrNull ?? [];

    final now = DateTime.now();

    // Filter sessions by period
    final sessions = allSessions.where((s) {
      final sDate = DateTime.fromMillisecondsSinceEpoch(s.startTs);
      final diffDays = now.difference(sDate).inDays;
      switch (_selectedPeriod) {
        case 'This Week':
          return diffDays >= 0 && diffDays < 7;
        case 'Last Week':
          return diffDays >= 7 && diffDays < 14;
        case 'This Month':
          return diffDays >= 0 && diffDays < 30;
        case 'Last Month':
          return diffDays >= 30 && diffDays < 60;
        default:
          return true;
      }
    }).toList();

    // Compute metrics matching History
    final count = sessions.length;
    final avgW = count > 0
        ? (sessions.map((s) => s.avgW ?? 0.0).reduce((a, b) => a + b) / count)
        : null;
    final fullChargesCount = sessions.where((s) => (s.endPct ?? s.startPct) >= 99).length;
    final maxTemp = count > 0
        ? (sessions.map((s) => s.maxTemp ?? 0.0).reduce((a, b) => a > b ? a : b))
        : null;
    final totalDurMins = count > 0
        ? sessions.fold<int>(0, (sum, s) => sum + (((s.endTs ?? s.startTs) - s.startTs) ~/ 60000))
        : null;
    final avgDurMins = (count > 0 && totalDurMins != null) ? totalDurMins ~/ count : null;

    // Daily charging sessions count for the period
    final dayCounts = List<int>.filled(7, 0);
    for (final s in sessions) {
      final sDate = DateTime.fromMillisecondsSinceEpoch(s.startTs);
      final weekdayIndex = (sDate.weekday - 1) % 7; // 0=Mon .. 6=Sun
      dayCounts[weekdayIndex]++;
    }
    final maxDailyCount = dayCounts.reduce((a, b) => a > b ? a : b);

    // Dynamic rule-based AI tips from actual stats
    final List<String> aiTips = [];
    if (count == 0) {
      aiTips.add('No charging sessions recorded for $_selectedPeriod. Plug in to generate battery efficiency recommendations.');
    } else {
      if (maxTemp != null && maxTemp > 39.0) {
        aiTips.add('Peak temperature reached ${maxTemp.toStringAsFixed(1)}°C. Charging while gaming or under heavy CPU load causes thermal degradation; consider charging when idle.');
      }
      if (fullChargesCount >= 4) {
        aiTips.add('You charged to 100% $fullChargesCount times. Capping daily charge at 80% can double lithium-ion cell longevity.');
      }
      if (avgW != null && avgW >= 25.0) {
        aiTips.add('High-speed fast charging active (${avgW.toStringAsFixed(1)} W avg). For overnight charging, standard charging preserves chemistry better.');
      }
      if (avgDurMins != null && avgDurMins > 120) {
        aiTips.add('Average session duration is ${avgDurMins}m. Leaving phone connected long after full causes trickle-charge degradation.');
      }
      if (aiTips.isEmpty) {
        aiTips.add('Battery metrics look healthy! Maintaining charging cycles between 20% and 80% offers optimal cell health.');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly & Monthly Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Export PDF Report',
            onPressed: () async {
              try {
                final pdfPath = await ExportSessionsUseCase().exportToPdf(allSessions);
                await Share.shareXFiles([XFile(pdfPath)], text: 'Charge Tracker Battery Analytics PDF Report');
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Export error: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart_outlined),
            tooltip: 'Export CSV',
            onPressed: () async {
              try {
                final csvPath = await ExportSessionsUseCase().exportToCsv(allSessions);
                await Share.shareXFiles([XFile(csvPath)], text: 'Charge Tracker Battery Sessions CSV');
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
          DropdownButtonFormField<String>(
            initialValue: _selectedPeriod,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Report Timeframe',
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: ['This Week', 'Last Week', 'This Month', 'Last Month']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedPeriod = v);
            },
          ),
          const SizedBox(height: 16),

          // 4 Metric cards matching History
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                icon: Icons.history,
                label: 'Sessions Logged',
                value: count > 0 ? '$count' : '--',
                unit: '',
              ),
              StatCard(
                icon: Icons.speed,
                label: 'Avg Charge Power',
                value: avgW != null && avgW > 0 ? avgW.toStringAsFixed(1) : '--',
                unit: avgW != null && avgW > 0 ? 'W' : '',
              ),
              StatCard(
                icon: Icons.battery_full,
                label: 'Charged to 100%',
                value: count > 0 ? '$fullChargesCount' : '--',
                unit: count > 0 ? 'times' : '',
              ),
              StatCard(
                icon: Icons.thermostat,
                label: 'Peak Temp',
                value: maxTemp != null && maxTemp > 0 ? maxTemp.toStringAsFixed(1) : '--',
                unit: maxTemp != null && maxTemp > 0 ? '°C' : '',
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Daily Charging Sessions Count',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: count == 0
                ? const Center(
                    child: Text(
                      'No session data for this period.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      maxY: (maxDailyCount < 4 ? 4 : maxDailyCount + 1).toDouble(),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (v, _) => Text(
                              '${v.toInt()}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, m) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              if (v >= 0 && v < 7) {
                                return Text(days[v.toInt()], style: const TextStyle(fontSize: 11));
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        7,
                        (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: dayCounts[i].toDouble(),
                              color: const Color(0xFF00E5FF),
                              width: 14,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),

          // On-device AI Coaching Engine Cards
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology, color: Theme.of(context).colorScheme.onSecondaryContainer),
                      const SizedBox(width: 8),
                      Text(
                        'On-Device AI Battery Coach',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...aiTips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, size: 18, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
}
