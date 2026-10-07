import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SparklineChart extends StatelessWidget {
  final List<double> dataPoints;

  const SparklineChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    if (dataPoints.length < 2) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'Collecting power samples...',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      );
    }

    final spots = dataPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    final gradientColors = [
      Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
      Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
    ];

    final minVal = dataPoints.reduce((a, b) => a < b ? a : b);
    final maxVal = dataPoints.reduce((a, b) => a > b ? a : b);
    final minY = (minVal == maxVal) ? (minVal > 1 ? minVal - 1 : 0.0) : minVal * 0.9;
    final maxY = (minVal == maxVal) ? minVal + 1 : maxVal * 1.1;

    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (dataPoints.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors,
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
}
