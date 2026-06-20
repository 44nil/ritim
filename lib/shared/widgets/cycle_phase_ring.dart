import 'dart:math' as math;
import 'package:flutter/material.dart';

class CyclePhaseRing extends StatefulWidget {
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
  State<CyclePhaseRing> createState() => _CyclePhaseRingState();
}

class _CyclePhaseRingState extends State<CyclePhaseRing>
    with TickerProviderStateMixin {
  late final AnimationController _fillController;
  late final AnimationController _pulseController;
  late final Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();

    // Dolma animasyonu — 0'dan hedef değere
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fillAnimation = CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeOutCubic,
    );
    _fillController.forward();

    // Nabız — sürekli hafif nefes alma
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fillController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ??
        theme.colorScheme.outline.withValues(alpha: 0.1);

    return AnimatedBuilder(
      animation: Listenable.merge([_fillAnimation, _pulseController]),
      builder: (context, child) {
        final pulseScale = 1.0 + _pulseController.value * 0.04;
        final currentProgress = widget.progress * _fillAnimation.value;

        return Transform.scale(
          scale: pulseScale,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Nabız glow
                Container(
                  width: widget.size + 8,
                  height: widget.size + 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.phaseColor.withValues(
                          alpha: 0.12 * _pulseController.value,
                        ),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
                // Halka
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _RingPainter(
                    progress: currentProgress,
                    activeColor: widget.phaseColor,
                    trackColor: bgColor,
                    strokeWidth: widget.strokeWidth,
                  ),
                ),
                // Gün sayısı
                child!,
              ],
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.currentDay}',
            style: theme.textTheme.displayMedium?.copyWith(
              color: widget.phaseColor,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          Text(
            'gün',
            style: theme.textTheme.labelSmall?.copyWith(
              color: widget.phaseColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
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

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

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
