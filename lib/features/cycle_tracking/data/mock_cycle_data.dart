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
  });

  final CyclePhase phase;
  final String label;
  final Color color;
  final IconData icon;
  final String tip;
  final (int start, int end) dayRange;
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
    ),
    CyclePhaseInfo(
      phase: CyclePhase.follicular,
      label: 'Foliküler',
      color: AppColors.phaseFollicular,
      icon: Icons.eco_rounded,
      tip: 'Enerjin yükseliyor! Yeni şeyler denemek için harika bir dönem.',
      dayRange: (6, 13),
    ),
    CyclePhaseInfo(
      phase: CyclePhase.ovulation,
      label: 'Ovülasyon',
      color: AppColors.phaseOvulation,
      icon: Icons.brightness_high_rounded,
      tip: 'Enerjin en yüksek seviyede. Sosyal aktiviteler için ideal bir dönem.',
      dayRange: (14, 16),
    ),
    CyclePhaseInfo(
      phase: CyclePhase.luteal,
      label: 'Luteal',
      color: AppColors.phaseLuteal,
      icon: Icons.nights_stay_rounded,
      tip: 'Enerjin azalabilir, bu tamamen normal. Rahatlatıcı aktiviteler dene.',
      dayRange: (17, 28),
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

  // Son 7 günün faz bilgisi
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

  // Mock ruh hali verileri
  static const moods = [
    ('Mutlu', '😊'),
    ('Sakin', '😌'),
    ('Enerjik', '⚡'),
    ('Yorgun', '😴'),
    ('Hassas', '🥺'),
    ('Sinirli', '😤'),
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
