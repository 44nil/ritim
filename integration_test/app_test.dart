import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ritim/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding -> Atla -> Döngüm ana ekranı açılır', (tester) async {
    await initializeDateFormatting('tr_TR');
    await tester.pumpWidget(const ProviderScope(child: RitimApp()));
    await tester.pumpAndSettle();

    expect(find.text('Ritim\'e\nHoş Geldin'), findsOneWidget);

    await tester.tap(find.text('Atla'));
    await tester.pumpAndSettle();

    expect(find.text('Döngüm'), findsOneWidget);
    expect(find.text('Ovülasyon'), findsOneWidget);
  });
}
