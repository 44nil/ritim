import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ritim/app.dart';

/// Onboarding'e eklenen KVKK aydınlatma + açık rıza adımlarının kurulum
/// akışını bozmadığını ve rızanın gerçekten zorunlu olduğunu doğrular.
/// Bkz. docs/legal-compliance-notes.md.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('kurulum: 13+ yaşta ebeveyn kapısı atlanır, aydınlatma+rıza zorunlu', (tester) async {
    await initializeDateFormatting('tr_TR');
    await tester.pumpWidget(const ProviderScope(child: RitimApp()));
    await tester.pumpAndSettle();

    // Onboarding tanıtımını geç (3 sayfa) ve kuruluma başla.
    await tester.tap(find.text('İleri'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('İleri'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Başlayalım'));
    await tester.pumpAndSettle();

    // Yaş sayfası — varsayılan 14 (13 ve üzeri), ebeveyn kapısı devreye girmemeli.
    expect(find.text('Kaç\nyaşındasın?'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    // Ebeveyn kapısı atlanmış olmalı — doğrudan aydınlatma metnine geçildi.
    expect(find.text('Bir yetişkinle\nmi devam\nedelim?'), findsNothing);
    expect(find.text('Önce seni\nbilgilendirelim'), findsOneWidget);
    // Aydınlatma adımında "Atla" gizlenmeli.
    expect(find.text('Atla'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    // Rıza adımı — checkbox işaretlenmeden "İleri" ilerletmemeli.
    expect(find.text('Son bir şey:\nrızan'), findsOneWidget);
    expect(find.text('Atla'), findsNothing);
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Son bir şey:\nrızan'), findsOneWidget, reason: 'Rıza verilmeden ilerlememeli');

    // Checkbox'ı işaretle, şimdi ilerleyebilmeli.
    await tester.tap(find.textContaining('Adet döngüm'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    // Kalan veri adımlarını tamamla.
    expect(find.text('İlk adetin\noldu mu?'), findsOneWidget);
    await tester.tap(find.text('Evet, oldu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Son adetin\nne zaman\nbaşladı?'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Döngün\ngenelde kaç\ngün sürüyor?'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Sana nasıl\nhitap\nedelim?'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Test Kullanıcı');
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pumpAndSettle();

    // Kurulum tamamlandı, ana uygulamaya düştü.
    expect(find.text('Döngüm'), findsOneWidget);
  });
}
