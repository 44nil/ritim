import 'package:flutter/material.dart';
import '../../../shared/widgets/mood_face.dart';

class MoodType {
  const MoodType({required this.label, required this.face, required this.color});
  final String label;
  final MoodFaceType face;
  final Color color;
}

class MockMoodData {
  MockMoodData._();

  static const moods = [
    MoodType(label: 'Mutlu', face: MoodFaceType.happy, color: Color(0xFFF0A060)),
    MoodType(label: 'Sakin', face: MoodFaceType.calm, color: Color(0xFF90C090)),
    MoodType(label: 'Yorgun', face: MoodFaceType.tired, color: Color(0xFFA0A8D0)),
    MoodType(label: 'Hassas', face: MoodFaceType.sensitive, color: Color(0xFFD898B0)),
    MoodType(label: 'Sinirli', face: MoodFaceType.angry, color: Color(0xFFE87860)),
    MoodType(label: 'Üzgün', face: MoodFaceType.sad, color: Color(0xFF9888C0)),
  ];

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
