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
  static const articleDetail = 'article-detail';
  static const quiz = 'quiz';
  static const profile = 'profile';

  // Ebeveyn paneli (bağımsız akış) — çocuk tarafı QR oluşturur,
  // veli tarafı QR tarar, ikisi de aynı özet ekranında buluşur.
  static const parentQr = 'parent-qr';
  static const parentScan = 'parent-scan';
  static const parentPanel = 'parent-panel';

  // Yasal metinler (Profil'den ve onboarding'den erişilir)
  static const privacyNotice = 'legal-privacy-notice';
  static const privacyPolicy = 'legal-privacy-policy';
  static const terms = 'legal-terms';
}

/// Route path'leri — go_router için URI'lar.
abstract class RoutePaths {
  static const onboarding = '/onboarding';
  static const home = '/';
  static const cycleTracking = '/cycle-tracking';
  static const qa = '/qa';
  static const articles = '/articles';
  static const articleDetail = '/articles/detail';
  static const quiz = '/quiz';
  static const profile = '/profile';
  static const parentQr = '/parent/qr';
  static const parentScan = '/parent/scan';
  static const parentPanel = '/parent/panel';
  static const privacyNotice = '/legal/kvkk-aydinlatma';
  static const privacyPolicy = '/legal/gizlilik-politikasi';
  static const terms = '/legal/kullanim-sartlari';
}
