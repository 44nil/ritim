import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';

// Kalıcı depodan önceki kayıtların yüklenmesini bekleyip, kullanıcıyı
// duruma göre yönlendirir: onboarding'i bitirmişse direkt Döngüm'e, yoksa
// onboarding'e. Bu bekleme olmadan, kalıcı veri henüz yüklenmeden karar
// verilir ve tamamlamış bir kullanıcı bile her açılışta baştan onboarding
// görür.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await ref.read(cycleProvider.notifier).ready;
    if (!mounted) return;
    final cycle = ref.read(cycleProvider);
    // Tahmini regl tarihi son açılıştan beri değişmiş olabilir (yeni kayıt,
    // yeni döngü) — açılışta yeniden planlamak bunu güncel tutar.
    if (cycle.periodReminderEnabled) {
      NotificationService.reschedulePeriodReminder(cycle, enabled: true, daysBefore: cycle.periodReminderDaysBefore);
    }
    context.go(cycle.hasCompletedOnboarding ? '/cycle-tracking' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardOn(context),
      body: Center(
        child: Icon(Icons.favorite_rounded, color: AppColors.softPink.withValues(alpha: 0.5), size: 48),
      ),
    );
  }
}
