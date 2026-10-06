import 'package:flutter/material.dart';
import 'dart:async';

class TimeEstimateWidget extends StatefulWidget {
  final bool isCharging;
  final Duration estimatedTime;

  const TimeEstimateWidget({
    super.key,
    required this.isCharging,
    required this.estimatedTime,
  });

  @override
  State<TimeEstimateWidget> createState() => _TimeEstimateWidgetState();
}

class _TimeEstimateWidgetState extends State<TimeEstimateWidget> {
  late Timer _timer;
  late Duration _currentEstimate;

  @override
  void initState() {
    super.initState();
    _currentEstimate = widget.estimatedTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentEstimate.inSeconds > 0) {
          _currentEstimate -= const Duration(seconds: 1);
        }
      });
    });
  }

  @override
  void didUpdateWidget(TimeEstimateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.estimatedTime != oldWidget.estimatedTime) {
      _currentEstimate = widget.estimatedTime;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.isCharging
        ? 'Full in ${_formatDuration(_currentEstimate)}'
        : 'Empty in ${_formatDuration(_currentEstimate)}';
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
