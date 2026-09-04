import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cycle_storage_service.dart';

class DailyLog {
  const DailyLog({this.flow, this.mood, this.symptoms = const [], this.note, this.medications = const {}});
  final String? flow;
  final String? mood;
  final List<String> symptoms;
  final String? note;
  // İlaç adı (kullanıcının kendi yazdığı) -> bugün kaç kez alındığı.
  // Doz/mg gibi tıbbi bilgi tutulmuyor, sadece kişisel bir sayım.
  final Map<String, int> medications;

  bool get hasAnyData => flow != null || mood != null || symptoms.isNotEmpty || note != null || medications.isNotEmpty;
  bool get isOnPeriod => flow != null && flow != 'Yok';

  DailyLog copyWith({String? flow, String? mood, List<String>? symptoms, String? note, Map<String, int>? medications}) {
    return DailyLog(
      flow: flow ?? this.flow,
      mood: mood ?? this.mood,
      symptoms: symptoms ?? this.symptoms,
      note: note ?? this.note,
      medications: medications ?? this.medications,
    );
  }

  Map<String, dynamic> toJson() => {
    'flow': flow, 'mood': mood, 'symptoms': symptoms, 'note': note, 'medications': medications,
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) => DailyLog(
    flow: json['flow'] as String?,
    mood: json['mood'] as String?,
    symptoms: (json['symptoms'] as List?)?.cast<String>() ?? const [],
    note: json['note'] as String?,
    medications: (json['medications'] as Map?)?.cast<String, int>() ?? const {},
  );
}

class PeriodRecord {
  const PeriodRecord({required this.startDate, this.endDate});
  final DateTime startDate;
  final DateTime? endDate;

  bool get isActive => endDate == null;
  int get lengthDays => endDate != null
      ? endDate!.difference(startDate).inDays + 1
      : DateTime.now().difference(startDate).inDays + 1;

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(), 'endDate': endDate?.toIso8601String(),
  };

  factory PeriodRecord.fromJson(Map<String, dynamic> json) => PeriodRecord(
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
  );
}

class CycleState {
  const CycleState({
    this.periods = const [],
    this.logs = const {},
    this.userName = 'Ela',
    this.medicationNames = const [],
    this.reportedCycleLength,
  });

  final List<PeriodRecord> periods;
  final Map<String, DailyLog> logs;
  final String userName;
  // Kullanıcının takip etmeye başladığı ilaç isimleri (kalıcı liste, günlük değil).
  final List<String> medicationNames;
  // Onboarding'de kullanıcının kendi bildirdiği "genelde kaç gün sürüyor"
  // cevabı. Henüz gerçek döngü geçmişi (2+ adet) yokken averageCycleLength
  // için sabit 28 yerine bunu kullanırız — kullanıcı gerçek veri girdikçe
  // gerçek ortalama bunun yerini alır.
  final int? reportedCycleLength;

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

  // Ortalama döngü süresi. Aynı gün içinde art arda başlat/bitir/başlat gibi
  // gerçek olmayan (0 gün ve altı) döngüler ortalamayı bozmasın diye filtrelenir.
  int get averageCycleLength {
    final lengths = cycleLengths.where((l) => l > 0).toList();
    if (lengths.isNotEmpty) {
      return (lengths.reduce((a, b) => a + b) / lengths.length).round();
    }
    return reportedCycleLength ?? 28;
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
    return CycleState(periods: periods, logs: newLogs, userName: userName, medicationNames: medicationNames, reportedCycleLength: reportedCycleLength);
  }

  CycleState _withMedicationNames(List<String> names) {
    return CycleState(periods: periods, logs: logs, userName: userName, medicationNames: names, reportedCycleLength: reportedCycleLength);
  }

  Map<String, dynamic> toJson() => {
    'periods': periods.map((p) => p.toJson()).toList(),
    'logs': logs.map((key, log) => MapEntry(key, log.toJson())),
    'userName': userName,
    'medicationNames': medicationNames,
    'reportedCycleLength': reportedCycleLength,
  };

