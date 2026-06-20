import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key, this.count = 14, this.color});
  final int count;
  final Color? color;

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
      duration: const Duration(seconds: 20),
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
    final baseColor = widget.color ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFFD88B9A));

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
        startY = 0.8 + rng.nextDouble() * 0.4,
        speed = 0.15 + rng.nextDouble() * 0.25,
        size = 2.5 + rng.nextDouble() * 5,
        opacity = 0.08 + rng.nextDouble() * 0.15,
        drift = (rng.nextDouble() - 0.5) * 0.08,
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
      final t = (progress * p.speed + p.startY) % 1.4;
      final y = size.height * (1.2 - t);
      final x = size.width * p.x + math.sin(progress * 2 * math.pi + p.phase) * size.width * p.drift;

      final fadeIn = (t).clamp(0.0, 0.2) / 0.2;
      final fadeOut = t > 1.0 ? (1.4 - t) / 0.4 : 1.0;
      final alpha = p.opacity * fadeIn * fadeOut;

      if (alpha <= 0) continue;

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.4);

      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
