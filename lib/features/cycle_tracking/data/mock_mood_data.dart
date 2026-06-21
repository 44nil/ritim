import 'package:flutter/material.dart';

class MoodType {
  const MoodType({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;
}

class MockMoodData {
  MockMoodData._();

  static const moods = [
    MoodType(label: 'Mutlu', icon: Icons.sentiment_very_satisfied_rounded, color: Color(0xFFF0A060)),
    MoodType(label: 'Sakin', icon: Icons.sentiment_satisfied_rounded, color: Color(0xFF90C090)),
    MoodType(label: 'Yorgun', icon: Icons.sentiment_neutral_rounded, color: Color(0xFFA0A8D0)),
    MoodType(label: 'Hassas', icon: Icons.sentiment_dissatisfied_rounded, color: Color(0xFFD898B0)),
    MoodType(label: 'Sinirli', icon: Icons.sentiment_very_dissatisfied_rounded, color: Color(0xFFE87860)),
    MoodType(label: 'Üzgün', icon: Icons.mood_bad_rounded, color: Color(0xFF9888C0)),
  ];

  // Mock: bu ayki günlük mood kayıtları (gün → mood index)
  static final Map<int, int> monthlyMoods = {
    1: 0, 2: 0, 3: 1, 4: 1, 5: 3,
    6: 4, 7: 3, 8: 2, 9: 1, 10: 0,
    11: 0, 12: 1, 13: 2, 14: 1, 15: 0,
    16: 3, 17: 2, 18: 1, 19: 0, 20: 0,
  };

  static MoodType? getMoodForDay(int day) {
    final index = monthlyMoods[day];
    if (index == null) return null;
    return moods[index];
  }

  // Aylık özet: en çok hangi mood?
  static MoodType get monthlySummary {
    final counts = <int, int>{};
    for (final index in monthlyMoods.values) {
      counts[index] = (counts[index] ?? 0) + 1;
    }
    final topIndex = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return moods[topIndex];
  }

  static int get loggedDays => monthlyMoods.length;
  static int get totalDays => DateTime.now().day;
}
