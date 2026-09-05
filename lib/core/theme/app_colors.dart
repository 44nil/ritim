import 'package:flutter/material.dart';

/// Ritim renk paleti — pembe + turuncu, sıcak ve enerjik.
abstract class AppColors {
  // ─── Ana 2 renk ────────────────────────────────────────────────────────
  static const softPink = Color(0xFFF472B6);     // Hot pink — gradient başlangıcı
  static const warmOrange = Color(0xFFFBB47C);   // Sıcak şeftali — gradient ortası

  // ─── Koyu ton (metin + koyu kartlar için) ──────────────────────────────
  static const ink = Color(0xFF2D2438);

  // ─── Türetilmiş tonlar ─────────────────────────────────────────────────
  static const primary = Color(0xFFF472B6);
  static const primaryContainer = Color(0xFFFDE8F0);
  static const onPrimary = Color(0xFF2D2438);
  static const onPrimaryContainer = Color(0xFF2D2438);

  static const secondary = Color(0xFFFBB47C);
  static const secondaryContainer = Color(0xFFFDE8C8);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFF5C3A10);

  static const tertiary = Color(0xFFD4849A);
  static const tertiaryContainer = Color(0xFFF2C0CC);
  static const onTertiary = Color(0xFFFFFFFF);

  // ─── Neutral / Surface — Light ─────────────────────────────────────────
  static const backgroundLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceVariantLight = Color(0xFFFAF5F8);
  static const onBackgroundLight = Color(0xFF2D2438);
  static const onSurfaceLight = Color(0xFF2D2438);
  static const outlineLight = Color(0xFFE0D4DA);

  // ─── Neutral / Surface — Dark ──────────────────────────────────────────
  static const backgroundDark = Color(0xFF1A1520);
  static const surfaceDark = Color(0xFF231C2A);
  static const surfaceVariantDark = Color(0xFF2E2536);
  static const onBackgroundDark = Color(0xFFF5EEF2);
  static const onSurfaceDark = Color(0xFFF5EEF2);
  static const outlineDark = Color(0xFF4A3E52);

  // ─── Semantic ──────────────────────────────────────────────────────────
  static const error = Color(0xFFD45A7A);
  static const onError = Color(0xFFFFFFFF);
  static const success = Color(0xFF5B8C6E);
  static const warning = Color(0xFFFBB47C);

  // ─── Cycle phase renkleri (pembe-turuncu tonlarından) ──────────────────
  static const phaseMenstruation = Color(0xFFF472B6);
  static const phaseFollicular = Color(0xFFF9A8D4);
  static const phaseOvulation = Color(0xFFFBB47C);
  static const phaseLuteal = Color(0xFFFCD9A8);

  // ─── Kart arkaplanları (Döngüm/Quiz/Makaleler kartlarında tekrar eden) ──
  // "Rice" (#FAF5EF) — kırık beyaz, saf beyazdan daha sıcak.
  static const cardCream = Color(0xFFFAF5EF);
  static const cardPink = Color(0xFFFCE8EF);
  // Gradient'in üzerine oturan büyük kartlar için: krem/bej tonu gradient'in
  // renk ailesinde olmadığından (pembe/turuncu değil) her zaman "beyazımsı,
  // ayrık" duruyordu — hero kartın zaten yaptığı gibi, gradient'in kendi
  // rengini (sıcak turuncu) şeffaf kullanmak daha doğal kaynaşıyor.
  // Eskiden gerçekten şeffaftı (warmOrange %15 opaklık) — arkasındaki
  // gradient'e göre bazen "çok belirgin değil, okunmuyor" oluyordu. Sonra
  // warmOrange'ı beyazla harmanlayıp opak yaptık ama bu sefer "çok beyaz"
  // oldu. Kullanıcının seçtiği Misty Rose (#FFE4E1) — marka paletiyle aynı
  // pembe ailesinden, opak, ama beyaza kaçmayan bir orta nokta.
  static const mistyRose = Color(0xFFFFE4E1);
  static Color get cardTranslucent => mistyRose;

  // ─── Hero header gradient (soft pastel, tab üstlerinde) ─────────────────
  static const heroPink = Color(0xFFF9C4D2);
  static const heroPeach = Color(0xFFFDD6A8);

  // ─── Koyu kart / nav bar ───────────────────────────────────────────────
  static const darkCard = Color(0xFF2D2438);
  static const navBar = Color(0xFFF472B6);

  // ─── Yardımcı ─────────────────────────────────────────────────────────
  static const deepPurple = Color(0xFF2D2438);
  static const rose = Color(0xFFF472B6);
  static const blush = Color(0xFFFDE8F0);
  static const cobalt = Color(0xFFD4849A);
  static const lightBlue = Color(0xFFF4A261);
  static const salmon = Color(0xFFF4A261);
  static const cream = Color(0xFFFAF0E6);
  static const muted = Color(0xFF9A8E96);

  // ─── Gradient'ler ─────────────────────────────────────────────────────
  static const gradientPinkOrange = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFF472B6), Color(0xFFFBB47C), Color(0xFFFCD9A8)],
  );
  static const gradientOrangePink = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFFBB47C), Color(0xFFF472B6)],
  );
  static const gradientSoftPink = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFFDE8F0), Color(0xFFFBB47C)],
  );
  static const gradientWarmSunset = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFF472B6), Color(0xFFFBB47C), Color(0xFFFDE8C8)],
  );
  static const gradientDeepPurple = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF2E2536), Color(0xFF1A1520)],
  );
  static const gradientHeroSoft = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [heroPink, heroPeach, Color(0xFFFFFFFF)],
  );
}
