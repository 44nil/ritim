import 'dart:math' as math;
import 'package:flutter/material.dart';

class MeshGradientBg extends StatefulWidget {
  const MeshGradientBg({super.key, this.isDark = false});
  final bool isDark;

  @override
  State<MeshGradientBg> createState() => _MeshGradientBgState();
}

class _MeshGradientBgState extends State<MeshGradientBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDark) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF201820), Color(0xFF151015)],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final s1 = math.sin(t * 2 * math.pi) * 30;
        final s2 = math.cos(t * 2 * math.pi) * 25;
        final s3 = math.sin(t * 2 * math.pi + 1.5) * 20;

        return Stack(
          children: [
            Container(color: const Color(0xFFFDE8E8)),

            // Blob 1 — sağ üst: coral (hareket ediyor)
            Positioned(
              top: -80 + s1,
              right: -60 + s2,
              child: _Blob(
                size: 350,
                color: const Color(0xFFF0A08A),
              ),
            ),

            // Blob 2 — sol orta: pembe (hareket ediyor)
            Positioned(
              top: 200 + s2,
              left: -100 + s3,
              child: _Blob(
                size: 450,
                color: const Color(0xFFF5A0B8),
              ),
            ),

            // Blob 3 — sağ alt: canlı pembe
            Positioned(
              bottom: 100 + s3,
              right: -50 + s1,
              child: _Blob(
                size: 400,
                color: const Color(0xFFE880A0),
              ),
            ),

            // Blob 4 — sol alt: peach
            Positioned(
              bottom: -50 + s2,
              left: -30 + s1,
              child: _Blob(
                size: 350,
                color: const Color(0xFFF0B898),
              ),
            ),

            // Blob 5 — üst sol: lavanta
            Positioned(
              top: 50 + s3,
              left: 50 + s2,
              child: _Blob(
                size: 300,
                color: const Color(0xFFF8D0D8),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
