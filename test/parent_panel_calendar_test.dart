import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ritim/core/providers/cycle_provider.dart';
import 'package:ritim/features/parent_panel/models/parent_summary.dart';
import 'package:ritim/features/parent_panel/screens/parent_panel_screen.dart';

void main() {
  testWidgets('recentPeriods varsa Regl Takvimi kartı ve doğru gün sayısı görünür', (tester) async {
    await initializeDateFormatting('tr_TR');
    final now = DateTime.now();
    final summary = ParentSummary(
      userName: 'Ela',
      lastPeriodStart: now.subtract(const Duration(days: 10)),
      currentCycleDay: 11,
      averageCycleLength: 28,
      canPredict: true,
      periodCount: 4,
      generatedAt: now,
      recentPeriods: [
        PeriodRecord(startDate: now.subtract(const Duration(days: 10)), endDate: now.subtract(const Duration(days: 6))),
      ],
      nextPeriodEstimate: now.add(const Duration(days: 18)),
      averagePeriodLength: 5,
    );

    await tester.pumpWidget(MaterialApp(
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: ParentPanelScreen(summary: summary),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Regl Takvimi'), findsOneWidget);
    expect(find.text('Regl günü'), findsOneWidget);
    expect(find.text('Tahmini'), findsOneWidget);
  });

  testWidgets('recentPeriods boşsa Regl Takvimi kartı hiç gösterilmez', (tester) async {
    await initializeDateFormatting('tr_TR');
    final summary = ParentSummary.fromCycleState(const CycleState());

    await tester.pumpWidget(MaterialApp(
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: ParentPanelScreen(summary: summary),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Regl Takvimi'), findsNothing);
  });
}
