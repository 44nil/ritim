import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_scaffold.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/setup_screen.dart';
import '../../features/cycle_tracking/screens/cycle_tracking_screen.dart';
import '../../features/qa/screens/qa_screen.dart';
import '../../features/articles/screens/articles_screen.dart';
import '../../features/quiz/screens/quiz_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/parent_panel/screens/parent_login_screen.dart';
import '../../features/parent_panel/screens/parent_panel_screen.dart';
import 'route_names.dart';

/// Uygulama navigasyonu — go_router ile tanımlı.
///
/// Akış:
///  1. Onboarding → /onboarding (ilk açılış)
///  2. Ana uygulama → / (5 sekmeli bottom nav shell)
///  3. Ebeveyn paneli → /parent/login → /parent/panel (bağımsız akış)
///
/// TODO: Backend entegrasyonu — redirect mantığı: onboarding tamamlandıysa / oturumu varsa
///       kullanıcıyı doğrudan ana sayfaya yönlendir.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.onboarding,
    debugLogDiagnostics: true,
    routes: [
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

          // Sekme 1 — Soru-Cevap
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.qa,
                name: RouteNames.qa,
                builder: (context, state) => const QaScreen(),
              ),
            ],
          ),

          // Sekme 2 — Makaleler
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.articles,
                name: RouteNames.articles,
                builder: (context, state) => const ArticlesScreen(),
              ),
            ],
          ),

          // Sekme 3 — Quiz
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.quiz,
                name: RouteNames.quiz,
                builder: (context, state) => const QuizScreen(),
              ),
            ],
          ),

          // Sekme 4 — Profil
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

      // ─── Ebeveyn paneli — bağımsız akış ─────────────────────────────────
      GoRoute(
        path: RoutePaths.parentLogin,
        name: RouteNames.parentLogin,
        builder: (context, state) => const ParentLoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.parentPanel,
        name: RouteNames.parentPanel,
        builder: (context, state) => const ParentPanelScreen(),
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
