/// Tüm route isimlerini tek bir yerde toplar.
/// go_router'da hem path hem de name olarak kullanılır.
abstract class RouteNames {
  // Onboarding
  static const onboarding = 'onboarding';

  // Ana scaffold (bottom nav barı içerir)
  static const home = 'home';

  // Bottom nav sekmeleri
  static const cycleTracking = 'cycle-tracking';
  static const qa = 'qa';
  static const articles = 'articles';
  static const quiz = 'quiz';
  static const profile = 'profile';

  // Ebeveyn paneli (bağımsız akış)
  static const parentLogin = 'parent-login';
  static const parentPanel = 'parent-panel';
}

/// Route path'leri — go_router için URI'lar.
abstract class RoutePaths {
  static const onboarding = '/onboarding';
  static const home = '/';
  static const cycleTracking = '/cycle-tracking';
  static const qa = '/qa';
  static const articles = '/articles';
  static const quiz = '/quiz';
  static const profile = '/profile';
  static const parentLogin = '/parent/login';
  static const parentPanel = '/parent/panel';
}
