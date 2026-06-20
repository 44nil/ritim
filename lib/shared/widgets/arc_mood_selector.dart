import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MoodOption {
  const MoodOption({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;
}

class ArcMoodSelector extends StatefulWidget {
  const ArcMoodSelector({
    super.key,
    required this.onMoodSelected,
  });

  final ValueChanged<MoodOption> onMoodSelected;

  static const moods = [
    MoodOption(label: 'Mutsuz', icon: Icons.sentiment_very_dissatisfied_rounded, color: Color(0xFFCF7B9E)),
    MoodOption(label: 'Hassas', icon: Icons.sentiment_dissatisfied_rounded, color: Color(0xFFD08DB0)),
    MoodOption(label: 'Sakin', icon: Icons.sentiment_neutral_rounded, color: Color(0xFFB89DC8)),
    MoodOption(label: 'İyi', icon: Icons.sentiment_satisfied_rounded, color: Color(0xFF9BAAD4)),
    MoodOption(label: 'Harika', icon: Icons.sentiment_very_satisfied_rounded, color: Color(0xFF8BB5D4)),
  ];

  @override
  State<ArcMoodSelector> createState() => _ArcMoodSelectorState();
}

class _ArcMoodSelectorState extends State<ArcMoodSelector> {
  int _selectedIndex = 2;

  static const _startAngle = math.pi * 0.8;
  static const _sweepAngle = math.pi * 0.4;

  double _angleForIndex(int index) {
    final t = index / (ArcMoodSelector.moods.length - 1);
    return _startAngle + _sweepAngle * t;
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final pos = details.localPosition;
    final angle = math.atan2(center.dy - pos.dy, pos.dx - center.dx);
    final normalized = math.pi - angle;

    int closest = 0;
    double minDist = double.infinity;
    for (int i = 0; i < ArcMoodSelector.moods.length; i++) {
      final d = (normalized - _angleForIndex(i)).abs();
      if (d < minDist) {
        minDist = d;
        closest = i;
      }
    }

    if (closest != _selectedIndex) {
      setState(() => _selectedIndex = closest);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mood = ArcMoodSelector.moods[_selectedIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Bugün nasıl\nhissediyorsun?',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Kaydırarak seç',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 12),

        // Seçili ruh hali etiketi
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(_selectedIndex),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: mood.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              mood.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: mood.color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Yay seçici
        SizedBox(
          width: double.infinity,
          height: 200,
          child: GestureDetector(
            onPanUpdate: (d) => _onPanUpdate(d, Size(MediaQuery.of(context).size.width - 48, 200)),
            child: CustomPaint(
              painter: _ArcPainter(
                selectedIndex: _selectedIndex,
                moods: ArcMoodSelector.moods,
                isDark: theme.brightness == Brightness.dark,
              ),
              child: Stack(
                children: [
                  // İkonları yay üzerine yerleştir
                  ...ArcMoodSelector.moods.asMap().entries.map((e) {
                    final i = e.key;
                    final m = e.value;
                    final isSelected = i == _selectedIndex;
                    final angle = _angleForIndex(i);

                    return LayoutBuilder(builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      final center = Offset(w / 2, h * 0.85);
                      final radius = w * 0.38;

                      final x = center.dx - math.cos(angle) * radius;
                      final y = center.dy - math.sin(angle) * radius;

                      return Positioned(
                        left: x - (isSelected ? 24 : 18),
                        top: y - (isSelected ? 24 : 18),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isSelected ? 48 : 36,
                            height: isSelected ? 48 : 36,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? m.color
                                  : m.color.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                            ),
                            child: Icon(
                              m.icon,
                              size: isSelected ? 24 : 18,
                              color: isSelected ? Colors.white : m.color,
                            ),
                          ),
                        ),
                      );
                    });
                  }),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Kaydet butonu
        SizedBox(
          width: 200,
          height: 48,
          child: ElevatedButton(
            onPressed: () => widget.onMoodSelected(mood),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Kaydet', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.selectedIndex,
    required this.moods,
    required this.isDark,
  });

  final int selectedIndex;
  final List<MoodOption> moods;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = size.width * 0.38;

    // Yay track
    final trackPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const startAngle = math.pi * 0.8;
    const sweepAngle = math.pi * 0.4;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -startAngle - sweepAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Aktif yay (başlangıçtan seçili noktaya)
    final selectedT = selectedIndex / (moods.length - 1);
    final activePaint = Paint()
      ..color = moods[selectedIndex].color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -startAngle - sweepAngle,
      sweepAngle * selectedT,
      false,
      activePaint,
    );

    // Küçük noktalar (tick marks)
    for (int i = 0; i < 20; i++) {
      final t = i / 19;
      final angle = startAngle + sweepAngle * t;
      final innerR = radius - 16;

      final x = center.dx - math.cos(angle) * innerR;
      final y = center.dy - math.sin(angle) * innerR;

      final dotPaint = Paint()
        ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

      canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.selectedIndex != selectedIndex;
}
