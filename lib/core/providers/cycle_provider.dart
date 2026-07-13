import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyLog {
  const DailyLog({this.flow, this.mood, this.symptoms = const [], this.note});
  final String? flow;
  final String? mood;
  final List<String> symptoms;
  final String? note;

  bool get hasAnyData => flow != null || mood != null || symptoms.isNotEmpty || note != null;
  bool get isOnPeriod => flow != null && flow != 'Yok';

  DailyLog copyWith({String? flow, String? mood, List<String>? symptoms, String? note}) {
    return DailyLog(
      flow: flow ?? this.flow,
      mood: mood ?? this.mood,
      symptoms: symptoms ?? this.symptoms,
      note: note ?? this.note,
    );
  }
}

class PeriodRecord {
  const PeriodRecord({required this.startDate, this.endDate});
  final DateTime startDate;
  final DateTime? endDate;

  bool get isActive => endDate == null;
  int get lengthDays => endDate != null
      ? endDate!.difference(startDate).inDays + 1
      : DateTime.now().difference(startDate).inDays + 1;
}

class CycleState {
  const CycleState({
    this.periods = const [],
    this.logs = const {},
    this.userName = 'Ela',
  });

  final List<PeriodRecord> periods;
  final Map<String, DailyLog> logs;
  final String userName;

  static String _key(DateTime date) => '${date.year}-${date.month}-${date.day}';

  // Aktif adet var mı?
  bool get isOnPeriod => periods.isNotEmpty && periods.last.isActive;
  PeriodRecord? get activePeriod => isOnPeriod ? periods.last : null;

  // Son tamamlanmış döngü süreleri
  List<int> get cycleLengths {
    final lengths = <int>[];
    for (int i = 1; i < periods.length; i++) {
      lengths.add(periods[i].startDate.difference(periods[i - 1].startDate).inDays);
    }
    return lengths;
  }

  // Yeterli veri var mı tahmin için? (3+ döngü)
  bool get canPredict => cycleLengths.length >= 3;

  // Ortalama döngü süresi
  int get averageCycleLength {
    final lengths = cycleLengths;
    if (lengths.isEmpty) return 28;
    return (lengths.reduce((a, b) => a + b) / lengths.length).round();
  }

  // Ortalama adet süresi
  int get averagePeriodLength {
    final completed = periods.where((p) => p.endDate != null).toList();
    if (completed.isEmpty) return 5;
    final total = completed.map((p) => p.lengthDays).reduce((a, b) => a + b);
    return (total / completed.length).round();
  }

  // Şu anki döngü günü
  int get currentCycleDay {
    if (periods.isEmpty) return 1;
    final lastStart = periods.last.startDate;
    return DateTime.now().difference(lastStart).inDays + 1;
  }

  // Sonraki adet tahmini
  int? get daysUntilNextPeriod {
    if (!canPredict || periods.isEmpty) return null;
    final expected = averageCycleLength - currentCycleDay;
    return expected > 0 ? expected : null;
  }

  // Tahmini sonraki adet tarihi
  DateTime? get nextPeriodEstimate {
    final days = daysUntilNextPeriod;
    if (days == null) return null;
    return DateTime.now().add(Duration(days: days));
  }

  // Belirli bir gün adet günü mü?
  bool isPeriodDay(DateTime date) {
    for (final p in periods) {
      final end = p.endDate ?? DateTime.now();
      if (!date.isBefore(p.startDate) && !date.isAfter(end)) return true;
    }
    return false;
  }

  // Belirli bir gün tahmin edilen adet günü mü?
  bool isPredictedPeriodDay(DateTime date) {
    if (!canPredict || periods.isEmpty) return false;
    final nextStart = nextPeriodEstimate;
    if (nextStart == null) return false;
    final diff = date.difference(nextStart).inDays;
    return diff >= 0 && diff < averagePeriodLength;
  }

  DailyLog? logForDate(DateTime date) => logs[_key(date)];
  DailyLog? get todayLog => logForDate(DateTime.now());

  CycleState _withLog(DateTime date, DailyLog log) {
    final newLogs = Map<String, DailyLog>.from(logs);
    newLogs[_key(date)] = log;
    return CycleState(periods: periods, logs: newLogs, userName: userName);
  }
}

final cycleProvider = StateNotifierProvider<CycleNotifier, CycleState>((ref) {
  return CycleNotifier();
});

class CycleNotifier extends StateNotifier<CycleState> {
  CycleNotifier() : super(CycleState(
    periods: [
      PeriodRecord(startDate: _d1, endDate: _d1e),
      PeriodRecord(startDate: _d2, endDate: _d2e),
      PeriodRecord(startDate: _d3, endDate: _d3e),
    ],
  ));

  void startPeriod([DateTime? date]) {
    final start = date ?? DateTime.now();
    // Önceki aktif adet varsa kapat
    final periods = List<PeriodRecord>.from(state.periods);
    if (periods.isNotEmpty && periods.last.isActive) {
      final last = periods.removeLast();
      periods.add(PeriodRecord(
        startDate: last.startDate,
        endDate: start.subtract(const Duration(days: 1)),
      ));
    }
    periods.add(PeriodRecord(startDate: start));
    state = CycleState(periods: periods, logs: state.logs, userName: state.userName);
  }

  void endPeriod([DateTime? date]) {
    if (!state.isOnPeriod) return;
    final periods = List<PeriodRecord>.from(state.periods);
    final last = periods.removeLast();
    periods.add(PeriodRecord(
      startDate: last.startDate,
      endDate: date ?? DateTime.now(),
    ));
    state = CycleState(periods: periods, logs: state.logs, userName: state.userName);
  }

  void logFlow(String flow) {
    final today = DateTime.now();
    final existing = state.logForDate(today) ?? const DailyLog();
    state = state._withLog(today, existing.copyWith(flow: flow));
  }

  void logMood(String mood) {
    final today = DateTime.now();
    final existing = state.logForDate(today) ?? const DailyLog();
    state = state._withLog(today, existing.copyWith(mood: mood));
  }

  void logSymptoms(List<String> symptoms) {
    final today = DateTime.now();
    final existing = state.logForDate(today) ?? const DailyLog();
    state = state._withLog(today, existing.copyWith(symptoms: symptoms));
  }

  void logNote(String note) {
    final today = DateTime.now();
    final existing = state.logForDate(today) ?? const DailyLog();
    state = state._withLog(today, existing.copyWith(note: note));
  }
}

// Mock geçmiş döngü tarihleri
final _now = DateTime.now();
final _d3 = DateTime(_now.year, _now.month - 1, _now.day - 2);
final _d3e = _d3.add(const Duration(days: 4));
final _d2 = _d3.subtract(const Duration(days: 30));
final _d2e = _d2.add(const Duration(days: 5));
final _d1 = _d2.subtract(const Duration(days: 28));
final _d1e = _d1.add(const Duration(days: 4));
