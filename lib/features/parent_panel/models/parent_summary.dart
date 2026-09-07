import 'dart:convert';
import '../../../core/providers/cycle_provider.dart';

// Çocuğun cihazından veliye QR ile aktarılan, "veli-güvenli" veri özeti.
// Ruh hali/semptom/not asla dahil edilmez — bu bilinçli bir tasarım kararı,
// bkz. docs/legal-compliance-notes.md ve parent_panel_screen.dart.
class ParentSummary {
  const ParentSummary({
    required this.userName,
    required this.lastPeriodStart,
    required this.currentCycleDay,
    required this.averageCycleLength,
    required this.canPredict,
    required this.periodCount,
    required this.generatedAt,
    this.recentPeriods = const [],
    this.nextPeriodEstimate,
    this.averagePeriodLength = 5,
  });

  final String userName;
  final DateTime? lastPeriodStart;
  final int currentCycleDay;
  final int averageCycleLength;
  final bool canPredict;
  final int periodCount;
  final DateTime generatedAt;
  // Son ~90 günün regl kayıtları — panelde gerçek bir mini takvim
  // gösterebilmek için (bkz. parent_panel_screen.dart, _ParentMiniCalendar).
  // Regl tarihleri zaten paylaşılması onaylanmış veri; ruh hali/belirti/not
  // gibi kişiye özel bir şey içermez.
  final List<PeriodRecord> recentPeriods;
  final DateTime? nextPeriodEstimate;
  final int averagePeriodLength;

  factory ParentSummary.fromCycleState(CycleState cycle) {
    final cutoff = DateTime.now().subtract(const Duration(days: 90));
    final recentPeriods = cycle.periods
        .where((p) => (p.endDate ?? DateTime.now()).isAfter(cutoff))
        .toList();
    return ParentSummary(
      userName: cycle.userName,
      lastPeriodStart: cycle.periods.isNotEmpty ? cycle.periods.last.startDate : null,
      currentCycleDay: cycle.currentCycleDay,
      averageCycleLength: cycle.averageCycleLength,
      canPredict: cycle.canPredict,
      periodCount: cycle.periods.length,
      generatedAt: DateTime.now(),
      recentPeriods: recentPeriods,
      nextPeriodEstimate: cycle.nextPeriodEstimate,
      averagePeriodLength: cycle.averagePeriodLength,
    );
  }

  Map<String, dynamic> toJson() => {
    'v': 2,
    'userName': userName,
    'lastPeriodStart': lastPeriodStart?.toIso8601String(),
    'currentCycleDay': currentCycleDay,
    'averageCycleLength': averageCycleLength,
    'canPredict': canPredict,
    'periodCount': periodCount,
    'generatedAt': generatedAt.toIso8601String(),
    'recentPeriods': recentPeriods.map((p) => p.toJson()).toList(),
    'nextPeriodEstimate': nextPeriodEstimate?.toIso8601String(),
    'averagePeriodLength': averagePeriodLength,
  };

  factory ParentSummary.fromJson(Map<String, dynamic> json) => ParentSummary(
    userName: json['userName'] as String? ?? '',
    lastPeriodStart: json['lastPeriodStart'] != null ? DateTime.parse(json['lastPeriodStart'] as String) : null,
    currentCycleDay: json['currentCycleDay'] as int,
    averageCycleLength: json['averageCycleLength'] as int,
    canPredict: json['canPredict'] as bool,
    periodCount: json['periodCount'] as int,
    generatedAt: DateTime.parse(json['generatedAt'] as String),
    // Eski (v1) QR'larla da uyumlu olsun diye hepsi opsiyonel/varsayılanlı.
    recentPeriods: (json['recentPeriods'] as List?)
            ?.map((p) => PeriodRecord.fromJson(p as Map<String, dynamic>))
            .toList() ??
        const [],
    nextPeriodEstimate: json['nextPeriodEstimate'] != null ? DateTime.parse(json['nextPeriodEstimate'] as String) : null,
    averagePeriodLength: json['averagePeriodLength'] as int? ?? 5,
  );

  String encode() => jsonEncode(toJson());

  factory ParentSummary.decode(String raw) => ParentSummary.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
