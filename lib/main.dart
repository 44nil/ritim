import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');

  // TODO: Backend entegrasyonu — Firebase.initializeApp() veya benzeri başlatma buraya gelecek

  runApp(
    const ProviderScope(
      child: RitimApp(),
    ),
  );
}
