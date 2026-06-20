import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Uygulama kökü.
/// ProviderScope zaten main.dart'ta sarılı olduğu için burada tekrarlanmaz.
class RitimApp extends ConsumerWidget {
  const RitimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Backend entegrasyonu — themeMode kullanıcı tercihinden okunacak
    // final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Ritim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
