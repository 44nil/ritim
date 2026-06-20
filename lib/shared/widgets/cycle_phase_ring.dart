import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyclePhaseRing extends StatelessWidget {
  const CyclePhaseRing({
    super.key,
    required this.progress,
    required this.phaseColor,
    required this.currentDay,
    this.size = 120,
    this.strokeWidth = 8,
    this.backgroundColor,
  });

  final double progress;
  final Color phaseColor;
  final int currentDay;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ??
        theme.colorScheme.outline.withValues(alpha: 0.1);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka plan halkası + ilerleme halkası
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress,
              activeColor: phaseColor,
              trackColor: bgColor,
              strokeWidth: strokeWidth,
            ),
          ),
          // Gün sayısı
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currentDay',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: phaseColor,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              Text(
                'gün',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: phaseColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color activeColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Arka plan track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Aktif ilerleme
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeColor != activeColor;
}
