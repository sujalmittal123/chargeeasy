import 'package:flutter/material.dart';

enum ChargeSpeed { slow, normal, fast, superFast }

class ChargeSpeedBadge extends StatelessWidget {
  final ChargeSpeed speed;

  const ChargeSpeedBadge({super.key, required this.speed});

  Color _getColor() {
    switch (speed) {
      case ChargeSpeed.slow: return Colors.grey;
      case ChargeSpeed.normal: return Colors.blue;
      case ChargeSpeed.fast: return Colors.orange;
      case ChargeSpeed.superFast: return Colors.purple;
    }
  }

  String _getLabel() {
    switch (speed) {
      case ChargeSpeed.slow: return 'Slow';
      case ChargeSpeed.normal: return 'Normal';
      case ChargeSpeed.fast: return 'Fast';
      case ChargeSpeed.superFast: return 'Super Fast';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            _getLabel(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
