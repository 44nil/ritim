import 'package:flutter/material.dart';

/// Ritim renk paleti — Lunelli Primavera Verão 26 ilham.
/// Sıcak bordo, pembe, turuncu, bej harmonisi.
abstract class AppColors {
  // ─── Primary: Fragrância / Pembe ────────────────────────────────────────
  static const primary = Color(0xFFE8A8C8);
  static const primaryContainer = Color(0xFFFAE8F2);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFF5C1830);

  // ─── Secondary: Afinidade / Derin Bordo ─────────────────────────────────
  static const secondary = Color(0xFF5C1830);
  static const secondaryContainer = Color(0xFFF0D0D8);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFF3A0C1A);

  // ─── Tertiary: Orvalho / Sıcak Bej ─────────────────────────────────────
  static const tertiary = Color(0xFFC8B8A0);
  static const tertiaryContainer = Color(0xFFF5EBE0);
  static const onTertiary = Color(0xFFFFFFFF);

  // ─── Neutral / Surface ──────────────────────────────────────────────────
  static const backgroundLight = Color(0xFFFFF8F6);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceVariantLight = Color(0xFFF5F0F4);
  static const onBackgroundLight = Color(0xFF2A2828);
  static const onSurfaceLight = Color(0xFF2A2828);
  static const outlineLight = Color(0xFFD4C4CF);

  // ─── Dark theme ─────────────────────────────────────────────────────────
  static const backgroundDark = Color(0xFF1A1518);
  static const surfaceDark = Color(0xFF241820);
  static const surfaceVariantDark = Color(0xFF2E2028);
  static const onBackgroundDark = Color(0xFFF0E8E8);
  static const onSurfaceDark = Color(0xFFF0E8E8);
  static const outlineDark = Color(0xFF5A4850);

  // ─── Semantic ───────────────────────────────────────────────────────────
  static const error = Color(0xFFD45A7A);
  static const onError = Color(0xFFFFFFFF);
  static const success = Color(0xFFC8B8A0); // bej-yeşil yerine warm
  static const warning = Color(0xFFE87828); // Mystique turuncu

  // ─── Cycle phase renkleri ───────────────────────────────────────────────
  static const phaseMenstruation = Color(0xFFD88B9A); // Adet — coral/pembe
  static const phaseFollicular = Color(0xFFC8B8A0);   // Foliküler — sıcak bej
  static const phaseOvulation = Color(0xFFE87828);    // Ovülasyon — Mystique turuncu
  static const phaseLuteal = Color(0xFFB5749A);        // Luteal — gül kurusu

  // ─── Koyu kart rengi ───────────────────────────────────────────────────
  static const darkCard = Color(0xFF5C1830); // Afinidade — derin bordo
}
