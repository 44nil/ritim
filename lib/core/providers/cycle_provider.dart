import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cycle_storage_service.dart';

class DailyLog {
  const DailyLog({this.flow, this.mood, this.symptoms = const [], this.note, this.medications = const {}, this.sleepHours});
  final String? flow;
  final String? mood;
  final List<String> symptoms;
  final String? note;
  // İlaç adı (kullanıcının kendi yazdığı) -> bugün kaç kez alındığı.
  // Doz/mg gibi tıbbi bilgi tutulmuyor, sadece kişisel bir sayım.
  final Map<String, int> medications;
  // Bugün kaç saat uyuduğu (kullanıcının kendi girdiği, yarım saatlik adımlarla).
  final double? sleepHours;

  bool get hasAnyData => flow != null || mood != null || symptoms.isNotEmpty || note != null || medications.isNotEmpty || sleepHours != null;
  bool get isOnPeriod => flow != null && flow != 'Yok';

  DailyLog copyWith({String? flow, String? mood, List<String>? symptoms, String? note, Map<String, int>? medications, double? sleepHours}) {
    return DailyLog(
      flow: flow ?? this.flow,
      mood: mood ?? this.mood,
      symptoms: symptoms ?? this.symptoms,
      note: note ?? this.note,
      medications: medications ?? this.medications,
      sleepHours: sleepHours ?? this.sleepHours,
    );
  }

