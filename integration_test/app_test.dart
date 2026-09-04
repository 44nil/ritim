import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

    // İlk soru: "Bu telefonu kim kullanacak?" — çocuk yolunu seç.
    expect(find.text('Ben kullanacağım'), findsOneWidget);
    await tester.tap(find.text('Ben kullanacağım'));
    await tester.pumpAndSettle();

    expect(find.text('Ritim\'e\nHoş Geldin'), findsOneWidget);

    await tester.tap(find.text('Atla'));
    await tester.pumpAndSettle();

    expect(find.text('Döngüm'), findsOneWidget);
    // Faz kartı artık gerçek cycleProvider'dan besleniyor (bkz. mock_cycle_data.dart
    // phaseForDay) — kayıt geçmişi olmayan taze bir kurulumda gün 1 = "Adet" fazı.
    // Eskiden sabit/mock "Ovülasyon" (gün 14) bekleniyordu, artık öyle değil.
    expect(find.text('Adet'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    // Ebeveyn Paneli artık QR ile çalışıyor (eski e-posta/giriş akışı
    // tamamen kaldırıldı, kamera gerektiren tarama kısmı burada test
    // edilmiyor — bkz. ParentSummary encode/decode unit testi).
    await tester.ensureVisible(find.text('Ebeveyn Paneli'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ebeveyn Paneli'));
    await tester.pumpAndSettle();

    expect(find.text('Veliye Göster'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
  });
}
