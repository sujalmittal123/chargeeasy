import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/widgets/stat_card.dart';
import '../../../providers/session_provider.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String id;

  const SessionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionId = int.tryParse(id) ?? -1;
    final sessionAsync = ref.watch(sessionDetailProvider(sessionId));
    final samplesAsync = ref.watch(sessionSamplesProvider(sessionId));

    return sessionAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Session Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Session Details')),
        body: Center(child: Text('Error: $err')),
      ),
      data: (session) {
        if (session == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Session Details')),
            body: const Center(child: Text('Session not found')),
          );
        }

        final samples = samplesAsync.valueOrNull ?? [];
        final startPct = session.startPct;
        final endPct = session.endPct ?? startPct;
        final durMs = (session.endTs ?? session.startTs) - session.startTs;
        final durHours = durMs ~/ 3600000;
        final durMins = (durMs % 3600000) ~/ 60000;
        final durStr = durHours > 0 ? '${durHours}h ${durMins}m' : '${durMins}m';
        final startDate = DateTime.fromMillisecondsSinceEpoch(session.startTs);
        final dateStr = DateFormat('MMM d, yyyy - h:mm a').format(startDate);

        final avgWStr = (session.avgW != null && session.avgW! > 0)
            ? session.avgW!.toStringAsFixed(1)
            : '--';
        final peakWStr = (session.peakW != null && session.peakW! > 0)
            ? session.peakW!.toStringAsFixed(1)
            : '--';
        final maxTempStr = (session.maxTemp != null && session.maxTemp! > 0)
            ? session.maxTemp!.toStringAsFixed(1)
            : '--';

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Session Details'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  tooltip: 'Export & Share Session',
                  onPressed: () {
                    Share.share(
                      '⚡ Charge Tracker Charging Session #$id:\n'
                      'Charge: $startPct% → $endPct% (+${endPct - startPct}%)\n'
                      'Duration: $durStr\n'
                      'Avg Power: $avgWStr W (Peak: $peakWStr W)\n'
                      'Max Temp: $maxTempStr °C\n'
                      'Charger: ${session.chargerType}',
                    );
                  },
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Speed Curve'),
                  Tab(text: 'Data'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Overview Tab
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              '$startPct% → $endPct%',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent.shade700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text('Duration: $durStr', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(dateStr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        StatCard(icon: Icons.speed, label: 'Avg Speed', value: avgWStr, unit: 'W'),
                        StatCard(icon: Icons.bolt, label: 'Peak Speed', value: peakWStr, unit: 'W'),
                        StatCard(icon: Icons.thermostat, label: 'Max Temp', value: maxTempStr, unit: '°C'),
                        StatCard(icon: Icons.power, label: 'Charger', value: session.chargerType, unit: ''),
                      ],
                    ),
                  ],
                ),

                // Speed Curve Tab
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: samples.length < 2
                      ? const Center(
                          child: Text(
                            'No power curve samples recorded for this session.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (v, m) => Text('${v.toInt()}%', style: const TextStyle(fontSize: 10)),
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (v, m) => Text('${v.toInt()}W', style: const TextStyle(fontSize: 10)),
                                ),
                              ),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: const FlGridData(show: true, drawVerticalLine: true),
                            borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade400)),
                            lineBarsData: [
                              LineChartBarData(
                                spots: samples
                                    .map(
                                      (s) => FlSpot(
                                        s.pct.toDouble(),
                                        ((s.mv / 1000.0) * (s.ma.abs() / 1000.0)),
                                      ),
                                    )
                                    .toList(),
                                isCurved: true,
                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
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

                // Data Tab
                samples.isEmpty
                    ? const Center(
                        child: Text(
                          'No periodic samples available.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: samples.length,
                        itemBuilder: (context, index) {
                          final sample = samples[index];
                          final sampleTime = DateTime.fromMillisecondsSinceEpoch(sample.ts);
                          final timeStr = DateFormat('h:mm:ss a').format(sampleTime);
                          final voltStr = (sample.mv / 1000.0).toStringAsFixed(2);
                          final powerStr = ((sample.mv / 1000.0) * (sample.ma.abs() / 1000.0)).toStringAsFixed(1);

                          return ListTile(
                            leading: Text('${sample.pct}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            title: Text('${sample.ma.toInt()} mA ($powerStr W)'),
                            subtitle: Text('$voltStr V · ${sample.temp.toStringAsFixed(1)}°C'),
                            trailing: Text(timeStr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
