import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 3 font sistemi:
/// 1. Abril Fatface — büyük başlıklar, cesur, serif
/// 2. Poppins — body, etiketler, okunabilir sans-serif
/// 3. Dancing Script — vurgu, motivasyon, cursive el yazısı
abstract class AppTextStyles {
  static TextTheme buildTextTheme({required Color bodyColor, required Color displayColor}) {
    return GoogleFonts.poppinsTextTheme().copyWith(
      // Büyük başlıklar — Abril Fatface
      displayLarge: GoogleFonts.abrilFatface(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: displayColor,
        height: 1.15,
      ),
      displayMedium: GoogleFonts.abrilFatface(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: displayColor,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.abrilFatface(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: displayColor,
        height: 1.25,
      ),

      // Ekran başlıkları — Abril Fatface
      headlineLarge: GoogleFonts.abrilFatface(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: displayColor,
      ),
      headlineMedium: GoogleFonts.abrilFatface(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: displayColor,
      ),
      headlineSmall: GoogleFonts.abrilFatface(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: displayColor,
      ),

      // Alt başlıklar — Poppins
      titleLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: bodyColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),

      // Gövde metni — Poppins
      bodyLarge: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: bodyColor,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: bodyColor,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: bodyColor,
        height: 1.5,
      ),

      // Etiketler — Poppins
      labelLarge: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: bodyColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: bodyColor,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Cursive vurgu stili — motivasyon cümleleri, özel vurgular
  static TextStyle accent({double fontSize = 22, Color? color}) {
    return GoogleFonts.dancingScript(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.3,
    );
  }

  /// Kart başlığı — Abril Fatface, her boyutta kullanılabilir
  static TextStyle heading({double fontSize = 16, Color? color}) {
    return GoogleFonts.abrilFatface(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.2,
    );
  }
}
