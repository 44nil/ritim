import '../../../core/providers/cycle_provider.dart';
import 'mock_cycle_data.dart';

/// Bir belirtinin kullanıcının kendi geçmiş kayıtlarında en çok hangi
/// döngü fazında görüldüğü. Bu genel bir tıbbi/bilimsel iddia değil —
/// sadece kullanıcının kendi verisinin bir özeti, bu yüzden ekranda her
/// zaman "senin geçmişine göre" çerçevesiyle gösterilmeli.
class SymptomPhaseInsight {
  const SymptomPhaseInsight({
    required this.symptom,
    required this.totalCount,
    required this.dominantPhase,
    required this.dominantCount,
  });

  final String symptom;
  final int totalCount;
  final CyclePhase dominantPhase;
  final int dominantCount;
}

/// En az [minOccurrences] kez kaydedilmiş belirtileri, en sık yaşanandan
/// aza doğru sıralanmış şekilde döner. Tek seferlik bir kayıt "örüntü"
/// sayılmaz, bu yüzden varsayılan eşik 2.
List<SymptomPhaseInsight> symptomPhaseInsights(CycleState cycle, {int minOccurrences = 2}) {
  final countsBySymptom = <String, Map<CyclePhase, int>>{};

  for (final entry in cycle.logs.entries) {
    final symptoms = entry.value.symptoms;
    if (symptoms.isEmpty) continue;

    final cycleDay = cycle.cycleDayFor(_parseLogKey(entry.key));
    if (cycleDay == null) continue;
    final phase = MockCycleData.phaseForDay(cycleDay, cycleLength: cycle.averageCycleLength).phase;

    for (final symptom in symptoms) {
      final phaseCounts = countsBySymptom.putIfAbsent(symptom, () => {});
      phaseCounts[phase] = (phaseCounts[phase] ?? 0) + 1;
    }
  }

  final insights = countsBySymptom.entries.map((entry) {
    final phaseCounts = entry.value;
    final total = phaseCounts.values.reduce((a, b) => a + b);
    final dominant = phaseCounts.entries.reduce((a, b) => b.value > a.value ? b : a);
    return SymptomPhaseInsight(
      symptom: entry.key,
      totalCount: total,
      dominantPhase: dominant.key,
      dominantCount: dominant.value,
    );
  }).where((i) => i.totalCount >= minOccurrences).toList();

  insights.sort((a, b) => b.totalCount.compareTo(a.totalCount));
  return insights;
}

DateTime _parseLogKey(String key) {
  final parts = key.split('-');
  return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}
