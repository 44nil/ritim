/// Uygulama genelinde kullanılan sabit değerler.
abstract class AppConstants {
  // Uygulama bilgileri
  static const appName = 'Ritim';
  static const appVersion = '1.0.0';

  // Döngü takibi
  static const defaultCycleLengthDays = 28;
  static const defaultPeriodLengthDays = 5;
  static const minCycleLengthDays = 21;
  static const maxCycleLengthDays = 35;

  // Onboarding
  static const onboardingPageCount = 3;

  // Animasyon süreleri
  static const animDurationFast = Duration(milliseconds: 200);
  static const animDurationNormal = Duration(milliseconds: 350);
  static const animDurationSlow = Duration(milliseconds: 500);

  // Padding / spacing
  static const paddingXS = 4.0;
  static const paddingS = 8.0;
  static const paddingM = 16.0;
  static const paddingL = 24.0;
  static const paddingXL = 32.0;

  // Border radius
  static const radiusS = 8.0;
  static const radiusM = 12.0;
  static const radiusL = 16.0;
  static const radiusXL = 24.0;
  static const radiusRound = 100.0;

  // Ebeveyn paneli
  static const parentPinLength = 6;
}
