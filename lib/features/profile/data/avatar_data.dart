import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Profil avatarı için hazır emoji + renk seçenekleri — fotoğraf yükleme
/// yerine basit, "tatlı" bir kişiselleştirme. `colors[0]` her zaman
/// varsayılan (isim baş harfi görünümüyle uyumlu) softPink tonu.
class AvatarData {
  AvatarData._();

  static const emojis = ['🌸', '🦋', '⭐', '🌙', '☀️', '💛', '🐱', '🌈'];

  static const colors = [
    AppColors.softPink,
    AppColors.warmOrange,
    Color(0xFFA8E6B8),
    Color(0xFFB8A8E6),
    Color(0xFFFFD66B),
    Color(0xFFF4A8C4),
  ];

  static Color colorAt(int index) => colors[index % colors.length];
}
