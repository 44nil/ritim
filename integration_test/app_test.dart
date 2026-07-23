import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ritim/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Tek testWidgets bloğunda: AppRouter.router `static final` bir singleton
  // olduğu için navigasyon durumu process boyunca kalıcı — ayrı testWidgets
  // bloklarında yeniden pumpWidget çağırmak ikinci testi kaldığı yerden
  // (ör. onboarding'i atlamış halde) başlatıyor. Tek akışta kalmak bunu önler.
  testWidgets('onboarding -> Döngüm -> Profil -> Ebeveyn Paneli', (tester) async {
    await initializeDateFormatting('tr_TR');
    await tester.pumpWidget(const ProviderScope(child: RitimApp()));
    await tester.pumpAndSettle();

    expect(find.text('Ritim\'e\nHoş Geldin'), findsOneWidget);

    await tester.tap(find.text('Atla'));
    await tester.pumpAndSettle();

    expect(find.text('Döngüm'), findsOneWidget);
    expect(find.text('Ovülasyon'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Ebeveyn Paneli'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ebeveyn Paneli'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'veli@example.com');
    await tester.tap(find.text('Giriş Bağlantısı Gönder'));
    // pumpAndSettle burada sonsuza kadar bekler çünkü ekranda anlık olarak
    // duracak (indeterminate) bir CircularProgressIndicator var — onun yerine
    // sabit fake gecikmeyi (1200ms) aşacak kadar pump ediyoruz.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Girişi tamamla (demo)'));
    await tester.pumpAndSettle();

    expect(find.text('Döngü Genel Bakış'), findsOneWidget);
    expect(find.text('Uygulamada Neler Var, Neler Yok'), findsOneWidget);
  });
}