  Map<String, dynamic> toJson() => {
    'flow': flow, 'mood': mood, 'symptoms': symptoms, 'note': note, 'medications': medications, 'sleepHours': sleepHours,
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) => DailyLog(
    flow: json['flow'] as String?,
    mood: json['mood'] as String?,
    symptoms: (json['symptoms'] as List?)?.cast<String>() ?? const [],
    note: json['note'] as String?,
    medications: (json['medications'] as Map?)?.cast<String, int>() ?? const {},
    sleepHours: (json['sleepHours'] as num?)?.toDouble(),
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
    this.hasCompletedOnboarding = false,
    this.dailyReminderEnabled = false,
    this.dailyReminderHour = 20,
    this.dailyReminderMinute = 0,
    this.periodReminderEnabled = false,
    this.periodReminderDaysBefore = 2,
    this.warmNotificationTone = true,
    this.lastExportDate,
  });

  final List<PeriodRecord> periods;
  final Map<String, DailyLog> logs;
  final String userName;
  // Kullanıcının takip etmeye başladığı ilaç isimleri (kalıcı liste, günlük değil).
  final List<String> medicationNames;
  // Onboarding'de kullanıcının kendi bildirdiği "genelde kaç gün sürüyor"
  // cevabı. Henüz gerçek döngü geçmişi (2+ regl) yokken averageCycleLength
  // için sabit 28 yerine bunu kullanırız — kullanıcı gerçek veri girdikçe
  // gerçek ortalama bunun yerini alır.
  final int? reportedCycleLength;
  // Onboarding sihirbazını bitirdi mi? Uygulama açılışında bunu kontrol
  // edip tamamlamış kullanıcıyı direkt Döngüm'e yönlendiriyoruz — yoksa
  // veri kalıcı olsa bile her açılışta baştan onboarding görünür.
  final bool hasCompletedOnboarding;
  // Bildirim tercihleri — sunucu yok, tamamen cihaz üstü zamanlanan yerel
  // bildirimler (bkz. core/services/notification_service.dart).
  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool periodReminderEnabled;
  final int periodReminderDaysBefore;
  // Bildirimler her zaman gizli/örtük metin kullanır (regl kelimesi geçmez —
  // kilit ekranında başkası görebilir diye), sadece TONU seçilebilir.
  final bool warmNotificationTone;
  // Android'de otomatik senkronizasyon olmadığı için kullanıcıya elle
  // yedeklemesini hatırlatabilmek adına (bkz. profile_screen.dart).
  final DateTime? lastExportDate;

  static String _key(DateTime date) => '${date.year}-${date.month}-${date.day}';

  // Aktif regl var mı?
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
  // Sonuç ACOG 651'in normal döngü aralığına (21-45 gün) sıkıştırılır — bu
  // olmadan çok kısa (ör. 1-2 gün) bir ortalama, phaseForDay'in oranlama
  // hesabını bozup 1. günü yanlışlıkla "Zirve Dönemi"ne denk getirebiliyordu.
  int get averageCycleLength {
    final lengths = cycleLengths.where((l) => l > 0).toList();
    final raw = lengths.isNotEmpty
        ? (lengths.reduce((a, b) => a + b) / lengths.length).round()
        : reportedCycleLength ?? 28;
    return raw.clamp(21, 45);
  }

  // Ortalama regl süresi
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

  // Sonraki regl tahmini
  int? get daysUntilNextPeriod {
    if (!canPredict || periods.isEmpty) return null;
    final expected = averageCycleLength - currentCycleDay;
    return expected > 0 ? expected : null;
  }

  // Tahmini sonraki regl tarihi
  DateTime? get nextPeriodEstimate {
    final days = daysUntilNextPeriod;
    if (days == null) return null;
    return DateTime.now().add(Duration(days: days));
  }

  // Belirli bir gün regl günü mü?
  bool isPeriodDay(DateTime date) {
    for (final p in periods) {
      final end = p.endDate ?? DateTime.now();
      if (!date.isBefore(p.startDate) && !date.isAfter(end)) return true;
    }
    return false;
  }

  // Belirli bir gün tahmin edilen regl günü mü?
  bool isPredictedPeriodDay(DateTime date) {
    if (!canPredict || periods.isEmpty) return false;
    final nextStart = nextPeriodEstimate;
    if (nextStart == null) return false;
    final diff = date.difference(nextStart).inDays;
    return diff >= 0 && diff < averagePeriodLength;
  }

  DailyLog? logForDate(DateTime date) => logs[_key(date)];
  DailyLog? get todayLog => logForDate(DateTime.now());

  // Belirli bir tarihte, o tarihte en son başlamış regle göre kaçıncı döngü
  // gününde olunduğunu döner. O tarihten önce hiç regl kaydı yoksa null
  // döner — faz hesaplanamaz. `periods` her zaman başlangıç tarihine göre
  // artan sırada tutulur (startPeriod sadece sona ekler).
  int? cycleDayFor(DateTime date) {
    PeriodRecord? active;
    for (final p in periods) {
      if (p.startDate.isAfter(date)) break;
      active = p;
    }
    if (active == null) return null;
    return date.difference(active.startDate).inDays + 1;
  }

  // Kaç gündür art arda bir kayıt (ruh hali/semptom/not/ilaç/regl) girilmiş.
  // Bugün henüz kayıt yoksa dünden sayılır — gün bitmedi, seri henüz bozulmuş
  // sayılmaz.
  int get currentStreak {
    var date = DateTime.now();
    if (logForDate(date)?.hasAnyData != true) {
      date = date.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (logForDate(date)?.hasAnyData == true) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }

  CycleState copyWith({
    List<PeriodRecord>? periods,
    Map<String, DailyLog>? logs,
    String? userName,
    List<String>? medicationNames,
    int? reportedCycleLength,
    bool? hasCompletedOnboarding,
    bool? dailyReminderEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? periodReminderEnabled,
    int? periodReminderDaysBefore,
    bool? warmNotificationTone,
    DateTime? lastExportDate,
  }) {
    return CycleState(
      periods: periods ?? this.periods,
      logs: logs ?? this.logs,
      userName: userName ?? this.userName,
      medicationNames: medicationNames ?? this.medicationNames,
      reportedCycleLength: reportedCycleLength ?? this.reportedCycleLength,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      periodReminderEnabled: periodReminderEnabled ?? this.periodReminderEnabled,
      periodReminderDaysBefore: periodReminderDaysBefore ?? this.periodReminderDaysBefore,
      warmNotificationTone: warmNotificationTone ?? this.warmNotificationTone,
      lastExportDate: lastExportDate ?? this.lastExportDate,
    );
  }

  CycleState _withLog(DateTime date, DailyLog log) {
    final newLogs = Map<String, DailyLog>.from(logs);
    newLogs[_key(date)] = log;
    return copyWith(logs: newLogs);
  }

  CycleState _withMedicationNames(List<String> names) {
    return copyWith(medicationNames: names);
  }

  Map<String, dynamic> toJson() => {
    'periods': periods.map((p) => p.toJson()).toList(),
    'logs': logs.map((key, log) => MapEntry(key, log.toJson())),
    'userName': userName,
    'medicationNames': medicationNames,
    'reportedCycleLength': reportedCycleLength,
    'hasCompletedOnboarding': hasCompletedOnboarding,
    'dailyReminderEnabled': dailyReminderEnabled,
    'dailyReminderHour': dailyReminderHour,
    'dailyReminderMinute': dailyReminderMinute,
    'periodReminderEnabled': periodReminderEnabled,
    'periodReminderDaysBefore': periodReminderDaysBefore,
    'warmNotificationTone': warmNotificationTone,
    'lastExportDate': lastExportDate?.toIso8601String(),
  };

  factory CycleState.fromJson(Map<String, dynamic> json) => CycleState(
    periods: (json['periods'] as List).map((p) => PeriodRecord.fromJson(p as Map<String, dynamic>)).toList(),
    logs: (json['logs'] as Map<String, dynamic>).map((key, log) => MapEntry(key, DailyLog.fromJson(log as Map<String, dynamic>))),
    userName: json['userName'] as String? ?? 'Ela',
    medicationNames: (json['medicationNames'] as List?)?.cast<String>() ?? const [],
    reportedCycleLength: json['reportedCycleLength'] as int?,
    hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
    dailyReminderEnabled: json['dailyReminderEnabled'] as bool? ?? false,
    dailyReminderHour: json['dailyReminderHour'] as int? ?? 20,
    dailyReminderMinute: json['dailyReminderMinute'] as int? ?? 0,
    periodReminderEnabled: json['periodReminderEnabled'] as bool? ?? false,
    periodReminderDaysBefore: json['periodReminderDaysBefore'] as int? ?? 2,
    warmNotificationTone: json['warmNotificationTone'] as bool? ?? true,
    lastExportDate: json['lastExportDate'] != null ? DateTime.parse(json['lastExportDate'] as String) : null,
  );
}

