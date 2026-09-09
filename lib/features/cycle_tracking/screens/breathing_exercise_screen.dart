import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/screen_gradient_background.dart';

enum _BreathPhase { inhale, hold, exhale }

/// Kramp/PMS anında sakinleşmeye yardımcı, tamamen yerel (asset gerektirmeyen)
/// bir nefes egzersizi — büyüyüp küçülen bir "balon" eşliğinde 4-4-4 saniyelik
/// nefes al/tut/ver döngüsü. İnternet ya da dış görsel gerekmiyor, saf animasyon.
class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  static const _phaseDuration = Duration(seconds: 4);
  static const _phases = [_BreathPhase.inhale, _BreathPhase.hold, _BreathPhase.exhale];

  late final AnimationController _controller;
  int _phaseIndex = 0;
  int _cycleCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _phaseDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          _advancePhase();
        }
      });
    _runPhase();
  }

  void _runPhase() {
    final phase = _phases[_phaseIndex];
    switch (phase) {
      case _BreathPhase.inhale:
        _controller.forward(from: 0);
      case _BreathPhase.hold:
        _controller.value = 1;
        Future.delayed(_phaseDuration, () { if (mounted) _advancePhase(); });
      case _BreathPhase.exhale:
        _controller.reverse(from: 1);
    }
  }

  void _advancePhase() {
    if (!mounted) return;
    setState(() {
      final wasLastPhase = _phaseIndex == _phases.length - 1;
      _phaseIndex = (_phaseIndex + 1) % _phases.length;
      if (wasLastPhase) _cycleCount++;
    });
    _runPhase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _phaseLabel => switch (_phases[_phaseIndex]) {
        _BreathPhase.inhale => 'Nefes al',
        _BreathPhase.hold => 'Tut',
        _BreathPhase.exhale => 'Ver',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardOn(context),
      body: Stack(fit: StackFit.expand, children: [
        const ScreenGradientBackground(),
        SafeArea(child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.close_rounded, color: AppColors.inkOn(context)),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          const Spacer(),
          Text('Birlikte nefes alalım', style: AppTextStyles.heading(fontSize: 22, color: AppColors.inkOn(context))),
          const SizedBox(height: 8),
          Text(
            'Balonu izle, onunla birlikte nefes al.',
            style: TextStyle(fontSize: 13.5, color: AppColors.inkOn(context).withValues(alpha: 0.55)),
          ),
          const SizedBox(height: 48),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = 0.55 + (_controller.value * 0.45);
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [AppColors.softPink.withValues(alpha: 0.55), AppColors.warmOrange.withValues(alpha: 0.55)],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _phaseLabel,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.inkOn(context)),
              ),
            ),
          ),
          const SizedBox(height: 48),
          if (_cycleCount > 0)
            Text('$_cycleCount tur tamamladın 🌸', style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.5))),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(color: AppColors.inkOn(context), borderRadius: BorderRadius.circular(24)),
                child: Text('Bitir', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.cardOn(context))),
              ),
            ),
          ),
        ])),
      ]),
    );
  }
}
