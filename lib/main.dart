import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');
  await NotificationService.init();

  // TODO: Backend entegrasyonu — Firebase.initializeApp() veya benzeri başlatma buraya gelecek

  runApp(
    const ProviderScope(
      child: RitimApp(),
    ),
  );
}
