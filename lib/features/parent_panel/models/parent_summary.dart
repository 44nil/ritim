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
  });

  final String userName;
  final DateTime? lastPeriodStart;
  final int currentCycleDay;
  final int averageCycleLength;
  final bool canPredict;
  final int periodCount;
  final DateTime generatedAt;

  factory ParentSummary.fromCycleState(CycleState cycle) {
    return ParentSummary(
      userName: cycle.userName,
      lastPeriodStart: cycle.periods.isNotEmpty ? cycle.periods.last.startDate : null,
      currentCycleDay: cycle.currentCycleDay,
      averageCycleLength: cycle.averageCycleLength,
      canPredict: cycle.canPredict,
      periodCount: cycle.periods.length,
      generatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'v': 1,
    'userName': userName,
    'lastPeriodStart': lastPeriodStart?.toIso8601String(),
    'currentCycleDay': currentCycleDay,
    'averageCycleLength': averageCycleLength,
    'canPredict': canPredict,
    'periodCount': periodCount,
    'generatedAt': generatedAt.toIso8601String(),
  };

  factory ParentSummary.fromJson(Map<String, dynamic> json) => ParentSummary(
    userName: json['userName'] as String? ?? '',
    lastPeriodStart: json['lastPeriodStart'] != null ? DateTime.parse(json['lastPeriodStart'] as String) : null,
    currentCycleDay: json['currentCycleDay'] as int,
    averageCycleLength: json['averageCycleLength'] as int,
    canPredict: json['canPredict'] as bool,
    periodCount: json['periodCount'] as int,
    generatedAt: DateTime.parse(json['generatedAt'] as String),
  );

  String encode() => jsonEncode(toJson());

  factory ParentSummary.decode(String raw) => ParentSummary.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