final cycleProvider = StateNotifierProvider<CycleNotifier, CycleState>((ref) {
  return CycleNotifier();
});

class CycleNotifier extends StateNotifier<CycleState> {
  CycleNotifier() : super(const CycleState()) {
    _ready = _hydrate();
  }

  // Splash ekranı, yönlendirme kararını vermeden önce bunu bekler — yoksa
  // kalıcı veri henüz yüklenmeden "onboarding tamamlanmamış" sanılabilir.
  late final Future<void> _ready;
  Future<void> get ready => _ready;

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

  // Kullanıcının "tüm verilerimi sil" isteği — cihazdaki şifreli kaydı
  // gerçekten siler ve uygulamayı taze bir duruma döndürür. Sadece
  // uygulamayı kaldırmak yeterli değildir çünkü iOS'ta Keychain kalıcıdır.
  Future<void> deleteAll() async {
    await CycleStorageService.delete();
    state = const CycleState();
  }

  // Bir önceki state'e döner — "Geri Al" aksiyonları için. startPeriod/
  // endPeriod gibi aksiyonların tersini ayrıca hesaplamak yerine, aksiyondan
  // hemen önceki state'in bir kopyasını geri yüklemek daha basit ve güvenli
  // (ör. startPeriod'un aktif regli kapatıp yenisini açtığı kenar durumunda
  // bile doğru çalışır).
  void restore(CycleState previous) => state = previous;

  void startPeriod([DateTime? date]) {
    final start = date ?? DateTime.now();
    // Önceki aktif regl varsa kapat
    final periods = List<PeriodRecord>.from(state.periods);
    if (periods.isNotEmpty && periods.last.isActive) {
      final last = periods.removeLast();
      periods.add(PeriodRecord(
        startDate: last.startDate,
        endDate: start.subtract(const Duration(days: 1)),
      ));
    }
    periods.add(PeriodRecord(startDate: start));
    state = state.copyWith(periods: periods);
  }

  // Onboarding'de kullanıcı "ilk reglim oldu" dediyse ve bize son reglinin
  // ne zaman başladığını + döngüsünün genelde kaç gün sürdüğünü söylediyse,
  // bu cevapları gerçek bir kayda çevirir. Gerçek veri zaten varsa (ör.
  // kalıcı depodan yüklendiyse) üzerine yazmaz.
  void seedFromOnboarding({required DateTime lastPeriodStart, int? reportedCycleLength}) {
    if (state.periods.isNotEmpty) return;
    // Son regl yakın zamanda başladıysa muhtemelen hâlâ sürüyordur —
    // kullanıcı kendi "Reglim Bitti" diyene kadar açık (aktif) bırakılır.
    // Değilse ortalama bir regl süresiyle (5 gün) kapatılmış sayılır.
    final daysSince = DateTime.now().difference(lastPeriodStart).inDays;
    final isLikelyOngoing = daysSince < 5;
    state = state.copyWith(
      periods: [
        PeriodRecord(
          startDate: lastPeriodStart,
          endDate: isLikelyOngoing ? null : lastPeriodStart.add(const Duration(days: 4)),
        ),
      ],
      reportedCycleLength: reportedCycleLength,
    );
  }

