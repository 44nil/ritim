import 'package:flutter/material.dart';

/// Ruh hali isimlerini yumuşak, birbirinden ayırt edilebilir renklere eşler
/// — takvimde bir günü o günün ruh haline göre renklendirebilmek için
/// (bkz. cycle_tracking_screen.dart, _DayCell). İsimler _MoodPicker'daki
/// listeyle birebir aynı olmalı.
class MoodData {
  MoodData._();

  static const Map<String, Color> colors = {
    'Mutlu': Color(0xFFFFD66B),
    'Sakin': Color(0xFFA8E6B8),
    'Yorgun': Color(0xFFB8A8E6),
    'Hassas': Color(0xFFF4A8C4),
    'Sinirli': Color(0xFFE68A8A),
  };

  static Color? colorFor(String? mood) => mood == null ? null : colors[mood];
}
