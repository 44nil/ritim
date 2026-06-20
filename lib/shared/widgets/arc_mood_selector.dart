import 'dart:math' as math;
import 'package:flutter/material.dart';

class MoodOption {
  const MoodOption({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;
}

class ArcMoodSelector extends StatefulWidget {
  const ArcMoodSelector({super.key, required this.onMoodSelected});
  final ValueChanged<MoodOption> onMoodSelected;

  static const moods = [
    MoodOption(label: 'Kötü', icon: Icons.sentiment_very_dissatisfied_rounded, color: Color(0xFFCF7B9E)),
    MoodOption(label: 'Mutsuz', icon: Icons.sentiment_dissatisfied_rounded, color: Color(0xFFBB85B8)),
    MoodOption(label: 'Hassas', icon: Icons.sentiment_neutral_rounded, color: Color(0xFFAA8EC8)),
    MoodOption(label: 'Sakin', icon: Icons.favorite_rounded, color: Color(0xFF9598D8)),
    MoodOption(label: 'İyi', icon: Icons.sentiment_satisfied_rounded, color: Color(0xFF8BA5D8)),
    MoodOption(label: 'Mutlu', icon: Icons.sentiment_satisfied_alt_rounded, color: Color(0xFF7BAED4)),
    MoodOption(label: 'Harika', icon: Icons.sentiment_very_satisfied_rounded, color: Color(0xFF6BB8D4)),
  ];

  @override
  State<ArcMoodSelector> createState() => _ArcMoodSelectorState();
}

class _ArcMoodSelectorState extends State<ArcMoodSelector> {
  double _progress = 0.43; // 0.0 - 1.0 (Sakin default)

  int get _selectedIndex =>
      (_progress * (ArcMoodSelector.moods.length - 1)).round().clamp(0, ArcMoodSelector.moods.length - 1);

  MoodOption get _selectedMood => ArcMoodSelector.moods[_selectedIndex];

  // Yay geometrisi
  static const _arcStartAngle = math.pi * 1.15; // sol taraftan başla
  static const _arcSweepAngle = math.pi * 0.7;  // geniş yay

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mood = _selectedMood;

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
        const SizedBox(height: 6),
        Text(
          'Yay üzerinde kaydırarak seç',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 24),

        // Yay + ikonlar + thumb
        SizedBox(
          width: double.infinity,
          height: 260,
          child: LayoutBuilder(builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final centerX = w / 2;
            final centerY = h * 0.92;
            final arcRadius = w * 0.42;

            return GestureDetector(
              onPanUpdate: (d) => _handleDrag(d.localPosition, centerX, centerY, arcRadius),
              onTapDown: (d) => _handleDrag(d.localPosition, centerX, centerY, arcRadius),
              child: CustomPaint(
                painter: _ArcTrackPainter(
                  progress: _progress,
                  selectedColor: mood.color,
                  isDark: theme.brightness == Brightness.dark,
                  arcRadius: arcRadius,
                  center: Offset(centerX, centerY),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Mood ikonları — yay etrafında dağılmış
                    ...ArcMoodSelector.moods.asMap().entries.map((e) {
                      final i = e.key;
                      final m = e.value;
                      final t = i / (ArcMoodSelector.moods.length - 1);
                      final angle = _arcStartAngle + _arcSweepAngle * t;
                      final isSelected = i == _selectedIndex;

                      // İkonları yayın biraz dışına yerleştir
                      final iconRadius = arcRadius + (isSelected ? 38 : 32);
                      final x = centerX + math.cos(angle) * iconRadius;
                      final y = centerY + math.sin(angle) * iconRadius;
                      final size = isSelected ? 40.0 : 28.0;

                      return Positioned(
                        left: x - size / 2,
                        top: y - size / 2,
                        child: GestureDetector(
                          onTap: () => setState(() => _progress = t),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: isSelected ? m.color : m.color.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 2.5)
                                  : null,
                              boxShadow: isSelected
                                  ? [BoxShadow(color: m.color.withValues(alpha: 0.3), blurRadius: 12)]
                                  : null,
                            ),
                            child: Icon(
                              m.icon,
                              size: isSelected ? 22 : 14,
                              color: isSelected ? Colors.white : m.color,
                            ),
                          ),
                        ),
                      );
                    }),

                    // Seçili mood etiketi — yayın ortasında
                    Positioned(
                      left: 0,
                      right: 0,
                      top: h * 0.35,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: Text(
                          mood.label,
                          key: ValueKey(_selectedIndex),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: mood.color,
                          ),
                        ),
                      ),
                    ),

                    // Thumb — yay üzerinde sürüklenen nokta
                    Builder(builder: (context) {
                      final angle = _arcStartAngle + _arcSweepAngle * _progress;
                      final tx = centerX + math.cos(angle) * arcRadius;
                      final ty = centerY + math.sin(angle) * arcRadius;

                      return Positioned(
                        left: tx - 14,
                        top: ty - 14,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: mood.color, width: 3),
                            boxShadow: [
                              BoxShadow(color: mood.color.withValues(alpha: 0.3), blurRadius: 8),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),

        // Onay butonu
        GestureDetector(
          onTap: () => widget.onMoodSelected(mood),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2D2028),
              shape: BoxShape.circle,
              border: Border.all(
                color: mood.color.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_selectedIndex + 1} / ${ArcMoodSelector.moods.length}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  void _handleDrag(Offset pos, double cx, double cy, double radius) {
    final dx = pos.dx - cx;
    final dy = pos.dy - cy;
    var angle = math.atan2(dy, dx);

    // Normalize angle to arc range
    var t = (angle - _arcStartAngle) / _arcSweepAngle;
    t = t.clamp(0.0, 1.0);

    setState(() => _progress = t);
  }
}

// ─── Arc Track Painter ──────────────────────────────────────────────────────

class _ArcTrackPainter extends CustomPainter {
  _ArcTrackPainter({
    required this.progress,
    required this.selectedColor,
    required this.isDark,
    required this.arcRadius,
    required this.center,
  });

  final double progress;
  final Color selectedColor;
  final bool isDark;
  final double arcRadius;
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    const startAngle = _ArcMoodSelectorState._arcStartAngle;
    const sweepAngle = _ArcMoodSelectorState._arcSweepAngle;

    // Arka plan track
    final trackPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Aktif yay (gradient efektli)
    final activePaint = Paint()
      ..color = selectedColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      startAngle,
      sweepAngle * progress,
      false,
      activePaint,
    );

    // Tick marks — yay boyunca küçük noktalar
    final tickCount = 30;
    for (int i = 0; i <= tickCount; i++) {
      final t = i / tickCount;
      final angle = startAngle + sweepAngle * t;
      final innerR = arcRadius - 12;

      final x = center.dx + math.cos(angle) * innerR;
      final y = center.dy + math.sin(angle) * innerR;

      final isOnActive = t <= progress;
      final dotPaint = Paint()
        ..color = isOnActive
            ? selectedColor.withValues(alpha: 0.3)
            : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06);

      canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ArcTrackPainter old) =>
      old.progress != progress || old.selectedColor != selectedColor;
}
