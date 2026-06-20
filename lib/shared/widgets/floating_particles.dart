import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key, this.count = 18});
  final int count;

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _particles = List.generate(widget.count, (_) => _Particle(_rng));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? Colors.white
        : const Color(0xFFD88B9A);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        size: Size.infinite,
        painter: _ParticlePainter(
          particles: _particles,
          progress: _controller.value,
          color: baseColor,
        ),
      ),
    );
  }
}

class _Particle {
  _Particle(math.Random rng)
      : x = rng.nextDouble(),
        startY = 0.5 + rng.nextDouble() * 0.5,
        speed = 0.2 + rng.nextDouble() * 0.3,
        size = 4 + rng.nextDouble() * 8,
        opacity = 0.15 + rng.nextDouble() * 0.2,
        drift = (rng.nextDouble() - 0.5) * 0.12,
        phase = rng.nextDouble() * 2 * math.pi;

  final double x;
  final double startY;
  final double speed;
  final double size;
  final double opacity;
  final double drift;
  final double phase;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  final List<_Particle> particles;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.startY) % 1.3;
      final y = size.height * (1.1 - t);
      final wobble = math.sin(progress * 2 * math.pi + p.phase) * size.width * p.drift;
      final x = size.width * p.x + wobble;

      final fadeIn = t.clamp(0.0, 0.15) / 0.15;
      final fadeOut = t > 0.9 ? (1.3 - t) / 0.4 : 1.0;
      final alpha = p.opacity * fadeIn * fadeOut;

      if (alpha <= 0.01) continue;

      final paint = Paint()
        ..color = color.withValues(alpha: alpha);

      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}
