import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ritim/app.dart';
import 'package:ritim/core/services/notification_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Tek testWidgets bloğunda: AppRouter.router `static final` bir singleton
  // olduğu için navigasyon durumu process boyunca kalıcı — ayrı testWidgets
  // bloklarında yeniden pumpWidget çağırmak ikinci testi kaldığı yerden
  // (ör. onboarding'i atlamış halde) başlatıyor. Tek akışta kalmak bunu önler.
  testWidgets('onboarding -> Döngüm -> Profil -> Ebeveyn Paneli', (tester) async {
    await initializeDateFormatting('tr_TR');
    // main.dart bunu runApp'ten önce çağırıyor (tz.local'i ayarlıyor) — bu
    // test RitimApp'i doğrudan pump ettiği için main() atlanıyor, o yüzden
    // burada elle çağırmak gerekiyor.
    await NotificationService.init();
    await tester.pumpWidget(const ProviderScope(child: RitimApp()));
    await tester.pumpAndSettle();

    // Rol seçimi yok — onboarding doğrudan karşılama ekranıyla başlıyor.
    expect(find.text('Ritim\'e\nHoş Geldin'), findsOneWidget);

    await tester.tap(find.text('Atla'));
    // Döngüm ekranında sürekli dönen bir "nefes" animasyonu var (bkz.
    // cycle_tracking_screen.dart _breathController) — pumpAndSettle bunu
    // hiç "durmuş" saymayacağı için sonsuza kadar bekler. Sınırlı bir pump
    // yeterli (giriş animasyonu 900ms).
    await tester.pump(const Duration(milliseconds: 1000));

    expect(find.text('Döngüm'), findsOneWidget);
    // "Atla" ile hiç regl kaydı oluşturulmadan geçildiği için hero kart
    // artık bir faz adı değil, ilk kayıt öncesi nötr bekleme durumunu
    // gösteriyor (bkz. cycle_tracking_screen.dart, cycle.periods.isEmpty dalı).
    expect(find.text('Takip Zamanı'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    // Döngüm sekmesi StatefulShellRoute'ta arka planda canlı kalıyor (tab
    // değişince dispose olmuyor), yani oradaki sonsuz animasyon Profil
    // sekmesindeyken de çalışmaya devam ediyor — burada da pumpAndSettle
    // kullanılamaz.
    await tester.pump(const Duration(milliseconds: 500));

    // Ebeveyn Paneli artık QR ile çalışıyor (eski e-posta/giriş akışı
    // tamamen kaldırıldı, kamera gerektiren tarama kısmı burada test
    // edilmiyor — bkz. ParentSummary encode/decode unit testi).
    await tester.ensureVisible(find.text('Ebeveyn Paneli'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Ebeveyn Paneli'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Veliye Göster'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
  });
}
