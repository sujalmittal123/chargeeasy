import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/widgets/stat_card.dart';

class SessionDetailScreen extends StatelessWidget {
  final String id;

  const SessionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
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
                  '⚡ ChargeEasy Charging Session #$id:\n'
                  'Charge: 20% → 85% (+65%)\n'
                  'Duration: 1h 15m\n'
                  'Avg Power: 15.2W (Peak: 22.5W)\n'
                  'Max Temp: 38.5°C\n'
                  'Charger: Samsung 25W AC',
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
            _buildOverviewTab(context),
            _buildChartTab(context),
            _buildDataTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text('20% → 85%', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 8),
                Text('Duration: 1h 15m', style: Theme.of(context).textTheme.titleMedium),
                Text('Oct 6, 2026 - 10:00 AM', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
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
          children: const [
            StatCard(icon: Icons.speed, label: 'Avg Speed', value: '15.2', unit: 'W'),
            StatCard(icon: Icons.bolt, label: 'Peak Speed', value: '22.5', unit: 'W'),
            StatCard(icon: Icons.thermostat, label: 'Max Temp', value: '38.5', unit: '°C'),
            StatCard(icon: Icons.power_input, label: 'Charger', value: 'Samsung', unit: '25W'),
          ],
        ),
      ],
    );
  }

  Widget _buildChartTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LineChart(
        LineChartData(
          minX: 20,
          maxX: 85,
          minY: 0,
          maxY: 25,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text('${v.toInt()}%'))),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, m) => Text('${v.toInt()}W'))),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 5, verticalInterval: 10),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
          lineBarsData: [
            LineChartBarData(
              spots: const [FlSpot(20, 22), FlSpot(40, 22), FlSpot(60, 18), FlSpot(80, 10), FlSpot(85, 5)],
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTab(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text('${20 + index * 3}%', style: const TextStyle(fontWeight: FontWeight.bold)),
          title: Text('${1500 + index * 10} mA'),
          subtitle: Text('4.0V · ${30 + index * 0.2}°C'),
          trailing: Text('10:${index.toString().padLeft(2, '0')} AM'),
        );
      },
    );
  }
}
