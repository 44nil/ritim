import 'package:flutter/material.dart';

enum MoodFaceType { happy, calm, tired, sensitive, angry, sad }

class MoodFace extends StatelessWidget {
  const MoodFace({super.key, required this.type, required this.color, this.size = 44});
  final MoodFaceType type;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _FacePainter(type: type, color: color),
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  _FacePainter({required this.type, required this.color});
  final MoodFaceType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.18;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final eyeL = Offset(cx - r, cy - r * 0.3);
    final eyeR = Offset(cx + r, cy - r * 0.3);
    final mouthY = cy + r * 0.7;

    switch (type) {
      case MoodFaceType.happy:
        // Gözler: iki nokta
        canvas.drawCircle(eyeL, size.width * 0.04, fillPaint);
        canvas.drawCircle(eyeR, size.width * 0.04, fillPaint);
        // Ağız: geniş gülümseme
        final path = Path()
          ..moveTo(cx - r * 0.9, mouthY - r * 0.2)
          ..quadraticBezierTo(cx, mouthY + r * 0.8, cx + r * 0.9, mouthY - r * 0.2);
        canvas.drawPath(path, paint);

      case MoodFaceType.calm:
        // Gözler: yatay çizgiler (gözler kapalı, rahat)
        canvas.drawLine(Offset(eyeL.dx - r * 0.3, eyeL.dy), Offset(eyeL.dx + r * 0.3, eyeL.dy), paint);
        canvas.drawLine(Offset(eyeR.dx - r * 0.3, eyeR.dy), Offset(eyeR.dx + r * 0.3, eyeR.dy), paint);
        // Ağız: hafif gülümseme
        final path = Path()
          ..moveTo(cx - r * 0.6, mouthY)
          ..quadraticBezierTo(cx, mouthY + r * 0.4, cx + r * 0.6, mouthY);
        canvas.drawPath(path, paint);

      case MoodFaceType.tired:
        // Gözler: yarı kapalı (üst çizgi)
        canvas.drawCircle(eyeL, size.width * 0.035, fillPaint);
        canvas.drawCircle(eyeR, size.width * 0.035, fillPaint);
        canvas.drawLine(Offset(eyeL.dx - r * 0.3, eyeL.dy - r * 0.15), Offset(eyeL.dx + r * 0.3, eyeL.dy - r * 0.05), paint);
        canvas.drawLine(Offset(eyeR.dx - r * 0.3, eyeR.dy - r * 0.05), Offset(eyeR.dx + r * 0.3, eyeR.dy - r * 0.15), paint);
        // Ağız: düz çizgi
        canvas.drawLine(Offset(cx - r * 0.5, mouthY), Offset(cx + r * 0.5, mouthY), paint);

      case MoodFaceType.sensitive:
        // Gözler: büyük yuvarlak gözler
        canvas.drawCircle(eyeL, size.width * 0.05, fillPaint);
        canvas.drawCircle(eyeR, size.width * 0.05, fillPaint);
        // Ağız: dalgalı çizgi
        final path = Path()
          ..moveTo(cx - r * 0.6, mouthY)
          ..quadraticBezierTo(cx - r * 0.3, mouthY - r * 0.3, cx, mouthY)
          ..quadraticBezierTo(cx + r * 0.3, mouthY + r * 0.3, cx + r * 0.6, mouthY);
        canvas.drawPath(path, paint);

      case MoodFaceType.angry:
        // Gözler: açılı kaşlar
        canvas.drawCircle(eyeL, size.width * 0.04, fillPaint);
        canvas.drawCircle(eyeR, size.width * 0.04, fillPaint);
        canvas.drawLine(Offset(eyeL.dx - r * 0.3, eyeL.dy - r * 0.35), Offset(eyeL.dx + r * 0.3, eyeL.dy - r * 0.15), paint);
        canvas.drawLine(Offset(eyeR.dx - r * 0.3, eyeR.dy - r * 0.15), Offset(eyeR.dx + r * 0.3, eyeR.dy - r * 0.35), paint);
        // Ağız: aşağı eğik
        final path = Path()
          ..moveTo(cx - r * 0.6, mouthY - r * 0.1)
          ..quadraticBezierTo(cx, mouthY + r * 0.4, cx + r * 0.6, mouthY - r * 0.1);
        canvas.drawPath(path, paint..style = PaintingStyle.stroke);

      case MoodFaceType.sad:
        // Gözler: iki nokta
        canvas.drawCircle(eyeL, size.width * 0.04, fillPaint);
        canvas.drawCircle(eyeR, size.width * 0.04, fillPaint);
        // Ağız: ters gülümseme (üzgün)
        final path = Path()
          ..moveTo(cx - r * 0.6, mouthY + r * 0.2)
          ..quadraticBezierTo(cx, mouthY - r * 0.5, cx + r * 0.6, mouthY + r * 0.2);
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_FacePainter old) => old.type != type || old.color != color;
}
