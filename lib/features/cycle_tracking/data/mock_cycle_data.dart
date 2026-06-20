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

  static const userName = 'Ela';
  static const cycleLengthDays = 28;
  static const periodLengthDays = 5;
  static const currentCycleDay = 14;

  static final currentDate = DateTime.now();
  static final periodStartDate = currentDate.subtract(
    const Duration(days: currentCycleDay - 1),
  );
  static final nextPeriodDate = periodStartDate.add(
    const Duration(days: cycleLengthDays),
  );
  static int get daysUntilNextPeriod =>
      nextPeriodDate.difference(currentDate).inDays;

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
      tip: 'Enerjin yükseliyor! Yeni şeyler denemek için harika bir dönem.',
      dayRange: (6, 13),
      bodyInfo: 'Vücudun yeni bir yumurta hazırlamaya başlıyor. Östrojen hormonu yükseliyor — bu sayede enerjin artıyor, kendini daha iyi hissedebilirsin.',
      selfCare: ['Yeni aktiviteler dene', 'Sosyalleşmek için iyi bir dönem', 'Enerjini değerlendir', 'Yaratıcı projeler başlat'],
    ),
    CyclePhaseInfo(
      phase: CyclePhase.ovulation,
      label: 'Ovülasyon',
      color: AppColors.phaseOvulation,
      icon: Icons.brightness_high_rounded,
      tip: 'Enerjin en yüksek seviyede. Sosyal aktiviteler için ideal bir dönem.',
      dayRange: (14, 16),
      bodyInfo: 'Yumurtalıktan bir yumurta serbest bırakılıyor. Bu dönemde enerjin ve özgüvenin en yüksek seviyede olabilir. Vücut ısın hafifçe artabilir.',
      selfCare: ['En enerjik dönemin', 'Spor için ideal', 'Özgüvenin yüksek', 'Sosyal aktiviteler planla'],
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

  static CyclePhaseInfo get currentPhase {
    for (final phase in phases) {
      if (currentCycleDay >= phase.dayRange.$1 &&
          currentCycleDay <= phase.dayRange.$2) {
        return phase;
      }
    }
    return phases.last;
  }

  static double get cycleProgress => currentCycleDay / cycleLengthDays;

  static List<DayInfo> get last7Days {
    return List.generate(7, (i) {
      final dayOffset = 6 - i;
      final date = currentDate.subtract(Duration(days: dayOffset));
      final cycleDay = currentCycleDay - dayOffset;
      final adjustedDay = cycleDay > 0 ? cycleDay : cycleLengthDays + cycleDay;

      CyclePhaseInfo phaseForDay = phases.last;
      for (final phase in phases) {
        if (adjustedDay >= phase.dayRange.$1 &&
            adjustedDay <= phase.dayRange.$2) {
          phaseForDay = phase;
          break;
        }
      }

      return DayInfo(
        date: date,
        cycleDay: adjustedDay,
        phase: phaseForDay,
        isToday: dayOffset == 0,
      );
    });
  }

  static const didYouKnow = [
    'Ortalama bir kadın hayatında yaklaşık 450 kez adet görür.',
    'Döngü uzunluğu 21-35 gün arasında değişebilir ve hepsi normaldir.',
    'Egzersiz yapmak adet kramplarını azaltmaya yardımcı olabilir.',
    'İlk adet genellikle 10-15 yaş arasında başlar.',
    'Stres döngü düzenini etkileyebilir.',
    'Adet sırasında vücut ısısı hafifçe düşer, ovülasyonda yükselir.',
    'Yeterli uyku hormonal dengeyi korumaya yardımcı olur.',
  ];
}

class DayInfo {
  const DayInfo({
    required this.date,
    required this.cycleDay,
    required this.phase,
    required this.isToday,
  });

  final DateTime date;
  final int cycleDay;
  final CyclePhaseInfo phase;
  final bool isToday;
}
