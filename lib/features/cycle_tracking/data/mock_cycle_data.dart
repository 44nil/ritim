import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum CyclePhase { menstruation, follicular, ovulation, luteal }

class CyclePhaseInfo {
  const CyclePhaseInfo({
    required this.phase,
    required this.label,
    required this.color,
    required this.icon,
    required this.tip,
    required this.dayRange,
    required this.bodyInfo,
    required this.selfCare,
  });

  final CyclePhase phase;
  final String label;
  final Color color;
  final IconData icon;
  final String tip;
  final (int start, int end) dayRange;
  final String bodyInfo;
  final List<String> selfCare;
}

class MockCycleData {
  MockCycleData._();

  // Faz sınırları 28 günlük bir döngü baz alınarak tanımlandı (aşağıda).
  // Gerçek kullanıcı döngüsü bundan farklı uzunluktaysa phaseForDay bu
  // sınırları oranlayarak (örn. 21 günlük döngüde adet fazı 1-4 olur) uyarlar.
  static const _referenceCycleLength = 28;

  static const phases = [
    CyclePhaseInfo(
      phase: CyclePhase.menstruation,
      label: 'Adet',
      color: AppColors.phaseMenstruation,
      icon: Icons.water_drop_rounded,
      tip: 'Kendine nazik ol, bol su iç ve dinlenmeye vakit ayır.',
      dayRange: (1, 5),
      bodyInfo: 'Rahim iç tabakası dökülüyor ve kanama oluyor. Bu tamamen doğal bir süreç — vücudun kendini yeniliyor. Hafif kramplar, yorgunluk veya ruh hali değişimleri yaşayabilirsin.',
      selfCare: ['Sıcak su torbası krampları rahatlatır', 'Bol su iç', 'Hafif yürüyüş iyi gelir', 'Uyku düzenine dikkat et'],
    ),
    CyclePhaseInfo(
      phase: CyclePhase.follicular,
      label: 'Foliküler',
      color: AppColors.phaseFollicular,
      icon: Icons.eco_rounded,
      tip: 'Bazı kızlar bu dönemde kendini daha enerjik hissediyor — sen nasıl hissettiğine bak.',
      dayRange: (6, 13),
      bodyInfo: 'Vücudun yeni bir yumurta hazırlamaya başlıyor, östrojen hormonu yükseliyor. Bu, bazılarında enerji artışıyla birlikte gelebilir — ama herkes aynı şekilde hissetmez, ikisi de normal.',
      selfCare: ['Kendini enerjik hissediyorsan yeni bir şey dene', 'Canın isterse sosyalleş', 'İstersen yaratıcı bir projeye başla', 'Hiçbir şey yapmak zorunda değilsin'],
    ),
    CyclePhaseInfo(
      phase: CyclePhase.ovulation,
      label: 'Ovülasyon',
      color: AppColors.phaseOvulation,
      icon: Icons.brightness_high_rounded,
      tip: 'Bazı kızlar bu dönemde kendini daha enerjik ve özgüvenli hissediyor.',
      dayRange: (14, 16),
      bodyInfo: 'Yumurtalıktan bir yumurta serbest bırakılıyor. Bazılarında bu dönemde enerji ve özgüven hissi artabilir, vücut ısısı hafifçe yükselebilir — ama bu herkeste aynı olmuyor.',
      selfCare: ['Kendini enerjik hissediyorsan hareket etmek iyi gelebilir', 'İstersen sosyalleş', 'Nasıl hissettiğine güven', 'Zorlamana gerek yok'],
    ),
    CyclePhaseInfo(
      phase: CyclePhase.luteal,
      label: 'Luteal',
      color: AppColors.phaseLuteal,
      icon: Icons.nights_stay_rounded,
      tip: 'Enerjin azalabilir, bu tamamen normal. Rahatlatıcı aktiviteler dene.',
      dayRange: (17, 28),
      bodyInfo: 'Progesteron hormonu yükseliyor. Vücudun bir sonraki adete hazırlanıyor. Bu dönemde şişkinlik, hassasiyet veya ruh hali değişimleri yaşamak normal.',
      selfCare: ['Kendine vakit ayır', 'Rahatlatıcı müzik dinle', 'Sıcak içecekler iç', 'Fazla zorlama, dinlen'],
    ),
  ];

  // Kullanıcının gerçek döngü gününü (cycleProvider'dan) ve gerçek ortalama
  // döngü uzunluğunu alıp hangi faza denk geldiğini döner. cycleLength 28'den
  // farklıysa referans sınırlar (yukarıdaki phases) oranlanır.
  static CyclePhaseInfo phaseForDay(int cycleDay, {int cycleLength = _referenceCycleLength}) {
    final clampedDay = cycleDay.clamp(1, cycleLength);
    for (final phase in phases) {
      final start = (phase.dayRange.$1 * cycleLength / _referenceCycleLength).round();
      final end = (phase.dayRange.$2 * cycleLength / _referenceCycleLength).round();
      if (clampedDay >= start && clampedDay <= end) return phase;
    }
    return phases.last;
  }
}
