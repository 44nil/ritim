import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritim/app.dart';

void main() {
  testWidgets('Uygulama hatasız başlar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: RitimApp()),
    );
    // Onboarding başlangıç ekranı yüklenmelidir
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
