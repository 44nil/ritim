import 'dart:math' as math;
import 'package:flutter/material.dart';

class CycleWheelData {
  const CycleWheelData({
    required this.currentDay,
    required this.cycleLength,
    required this.periodDays,
    required this.ovulationDays,
    required this.phases,
  });

  final int currentDay;
  final int cycleLength;
  final int periodDays;
  final List<int> ovulationDays;
  final List<CycleWheelPhase> phases;
}

class CycleWheelPhase {
  const CycleWheelPhase({required this.label, required this.startDay, required this.endDay, required this.color});
  final String label;
  final int startDay;
  final int endDay;
  final Color color;
}

class CycleWheel extends StatelessWidget {
  const CycleWheel({
    super.key,
    required this.data,
    required this.onAddTap,
    this.size = 320,
  });

  final CycleWheelData data;
  final VoidCallback onAddTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSize = size > 0 ? size : 320.0;

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Çark
          CustomPaint(
            size: Size(effectiveSize, effectiveSize),
            painter: _WheelPainter(
              data: data,
              isDark: theme.brightness == Brightness.dark,
            ),
          ),

          // Ortadaki bilgi + buton
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${data.currentDay}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '/ ${data.cycleLength} gün',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: onAddTap,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_rounded, size: 24,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({required this.data, required this.isDark});
  final CycleWheelData data;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 4;
    final dotRadius = size.width * 0.032;
    final currentDotRadius = size.width * 0.05;

    // Her gün için açı hesapla (12 o'clock = 0, saat yönünde)
    for (int day = 1; day <= data.cycleLength; day++) {
      final angle = -math.pi / 2 + (2 * math.pi * (day - 1) / data.cycleLength);
      final isCurrent = day == data.currentDay;
      final isPast = day < data.currentDay;

      // Faz rengini bul
      Color dotColor = Colors.grey.withValues(alpha: 0.2);
      for (final phase in data.phases) {
        if (day >= phase.startDay && day <= phase.endDay) {
          dotColor = phase.color;
          break;
        }
      }

      // Geçmiş günler dolu, gelecek günler soluk
      if (!isPast && !isCurrent) {
        dotColor = dotColor.withValues(alpha: 0.25);
      }

      final r = isCurrent ? currentDotRadius : dotRadius;
      final radius = outerRadius - (isCurrent ? 0 : 4);
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      final paint = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), r, paint);

      // Bugünün gün sayısını yaz
      if (isCurrent) {
        // Beyaz border
        final borderPaint = Paint()
          ..color = isDark ? const Color(0xFF1A1518) : Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(Offset(x, y), r + 2, borderPaint);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '$day',
            style: TextStyle(
              fontSize: size.width * 0.038,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
      }
    }

    // Faz etiketlerini yay üzerine yaz
    for (final phase in data.phases) {
      final midDay = (phase.startDay + phase.endDay) / 2;
      final angle = -math.pi / 2 + (2 * math.pi * (midDay - 1) / data.cycleLength);
      final labelRadius = outerRadius * 0.68;
      final x = center.dx + math.cos(angle) * labelRadius;
      final y = center.dy + math.sin(angle) * labelRadius;

      final textPainter = TextPainter(
        text: TextSpan(
          text: phase.label.toUpperCase(),
          style: TextStyle(
            fontSize: size.width * 0.032,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: phase.color.withValues(alpha: 0.6),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + math.pi / 2);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }

    // İç çember çizgileri (dekoratif)
    final innerCirclePaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, outerRadius * 0.52, innerCirclePaint);
    canvas.drawCircle(center, outerRadius * 0.38, innerCirclePaint);
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.data.currentDay != data.currentDay;
}
