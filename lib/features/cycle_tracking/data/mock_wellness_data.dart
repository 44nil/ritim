import 'mock_cycle_data.dart';

class PhaseWellness {
  const PhaseWellness({
    required this.nutrition,
    required this.avoid,
    required this.exercises,
    required this.waterGoal,
    required this.sleepHours,
    required this.sleepTip,
  });

  final List<String> nutrition;
  final List<String> avoid;
  final List<String> exercises;
  final int waterGoal;
  final String sleepHours;
  final String sleepTip;
}

class MockWellnessData {
  MockWellnessData._();

  static const _wellnessMap = {
    CyclePhase.menstruation: PhaseWellness(
      nutrition: ['Demir: ıspanak, kırmızı et, mercimek', 'C vitamini: portakal, çilek', 'Sıcak çorbalar ve çaylar', 'Bitter çikolata (magnezyum)'],
      avoid: ['Aşırı tuz (şişkinlik yapar)', 'Kafein (krampları artırır)', 'Şekerli atıştırmalıklar'],
      exercises: ['Hafif yürüyüş', 'Yin yoga', 'Esneme hareketleri', 'Nefes egzersizleri'],
      waterGoal: 8,
      sleepHours: '8-9 saat',
      sleepTip: 'Sıcak su torbası ve lavanta çayı uykuya yardımcı olur.',
    ),
    CyclePhase.follicular: PhaseWellness(
      nutrition: ['Protein: yumurta, tavuk, tofu', 'Fermente gıdalar: yoğurt, kefir', 'Yeşil yapraklı sebzeler', 'Tam tahıllar'],
      avoid: ['Ağır yağlı yemekler', 'Fazla şeker'],
      exercises: ['Koşu', 'Bisiklet', 'Yüzme', 'Yeni bir spor dene!'],
      waterGoal: 8,
      sleepHours: '7-8 saat',
      sleepTip: 'Enerjin yükseliyor, ama uyku düzenini korumayı unutma.',
    ),
    CyclePhase.ovulation: PhaseWellness(
      nutrition: ['Antioksidanlar: böğürtlen, yaban mersini', 'Lifli gıdalar: kinoa, yulaf', 'Omega-3: somon, ceviz', 'Bol meyve ve sebze'],
      avoid: ['Aşırı kafein', 'İşlenmiş gıdalar'],
      exercises: ['HIIT antrenman', 'Dans', 'Takım sporları', 'Pilates'],
      waterGoal: 10,
      sleepHours: '7-8 saat',
      sleepTip: 'En enerjik dönemin — ama geç yatmaktan kaçın.',
    ),
    CyclePhase.luteal: PhaseWellness(
      nutrition: ['Magnezyum: muz, avokado, badem', 'B6 vitamini: nohut, patates', 'Kompleks karbonhidratlar', 'Papatya çayı'],
      avoid: ['Alkol', 'Aşırı tuz', 'Rafine şeker'],
      exercises: ['Yoga', 'Hafif yürüyüş', 'Meditasyon', 'Esneme'],
      waterGoal: 9,
      sleepHours: '8-9 saat',
      sleepTip: 'Uyku kaliten düşebilir. Yatmadan 1 saat önce ekranlardan uzak dur.',
    ),
  };

  static PhaseWellness get current => _wellnessMap[MockCycleData.currentPhase.phase]!;

  static int waterDrunk = 5; // Mock: bugün içilen bardak
}
