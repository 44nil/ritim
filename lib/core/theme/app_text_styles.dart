import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Poppins seçildi: yuvarlak harfler, geniş x-yüksekliği, yüksek okunabilirlik.
/// 13 yaşındaki bir kullanıcı ekranda ilk bakışta metni rahatça okuyabilmeli.
abstract class AppTextStyles {
  static TextTheme buildTextTheme({required Color bodyColor, required Color displayColor}) {
    return GoogleFonts.poppinsTextTheme().copyWith(
      // Başlıklar
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: displayColor,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: displayColor,
        height: 1.25,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: displayColor,
        height: 1.3,
      ),

      // Ekran ve kart başlıkları
      headlineLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: displayColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: displayColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: displayColor,
      ),

      // Buton ve etiketler
      titleLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
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

      // Gövde metni — okunabilirlik için 15/14 px
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

      // Küçük etiket / chip
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
}
