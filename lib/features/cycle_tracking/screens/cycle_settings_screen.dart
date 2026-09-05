import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/screen_gradient_background.dart';

class CycleSettingsScreen extends ConsumerStatefulWidget {
  const CycleSettingsScreen({super.key});

  @override
  ConsumerState<CycleSettingsScreen> createState() => _CycleSettingsScreenState();
}

class _CycleSettingsScreenState extends ConsumerState<CycleSettingsScreen> {
  late int _length = ref.read(cycleProvider).averageCycleLength;

  @override
  Widget build(BuildContext context) {
    final cycle = ref.watch(cycleProvider);
    // Gerçek döngü geçmişi (3+ döngü) varsa ortalama artık ölçülen bir
    // veri — kullanıcının elle değiştirmesi anlamsız, sadece bilgi olarak
    // gösterilir. Henüz yeterli veri yoksa (reportedCycleLength'e dayanan
    // tahmini varsayım) düzenlenebilir.
    final isMeasured = cycle.canPredict;

    return Scaffold(
      backgroundColor: AppColors.cardCream,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      body: Stack(children: [
        const ScreenGradientBackground(),
        SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Döngü\nAyarları', style: AppTextStyles.heading(fontSize: 28, color: AppColors.ink)),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(20)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Ortalama döngü uzunluğu', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.6))),
                const SizedBox(height: 4),
                Text(
                  isMeasured
                      ? 'Bu, kayıtlarından hesaplanan gerçek bir ortalama — elle değiştirilemez.'
                      : 'Henüz yeterli kayıt yok, bu senin verdiğin bir tahmin. Değiştirebilirsin.',
                  style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.4)),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (!isMeasured) _StepBtn(icon: Icons.remove_rounded, onTap: () => setState(() => _length = (_length - 1).clamp(21, 45))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('${isMeasured ? cycle.averageCycleLength : _length} gün', style: AppTextStyles.heading(fontSize: 24, color: AppColors.ink)),
                  ),
                  if (!isMeasured) _StepBtn(icon: Icons.add_rounded, onTap: () => setState(() => _length = (_length + 1).clamp(21, 45))),
                ]),
              ]),
            ),
            const Spacer(),
            if (!isMeasured)
              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cycleProvider.notifier).setReportedCycleLength(_length);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.ink, foregroundColor: Colors.white),
                  child: const Text('Kaydet', style: TextStyle(fontSize: 16)),
                ),
              ),
          ]),
        )),
      ]),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.softPink.withValues(alpha: 0.2)),
        child: Icon(icon, size: 20, color: AppColors.softPink),
      ),
    );
  }
}
