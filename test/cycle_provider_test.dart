import 'package:flutter_test/flutter_test.dart';
import 'package:ritim/core/providers/cycle_provider.dart';
import 'package:ritim/features/cycle_tracking/data/mock_cycle_data.dart';

void main() {
  group('averageCycleLength', () {
    test('gerçek olmayan (1 günlük) bir aralık ortalamayı bozmasın diye 21-45 aralığına sıkıştırılır', () {
      final state = CycleState(periods: [
        PeriodRecord(startDate: DateTime(2026, 1, 1), endDate: DateTime(2026, 1, 1)),
        PeriodRecord(startDate: DateTime(2026, 1, 2), endDate: DateTime(2026, 1, 2)),
      ]);

      expect(state.averageCycleLength, 21);
      // Bu sıkıştırma olmadan phaseForDay(1, cycleLength: 1) yanlışlıkla
      // "Zirve Dönemi" (ovülasyon) döndürüyordu.
      expect(MockCycleData.phaseForDay(1, cycleLength: state.averageCycleLength).phase, CyclePhase.menstruation);
    });
  });

  group('lastExportDate', () {
    test('toJson/fromJson üzerinden kayıpsız yuvarlanır', () {
      final state = CycleState(lastExportDate: DateTime(2026, 9, 7, 12, 30));
      final restored = CycleState.fromJson(state.toJson());
      expect(restored.lastExportDate, DateTime(2026, 9, 7, 12, 30));
    });

    test('hiç export yapılmamışsa null kalır', () {
      final restored = CycleState.fromJson(const CycleState().toJson());
      expect(restored.lastExportDate, isNull);
    });
  });
}
