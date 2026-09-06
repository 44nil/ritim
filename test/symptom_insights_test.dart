import 'package:flutter_test/flutter_test.dart';
import 'package:ritim/core/providers/cycle_provider.dart';
import 'package:ritim/features/cycle_tracking/data/mock_cycle_data.dart';
import 'package:ritim/features/cycle_tracking/data/symptom_insights.dart';

String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';

void main() {
  group('symptomPhaseInsights', () {
    test('veri yokken boş liste döner', () {
      expect(symptomPhaseInsights(const CycleState()), isEmpty);
    });

    test('aynı belirti aynı fazda 2+ kez kaydedilince örüntü olarak görünür', () {
      // 28 günlük varsayılan döngüde 1 Ocak başlangıçlı regl: gün 1-5 = regl fazı.
      final period = PeriodRecord(startDate: DateTime(2026, 1, 1), endDate: DateTime(2026, 1, 5));
      final state = CycleState(periods: [period], logs: {
        _key(DateTime(2026, 1, 3)): const DailyLog(symptoms: ['Kramp']),
        _key(DateTime(2026, 1, 4)): const DailyLog(symptoms: ['Kramp']),
      });

      final insights = symptomPhaseInsights(state);
      expect(insights, hasLength(1));
      expect(insights.first.symptom, 'Kramp');
      expect(insights.first.totalCount, 2);
      expect(insights.first.dominantPhase, CyclePhase.menstruation);
      expect(insights.first.dominantCount, 2);
    });

    test('birden fazla fazda görülen belirtide baskın faz doğru seçilir', () {
      final period = PeriodRecord(startDate: DateTime(2026, 1, 1), endDate: DateTime(2026, 1, 5));
      final state = CycleState(periods: [period], logs: {
        _key(DateTime(2026, 1, 10)): const DailyLog(symptoms: ['Yorgunluk']), // gün 10 -> foliküler
        _key(DateTime(2026, 1, 20)): const DailyLog(symptoms: ['Yorgunluk']), // gün 20 -> luteal
        _key(DateTime(2026, 1, 21)): const DailyLog(symptoms: ['Yorgunluk']), // gün 21 -> luteal
      });

      final insights = symptomPhaseInsights(state);
      expect(insights, hasLength(1));
      expect(insights.first.totalCount, 3);
      expect(insights.first.dominantPhase, CyclePhase.luteal);
      expect(insights.first.dominantCount, 2);
    });

    test('tek seferlik kayıt varsayılan eşikte örüntü sayılmaz', () {
      final period = PeriodRecord(startDate: DateTime(2026, 1, 1), endDate: DateTime(2026, 1, 5));
      final state = CycleState(periods: [period], logs: {
        _key(DateTime(2026, 1, 3)): const DailyLog(symptoms: ['Akne']),
      });

      expect(symptomPhaseInsights(state), isEmpty);
      expect(symptomPhaseInsights(state, minOccurrences: 1), hasLength(1));
    });

    test('hiç regl kaydından önceki bir tarih faz hesaplanamadığı için sayılmaz', () {
      final period = PeriodRecord(startDate: DateTime(2026, 1, 1), endDate: DateTime(2026, 1, 5));
      final state = CycleState(periods: [period], logs: {
        _key(DateTime(2025, 12, 25)): const DailyLog(symptoms: ['Kramp']),
        _key(DateTime(2025, 12, 26)): const DailyLog(symptoms: ['Kramp']),
      });

      expect(symptomPhaseInsights(state), isEmpty);
    });

    test('birden fazla belirti sıklığa göre azalan sırada döner', () {
      final period = PeriodRecord(startDate: DateTime(2026, 1, 1), endDate: DateTime(2026, 1, 5));
      final state = CycleState(periods: [period], logs: {
        _key(DateTime(2026, 1, 2)): const DailyLog(symptoms: ['Kramp']),
        _key(DateTime(2026, 1, 3)): const DailyLog(symptoms: ['Kramp', 'Şişkinlik']),
        _key(DateTime(2026, 1, 4)): const DailyLog(symptoms: ['Kramp', 'Şişkinlik']),
      });

      final insights = symptomPhaseInsights(state);
      expect(insights, hasLength(2));
      expect(insights.first.symptom, 'Kramp'); // 3 kez > Şişkinlik'in 2 kezi
      expect(insights.first.totalCount, 3);
      expect(insights.last.symptom, 'Şişkinlik');
      expect(insights.last.totalCount, 2);
    });
  });
}
