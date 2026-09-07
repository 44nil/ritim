import 'package:flutter/material.dart';

/// Ruh hali isim/ikon/renk üçlüsü — hem _MoodPicker'ın seçenekleri hem de
/// takvimdeki gün hücresi (_DayCell) buradan besleniyor, tek bir yerden
/// (bkz. cycle_tracking_screen.dart) — ikisi ayrı ayrı tanımlı olsaydı
/// birini güncelleyip diğerini unutmak kolay olurdu.
class MoodData {
  MoodData._();

  static const List<(String name, IconData icon, Color color)> all = [
    ('Mutlu', Icons.sentiment_satisfied_rounded, Color(0xFFFFD66B)),
    ('Sakin', Icons.self_improvement_rounded, Color(0xFFA8E6B8)),
    ('Yorgun', Icons.bedtime_rounded, Color(0xFFB8A8E6)),
    ('Hassas', Icons.favorite_rounded, Color(0xFFF4A8C4)),
    ('Sinirli', Icons.sentiment_very_dissatisfied_rounded, Color(0xFFE68A8A)),
  ];

  static (String, IconData, Color)? _find(String? mood) {
    if (mood == null) return null;
    for (final m in all) {
      if (m.$1 == mood) return m;
    }
    return null;
  }

  static Color? colorFor(String? mood) => _find(mood)?.$3;
  static IconData? iconFor(String? mood) => _find(mood)?.$2;
}