  factory CycleState.fromJson(Map<String, dynamic> json) => CycleState(
    periods: (json['periods'] as List).map((p) => PeriodRecord.fromJson(p as Map<String, dynamic>)).toList(),
    logs: (json['logs'] as Map<String, dynamic>).map((key, log) => MapEntry(key, DailyLog.fromJson(log as Map<String, dynamic>))),
    userName: json['userName'] as String? ?? 'Ela',
    medicationNames: (json['medicationNames'] as List?)?.cast<String>() ?? const [],
    reportedCycleLength: json['reportedCycleLength'] as int?,
  );
}

final cycleProvider = StateNotifierProvider<CycleNotifier, CycleState>((ref) {
  return CycleNotifier();
});

class CycleNotifier extends StateNotifier<CycleState> {
  CycleNotifier() : super(const CycleState()) {
    _hydrate();
  }

  // Uygulama açılışında cihazın güvenli depolamasından önceki kayıtları yükler.
  Future<void> _hydrate() async {
    final saved = await CycleStorageService.load();
    if (saved != null && mounted) state = saved;
  }

  // Her state değişiminde otomatik olarak cihaza (şifreli) kaydeder —
  // ayrı ayrı her metodun sonuna kaydetme çağrısı eklemek yerine.
  @override
  set state(CycleState value) {
    super.state = value;
    CycleStorageService.save(value);
  }

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
    state = CycleState(periods: periods, logs: state.logs, userName: state.userName, medicationNames: state.medicationNames, reportedCycleLength: state.reportedCycleLength);
  }

  // Onboarding'de kullanıcı "ilk adetim oldu" dediyse ve bize son adetinin
  // ne zaman başladığını + döngüsünün genelde kaç gün sürdüğünü söylediyse,
  // bu cevapları gerçek bir kayda çevirir. Gerçek veri zaten varsa (ör.
  // kalıcı depodan yüklendiyse) üzerine yazmaz.
  void seedFromOnboarding({required DateTime lastPeriodStart, int? reportedCycleLength}) {
    if (state.periods.isNotEmpty) return;
    // Son adet yakın zamanda başladıysa muhtemelen hâlâ sürüyordur —
    // kullanıcı kendi "Adetim Bitti" diyene kadar açık (aktif) bırakılır.
    // Değilse ortalama bir adet süresiyle (5 gün) kapatılmış sayılır.
    final daysSince = DateTime.now().difference(lastPeriodStart).inDays;
    final isLikelyOngoing = daysSince < 5;
    state = CycleState(
      periods: [
        PeriodRecord(
          startDate: lastPeriodStart,
          endDate: isLikelyOngoing ? null : lastPeriodStart.add(const Duration(days: 4)),
        ),
      ],
      logs: state.logs,
      userName: state.userName,
      medicationNames: state.medicationNames,
      reportedCycleLength: reportedCycleLength,
    );
  }

  void endPeriod([DateTime? date]) {
    if (!state.isOnPeriod) return;
    final periods = List<PeriodRecord>.from(state.periods);
    final last = periods.removeLast();
    periods.add(PeriodRecord(
      startDate: last.startDate,
      endDate: date ?? DateTime.now(),
    ));
    state = CycleState(periods: periods, logs: state.logs, userName: state.userName, medicationNames: state.medicationNames, reportedCycleLength: state.reportedCycleLength);
  }

  // Onboarding'de girilen isim/takma ad.
  void setUserName(String name) {
    if (name.isEmpty) return;
    state = CycleState(periods: state.periods, logs: state.logs, userName: name, medicationNames: state.medicationNames, reportedCycleLength: state.reportedCycleLength);
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

  // Kullanıcının kendi yazdığı ilaç ismini takip listesine ekler (zaten varsa dokunmaz).
  void addMedication(String name) {
    if (state.medicationNames.contains(name)) return;
    state = state._withMedicationNames([...state.medicationNames, name]);
  }

  // Bugün için o ilacın kaç kez alındığını günceller. Doz/mg bilgisi tutulmaz.
  void logMedicationCount(String name, int count) {
    final today = DateTime.now();
    final existing = state.logForDate(today) ?? const DailyLog();
    final meds = Map<String, int>.from(existing.medications);
    if (count <= 0) { meds.remove(name); } else { meds[name] = count; }
    state = state._withLog(today, existing.copyWith(medications: meds));
  }
}
