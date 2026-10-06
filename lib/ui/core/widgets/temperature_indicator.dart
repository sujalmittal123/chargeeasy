import 'package:flutter/material.dart';

class TemperatureIndicator extends StatelessWidget {
  final double temperature;

  const TemperatureIndicator({super.key, required this.temperature});

  Color _getColor() {
    if (temperature < 30) return Colors.blue;
    if (temperature <= 38) return Colors.green;
    if (temperature <= 42) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.thermostat, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          '${temperature.toStringAsFixed(1)}°C',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
