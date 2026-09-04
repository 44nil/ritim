import 'package:flutter_test/flutter_test.dart';
import 'package:ritim/core/providers/cycle_provider.dart';
import 'package:ritim/features/parent_panel/models/parent_summary.dart';

void main() {
  test('ParentSummary encode/decode round-trip korur', () {
    final original = ParentSummary(
      userName: 'Ela',
      lastPeriodStart: DateTime(2026, 8, 20),
      currentCycleDay: 15,
      averageCycleLength: 27,
      canPredict: true,
      periodCount: 4,
      generatedAt: DateTime(2026, 9, 4, 20, 0),
    );

    final decoded = ParentSummary.decode(original.encode());

    expect(decoded.userName, original.userName);
    expect(decoded.lastPeriodStart, original.lastPeriodStart);
    expect(decoded.currentCycleDay, original.currentCycleDay);
    expect(decoded.averageCycleLength, original.averageCycleLength);
    expect(decoded.canPredict, original.canPredict);
    expect(decoded.periodCount, original.periodCount);
    expect(decoded.generatedAt, original.generatedAt);
  });

  test('ParentSummary.fromCycleState: ruh hali/semptom/not asla dahil edilmiyor', () {
    final cycle = CycleState(
      periods: [PeriodRecord(startDate: DateTime(2026, 8, 20))],
      logs: {
        '2026-8-20': const DailyLog(mood: 'Kötü', symptoms: ['Kramp'], note: 'çok gizli bir not'),
      },
      userName: 'Ela',
    );

    final json = ParentSummary.fromCycleState(cycle).encode();

    expect(json.contains('Kötü'), isFalse);
    expect(json.contains('Kramp'), isFalse);
    expect(json.contains('çok gizli'), isFalse);
  });

  test('boş döngüde lastPeriodStart null olur, çökme olmaz', () {
    final summary = ParentSummary.fromCycleState(const CycleState());
    expect(summary.lastPeriodStart, isNull);
    expect(() => summary.encode(), returnsNormally);
  });
}
