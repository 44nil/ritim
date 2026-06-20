import 'package:flutter/material.dart';

/// Ritim renk paleti — sıcak, nötr, ergen dostu.
/// Pembe-mor tonları abartısız tutuldu; hem light hem dark tema desteklenir.
abstract class AppColors {
  // ─── Primary: Dusty Rose / Gül Kurusu ───────────────────────────────────
  static const primary = Color(0xFFB5749A);
  static const primaryContainer = Color(0xFFFAE8F2);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFF3D1030);

  // ─── Secondary: Soft Lavender / Leylak ──────────────────────────────────
  static const secondary = Color(0xFF8B7BB5);
  static const secondaryContainer = Color(0xFFEDE8F8);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFF241457);

  // ─── Tertiary: Warm Sand / Kum Beji ─────────────────────────────────────
  static const tertiary = Color(0xFFC4A882);
  static const tertiaryContainer = Color(0xFFF5EBE0);
  static const onTertiary = Color(0xFFFFFFFF);

  // ─── Neutral / Surface ──────────────────────────────────────────────────
  static const backgroundLight = Color(0xFFFFF8F6);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceVariantLight = Color(0xFFF5F0F4);
  static const onBackgroundLight = Color(0xFF2D2028);
  static const onSurfaceLight = Color(0xFF2D2028);
  static const outlineLight = Color(0xFFD4C4CF);

  // ─── Dark theme ─────────────────────────────────────────────────────────
  static const backgroundDark = Color(0xFF1A151E);
  static const surfaceDark = Color(0xFF24202A);
  static const surfaceVariantDark = Color(0xFF2E2936);
  static const onBackgroundDark = Color(0xFFF0E8F0);
  static const onSurfaceDark = Color(0xFFF0E8F0);
  static const outlineDark = Color(0xFF5A4E5A);

  // ─── Semantic ───────────────────────────────────────────────────────────
  static const error = Color(0xFFD45A7A);
  static const onError = Color(0xFFFFFFFF);
  static const success = Color(0xFF7BA88B);
  static const warning = Color(0xFFE8A87C);

  // ─── Cycle phase renkleri (döngü takibi için) ───────────────────────────
  static const phaseMenstruation = Color(0xFFD88B9A); // Adet — yumuşak coral/mauve
  static const phaseFollicular = Color(0xFF7BA8D4);   // Foliküler
  static const phaseOvulation = Color(0xFF7BA88B);    // Ovülasyon
  static const phaseLuteal = Color(0xFFB5749A);        // Luteal
}
