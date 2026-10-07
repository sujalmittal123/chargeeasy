import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnalogSpeedometerGauge extends StatefulWidget {
  final double currentMa;
  final int percent;
  final bool isCharging;
  final double dischargeRatePerHour;
  final Duration estimatedTime;
  final int currentMah;
  final int maxMah;

  const AnalogSpeedometerGauge({
    super.key,
    required this.currentMa,
    required this.percent,
    required this.isCharging,
    required this.dischargeRatePerHour,
    required this.estimatedTime,
    required this.currentMah,
    required this.maxMah,
  });

  @override
  State<AnalogSpeedometerGauge> createState() => _AnalogSpeedometerGaugeState();
}

class _AnalogSpeedometerGaugeState extends State<AnalogSpeedometerGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _needleController;
  late Animation<double> _needleAnimation;
  double _lastTargetValue = 0.0;

  @override
  void initState() {
    super.initState();
    _needleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _lastTargetValue = widget.currentMa;
    _needleAnimation = Tween<double>(begin: _lastTargetValue, end: _lastTargetValue)
        .animate(CurvedAnimation(parent: _needleController, curve: Curves.easeOutBack));
  }

  @override
  void didUpdateWidget(covariant AnalogSpeedometerGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.currentMa - widget.currentMa).abs() > 5) {
      _needleAnimation = Tween<double>(
        begin: _needleAnimation.value,
        end: widget.currentMa,
      ).animate(CurvedAnimation(parent: _needleController, curve: Curves.easeOutCubic));
      _needleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _needleController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final mins = d.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}hrs ${mins}mins';
    }
    return '${mins}mins';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtextColor = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);

    final displayMa = widget.currentMa.toInt();
    final rateLabel = widget.dischargeRatePerHour <= 0
        ? (widget.isCharging ? 'Charging: Calculating rate...' : 'Discharging: Calculating rate...')
        : (widget.isCharging
            ? 'Charging at ${widget.dischargeRatePerHour.toStringAsFixed(1)}% per hour'
            : 'Discharging at ${widget.dischargeRatePerHour.toStringAsFixed(1)}% per hour');

    final timeLabel = widget.estimatedTime.inMinutes <= 0
        ? (widget.isCharging ? 'Estimated time to 100% : Calculating...' : 'Estimated backup time : Calculating...')
        : (widget.isCharging
            ? 'Estimated time to 100% : ${_formatDuration(widget.estimatedTime)}'
            : 'Estimated backup time : ${_formatDuration(widget.estimatedTime)}');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speedometer Dial Canvas
          SizedBox(
            height: 175,
            width: 320,
            child: AnimatedBuilder(
              animation: _needleAnimation,
              builder: (context, _) {
                return CustomPaint(
                  painter: _SpeedometerPainter(
                    currentMa: _needleAnimation.value,
                    isCharging: widget.isCharging,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),

          // Main numeric current readout
          Text(
            widget.isCharging ? '+$displayMa' : '$displayMa',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: widget.isCharging
                  ? const Color(0xFF00E676)
                  : const Color(0xFFFF5252),
            ),
          ),
          Text(
            'mA',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: subtextColor,
            ),
          ),
          const SizedBox(height: 8),

          // Rate per hour & backup time
          Text(
            rateLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: subtextColor,
            ),
          ),
          const SizedBox(height: 12),

          // Capacity mAh Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (widget.currentMah > 0 && widget.maxMah > 0)
                    ? '${widget.currentMah} mAh / ${widget.maxMah} mAh'
                    : (widget.maxMah > 0 ? '-- / ${widget.maxMah} mAh' : '-- mAh'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: subtextColor,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: (widget.maxMah > 0 && widget.currentMah > 0)
                        ? (widget.currentMah / widget.maxMah).clamp(0.0, 1.0)
                        : (widget.percent > 0 ? widget.percent / 100.0 : 0.0),
                    backgroundColor: isDark
                        ? Colors.grey.shade800
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isCharging
                          ? const Color(0xFF00E676)
                          : const Color(0xFFFF5252),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double currentMa;
  final bool isCharging;
  final bool isDark;

  _SpeedometerPainter({
    required this.currentMa,
    required this.isCharging,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.46;

    // Arc angles: from -160° to -20° (sweeping 140°)
    const startAngle = math.pi + 0.35; // approx 200°
    const sweepAngle = math.pi - 0.70; // approx 140°

    final strokeWidth = size.width * 0.08;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw Red Arc (Discharge zone, left half)
    final redPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle * 0.48, false, redPaint);

    // 2. Center divider gap / transition
    final centerPaint = Paint()
      ..color = isDark ? Colors.grey.shade700 : const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.5
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, startAngle + sweepAngle * 0.48, sweepAngle * 0.04, false, centerPaint);

    // 3. Draw Green Arc (Charging zone, right half)
    final greenPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle + sweepAngle * 0.52, sweepAngle * 0.48, false, greenPaint);

    // 4. Calculate dynamic device-adaptive gauge scale
    final absMa = currentMa.abs();
    double maxScale = 2000.0;
    if (absMa > 5000) {
      maxScale = 8000.0;
    } else if (absMa > 3500) {
      maxScale = 5000.0;
    } else if (absMa > 2000) {
      maxScale = 3500.0;
    }

    // Draw Scale Markings (-maxScale on left, +maxScale on right, 0.0 at center)
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void drawTickLabel(String text, double angleFraction, {Offset offset = Offset.zero}) {
      final angle = startAngle + sweepAngle * angleFraction;
      final labelRadius = radius - strokeWidth - 14;
      final x = center.dx + labelRadius * math.cos(angle) + offset.dx;
      final y = center.dy + labelRadius * math.sin(angle) + offset.dy;

      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    drawTickLabel('-${maxScale.toStringAsFixed(1)}', 0.05, offset: const Offset(14, 4));
    drawTickLabel('0.0', 0.50, offset: const Offset(0, -6));
    drawTickLabel('+${maxScale.toStringAsFixed(1)}', 0.95, offset: const Offset(-14, 4));

    // 5. Calculate Needle Angle dynamically adapted to maxScale
    final clampedMa = currentMa.clamp(-maxScale, maxScale);
    final fraction = (clampedMa + maxScale) / (2.0 * maxScale);
    final needleAngle = startAngle + sweepAngle * fraction;

    // 6. Draw Needle
    final needleLength = radius + 6;
    final needleTip = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    // Needle shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center + const Offset(1, 2),
      needleTip + const Offset(1, 2),
      shadowPaint,
    );

    // Needle body
    final needlePaint = Paint()
      ..color = isDark ? Colors.white : const Color(0xFF0F172A)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleTip, needlePaint);

    // 7. Center Hub / Pivot Pin
    final hubBorderPaint = Paint()
      ..color = isDark ? Colors.grey.shade600 : const Color(0xFF475569)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 9, hubBorderPaint);

    final hubInnerPaint = Paint()
      ..color = isDark ? Colors.white : const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, hubInnerPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter oldDelegate) {
    return oldDelegate.currentMa != currentMa ||
        oldDelegate.isCharging != isCharging ||
        oldDelegate.isDark != isDark;
  }
}
