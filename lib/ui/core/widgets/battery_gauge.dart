import 'package:flutter/material.dart';

class BatteryGauge extends StatefulWidget {
  final double percentage;
  final bool isCharging;
  final bool isFastCharging;

  const BatteryGauge({
    super.key,
    required this.percentage,
    this.isCharging = false,
    this.isFastCharging = false,
  });

  @override
  State<BatteryGauge> createState() => _BatteryGaugeState();
}

class _BatteryGaugeState extends State<BatteryGauge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    if (widget.isFastCharging) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BatteryGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFastCharging != oldWidget.isFastCharging) {
      if (widget.isFastCharging) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getGaugeColor() {
    if (widget.isCharging) return Colors.cyan;
    if (widget.percentage > 50) return Colors.green;
    if (widget.percentage > 20) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.isFastCharging ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: widget.percentage / 100),
              duration: const Duration(seconds: 1),
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 16,
                  color: _getGaugeColor(),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  strokeCap: StrokeCap.round,
                );
              },
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isCharging)
                Icon(Icons.bolt, color: _getGaugeColor(), size: 32),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: widget.percentage),
                duration: const Duration(seconds: 1),
                builder: (context, value, _) {
                  return Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