  // Onboarding sihirbazının tamamlandığını işaretler — bir sonraki açılışta
  // splash ekranı kullanıcıyı direkt Döngüm'e yönlendirir.
  void markOnboardingComplete() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  // Kullanıcı "Verilerimi Dışa Aktar"ı gerçekten tamamladığında (paylaşım
  // sayfasını kapatmadı, bir yere kaydetti/gönderdi) çağrılır — Profil'de
  // "son yedek ne zaman" hatırlatması için.
  void recordExport() {
    state = state.copyWith(lastExportDate: DateTime.now());
  }

  void endPeriod([DateTime? date]) {
    if (!state.isOnPeriod) return;
    final periods = List<PeriodRecord>.from(state.periods);
    final last = periods.removeLast();
    periods.add(PeriodRecord(
      startDate: last.startDate,
      endDate: date ?? DateTime.now(),
    ));
    state = state.copyWith(periods: periods);
  }

  // Onboarding'de girilen isim/takma ad.
  void setUserName(String name) {
    if (name.isEmpty) return;
    state = state.copyWith(userName: name);
  }

  // Kullanıcı, döngüsünün genelde kaç gün sürdüğünü sonradan da
  // güncelleyebilir (onboarding'de verdiği ilk tahmin değişmiş olabilir).
  void setReportedCycleLength(int days) {
    state = state.copyWith(reportedCycleLength: days);
  }

  void setDailyReminder({required bool enabled, int? hour, int? minute}) {
    state = state.copyWith(
      dailyReminderEnabled: enabled,
      dailyReminderHour: hour,
      dailyReminderMinute: minute,
    );
  }

  void setPeriodReminder({required bool enabled, int? daysBefore}) {
    state = state.copyWith(
      periodReminderEnabled: enabled,
      periodReminderDaysBefore: daysBefore,
    );
  }

  void setNotificationTone({required bool warm}) {
    state = state.copyWith(warmNotificationTone: warm);
  }

  void logFlow(String flow) {
    final today = DateTime.now();
    final existing = state.logForDate(today) ?? const DailyLog();
    state = state._withLog(today, existing.copyWith(flow: flow));
  }

  // `date` verilmezse bugün varsayılır — takvimden geçmiş bir güne
  // dokunulduğunda o günün kaydını düzenlemek için de kullanılır.
  void logMood(String mood, {DateTime? date}) {
    final day = date ?? DateTime.now();
    final existing = state.logForDate(day) ?? const DailyLog();
    state = state._withLog(day, existing.copyWith(mood: mood));
  }

  // Kaç saat uyuduğunu kaydeder — 0'ın altına inemez.
  void logSleepHours(double hours, {DateTime? date}) {
    final day = date ?? DateTime.now();
    final existing = state.logForDate(day) ?? const DailyLog();
    state = state._withLog(day, existing.copyWith(sleepHours: hours.clamp(0, 24)));
  }

  void logSymptoms(List<String> symptoms, {DateTime? date}) {
    final day = date ?? DateTime.now();
    final existing = state.logForDate(day) ?? const DailyLog();
    state = state._withLog(day, existing.copyWith(symptoms: symptoms));
  }

  void logNote(String note, {DateTime? date}) {
    final day = date ?? DateTime.now();
    final existing = state.logForDate(day) ?? const DailyLog();
    state = state._withLog(day, existing.copyWith(note: note));
  }

  // Kullanıcının kendi yazdığı ilaç ismini takip listesine ekler (zaten varsa dokunmaz).
  void addMedication(String name) {
    if (state.medicationNames.contains(name)) return;
    state = state._withMedicationNames([...state.medicationNames, name]);
  }

  // O gün için o ilacın kaç kez alındığını günceller. Doz/mg bilgisi tutulmaz.
  void logMedicationCount(String name, int count, {DateTime? date}) {
    final day = date ?? DateTime.now();
    final existing = state.logForDate(day) ?? const DailyLog();
    final meds = Map<String, int>.from(existing.medications);
    if (count <= 0) { meds.remove(name); } else { meds[name] = count; }
    state = state._withLog(day, existing.copyWith(medications: meds));
  }
}
