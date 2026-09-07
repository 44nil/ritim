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

  test('recentPeriods 90 günden eski regl kayıtlarını dışarıda bırakır', () {
    final now = DateTime.now();
    final cycle = CycleState(periods: [
      PeriodRecord(startDate: now.subtract(const Duration(days: 200)), endDate: now.subtract(const Duration(days: 196))),
      PeriodRecord(startDate: now.subtract(const Duration(days: 30)), endDate: now.subtract(const Duration(days: 26))),
    ]);

    final summary = ParentSummary.fromCycleState(cycle);
    expect(summary.recentPeriods, hasLength(1));
    expect(summary.periodCount, 2, reason: 'periodCount hâlâ tüm geçmişi saymalı, sadece takvim son 90 günü göstermeli');
  });

  test('recentPeriods ve tahmin bilgisi encode/decode üzerinden kayıpsız yuvarlanır', () {
    final original = ParentSummary(
      userName: 'Ela',
      lastPeriodStart: DateTime(2026, 8, 20),
      currentCycleDay: 15,
      averageCycleLength: 27,
      canPredict: true,
      periodCount: 4,
      generatedAt: DateTime(2026, 9, 4, 20, 0),
      recentPeriods: [PeriodRecord(startDate: DateTime(2026, 8, 20), endDate: DateTime(2026, 8, 24))],
      nextPeriodEstimate: DateTime(2026, 9, 16),
      averagePeriodLength: 5,
    );

    final decoded = ParentSummary.decode(original.encode());

    expect(decoded.recentPeriods, hasLength(1));
    expect(decoded.recentPeriods.first.startDate, DateTime(2026, 8, 20));
    expect(decoded.recentPeriods.first.endDate, DateTime(2026, 8, 24));
    expect(decoded.nextPeriodEstimate, DateTime(2026, 9, 16));
    expect(decoded.averagePeriodLength, 5);
  });

  test('eski (recentPeriods alanı olmayan) bir JSON hâlâ çözülebiliyor', () {
    const oldJson = '{"v":1,"userName":"Ela","lastPeriodStart":null,"currentCycleDay":1,'
        '"averageCycleLength":28,"canPredict":false,"periodCount":0,'
        '"generatedAt":"2026-09-04T20:00:00.000"}';

    final decoded = ParentSummary.decode(oldJson);
    expect(decoded.recentPeriods, isEmpty);
    expect(decoded.nextPeriodEstimate, isNull);
    expect(decoded.averagePeriodLength, 5);
  });
}
