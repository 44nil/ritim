import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_scaffold.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/setup_screen.dart';
import '../../features/cycle_tracking/screens/cycle_tracking_screen.dart';
import '../../features/articles/screens/articles_screen.dart';
import '../../features/quiz/screens/quiz_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/parent_panel/screens/parent_qr_screen.dart';
import '../../features/parent_panel/screens/parent_scan_screen.dart';
import '../../features/parent_panel/screens/parent_panel_screen.dart';
import '../../features/parent_panel/models/parent_summary.dart';
import '../../features/legal/content/legal_content.dart';
import '../../features/legal/screens/legal_document_screen.dart';
import 'route_names.dart';

/// Uygulama navigasyonu — go_router ile tanımlı.
///
/// Akış:
///  0. Splash → / (kalıcı veri yüklenene kadar bekler, sonra 1 ya da 2'ye yönlendirir)
///  1. Onboarding → /onboarding (ilk açılış / tamamlanmadıysa)
///  2. Ana uygulama → /cycle-tracking (4 sekmeli bottom nav shell)
///  3. Ebeveyn paneli — hesap/şifre yok, bağımsız akış:
///     çocuk /parent/qr'da QR gösterir, veli /parent/scan'de tarar,
///     ikisi de /parent/panel'de (taranan özetle) buluşur.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    routes: [
      // ─── Splash — onboarding tamamlanmış mı diye kalıcı veriyi kontrol eder ──
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const SplashScreen(),
      ),

      // ─── Onboarding ───────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ─── Kurulum ────────────────────────────────────────────────────────
      GoRoute(
        path: '/setup',
        name: 'setup',
        builder: (context, state) => const SetupScreen(),
      ),

      // ─── Ana uygulama — StatefulShellRoute (bottom nav) ──────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          // Sekme 0 — Döngü Takibi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.cycleTracking,
                name: RouteNames.cycleTracking,
                builder: (context, state) => const CycleTrackingScreen(),
              ),
            ],
          ),

          // Sorular sekmesi (Uzman Paneli) gerçek, uzman onaylı içerik hazır
          // olana kadar kaldırıldı — bkz. lib/features/qa/screens/qa_screen.dart.
          // İçerik hazır olduğunda buraya ve home_scaffold.dart'a geri eklenmeli.

          // Sekme 1 — Makaleler
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.articles,
                name: RouteNames.articles,
                builder: (context, state) => const ArticlesScreen(),
              ),
            ],
          ),

          // Sekme 2 — Quiz
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.quiz,
                name: RouteNames.quiz,
                builder: (context, state) => const QuizScreen(),
              ),
            ],
          ),

          // Sekme 3 — Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ─── Ebeveyn paneli — bağımsız akış, hesap/şifre yok ────────────────
      // Çocuk tarafı: Profil → "Ebeveyn Paneli" → QR oluştur.
      // Veli tarafı: onboarding'deki "QR ile bağlanın" → QR tara → özet.
      GoRoute(
        path: RoutePaths.parentQr,
        name: RouteNames.parentQr,
        builder: (context, state) => const ParentQrScreen(),
      ),
      GoRoute(
        path: RoutePaths.parentScan,
        name: RouteNames.parentScan,
        builder: (context, state) => const ParentScanScreen(),
      ),
      GoRoute(
        path: RoutePaths.parentPanel,
        name: RouteNames.parentPanel,
        builder: (context, state) => ParentPanelScreen(summary: state.extra as ParentSummary),
      ),

      // ─── Yasal metinler — bağımsız erişim (Profil, onboarding linkleri) ───
      GoRoute(
        path: RoutePaths.privacyNotice,
        name: RouteNames.privacyNotice,
        builder: (context, state) => const LegalDocumentScreen(
          title: 'KVKK Aydınlatma Metni',
          body: kKvkkAydinlatmaMetni,
        ),
      ),
      GoRoute(
        path: RoutePaths.privacyPolicy,
        name: RouteNames.privacyPolicy,
        builder: (context, state) => const LegalDocumentScreen(
          title: 'Gizlilik Politikası',
          body: kGizlilikPolitikasi,
        ),
      ),
      GoRoute(
        path: RoutePaths.terms,
        name: RouteNames.terms,
        builder: (context, state) => const LegalDocumentScreen(
          title: 'Kullanım Şartları',
          body: kKullanimSartlari,
        ),
      ),
    ],

    // Hata sayfası
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Sayfa bulunamadı: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.goNamed(RouteNames.cycleTracking),
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    ),
  );
}
