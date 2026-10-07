import 'dart:math' as math;
import 'package:flutter/material.dart';

class MiniDialGaugeCard extends StatelessWidget {
  final String title;
  final String valueText;
  final double fraction; // 0.0 to 1.0
  final List<Color> arcColors;
  final VoidCallback? onTap;

  const MiniDialGaugeCard({
    super.key,
    required this.title,
    required this.valueText,
    required this.fraction,
    required this.arcColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Colors.white;
    final titleColor = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final valueColor = isDark ? const Color(0xFF38BDF8) : const Color(0xFF1E3A8A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mini Speedometer Canvas
            SizedBox(
              height: 48,
              width: 80,
              child: CustomPaint(
                painter: _MiniDialPainter(
                  fraction: fraction.clamp(0.0, 1.0),
                  arcColors: arcColors,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valueText,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniDialPainter extends CustomPainter {
  final double fraction;
  final List<Color> arcColors;
  final bool isDark;

  _MiniDialPainter({
    required this.fraction,
    required this.arcColors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.44;

    const startAngle = math.pi + 0.35; // 200°
    const sweepAngle = math.pi - 0.70; // 140°
    const strokeWidth = 5.5;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw multi-color segments along the arc
    if (arcColors.length > 1) {
      final segSweep = sweepAngle / arcColors.length;
      for (int i = 0; i < arcColors.length; i++) {
        final paint = Paint()
          ..color = arcColors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = (i == 0 || i == arcColors.length - 1)
              ? StrokeCap.round
              : StrokeCap.butt;
        canvas.drawArc(rect, startAngle + i * segSweep, segSweep, false, paint);
      }
    } else {
      final paint = Paint()
        ..color = arcColors.first
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }

    // Needle Angle
    final needleAngle = startAngle + sweepAngle * fraction;
    final needleLength = radius + 2;
    final needleTip = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    // Needle
    final needlePaint = Paint()
      ..color = isDark ? Colors.white : const Color(0xFF0F172A)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleTip, needlePaint);

    // Hub Pin
    final hubPaint = Paint()
      ..color = isDark ? Colors.white70 : const Color(0xFF475569)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, hubPaint);
  }

  @override
  bool shouldRepaint(covariant _MiniDialPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.arcColors != arcColors ||
        oldDelegate.isDark != isDark;
  }
}

class MiniIconTelemetryCard extends StatelessWidget {
  final String title;
  final String valueText;
  final Widget icon;
  final VoidCallback? onTap;

  const MiniIconTelemetryCard({
    super.key,
    required this.title,
    required this.valueText,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Colors.white;
    final titleColor = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final valueColor = isDark ? const Color(0xFF38BDF8) : const Color(0xFF1E3A8A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 48,
              child: Center(child: icon),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valueText,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
