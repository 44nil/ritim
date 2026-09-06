import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/screen_gradient_background.dart';

// Not: Bu ekran daha önce sabit kodlanmış, kurgusal doktor isimleri ve
// önceden yazılmış cevaplar içeriyordu — gerçek bir uzman tarafından
// onaylanmamış içeriği "cevaplandı" gibi gösteriyordu. Gerçek, uzman
// onaylı bir içerik/soru akışı kurulana kadar dürüst bir bekleme
// durumu gösteriyoruz. Bkz. docs/legal-compliance-notes.md.
class QaScreen extends StatelessWidget {
  const QaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardOn(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ScreenGradientBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text('Uzman\nPaneli', style: AppTextStyles.heading(fontSize: 32, color: AppColors.inkOn(context))),
                  const SizedBox(height: 4),
                  Text('yakında burada.', style: AppTextStyles.accent(fontSize: 18, color: AppColors.softPink)),
                  const SizedBox(height: 32),
                  CleanCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.hourglass_top_rounded, color: AppColors.softPink, size: 28),
                        const SizedBox(height: 14),
                        Text('Bu bölüm henüz hazır değil', style: AppTextStyles.heading(fontSize: 18, color: AppColors.inkOn(context))),
                        const SizedBox(height: 8),
                        Text(
                          'Gerçek bir uzman tarafından onaylanmış soru-cevap içeriği '
                          'burada yayınlanmadan önce göstermek istemedik. Hazır olduğunda '
                          'bu bölüm gerçek, onaylı içerikle güncellenecek.',
                          style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.6), height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
