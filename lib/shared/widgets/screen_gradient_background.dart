import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// Ekranın tamamını baştan sona kaplayan sürekli sıcak gradient — ortada
// düz beyaz bir boşluk kalmasın diye. Bir Stack'in ilk çocuğu olarak
// kullanılır; Scaffold'un backgroundColor'ı da AppColors.cardCream
// olmalı (gradient çizilmeden önceki ilk kare için).
//
// Eskiden pembe sadece en tepede (stop 0.0-0.45) görünüyordu, ekranın geri
// kalanı (%55'i) düz turuncuydu — oran dengesizdi. Şimdi iki renk arasında
// tüm yükseklik boyunca sürekli, dengeli bir geçiş var (stops verilmezse
// LinearGradient otomatik 0.0-1.0 arasına eşit dağıtır).
class ScreenGradientBackground extends StatelessWidget {
  const ScreenGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [AppColors.heroPink, AppColors.heroPeach],
            ),
          ),
        ),
      ),
    );
  }
}
