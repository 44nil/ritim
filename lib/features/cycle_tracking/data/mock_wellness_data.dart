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
      nutrition: ['Demir deposu: ıspanak, mercimek, kuru üzüm', 'Meyve: portakal, çilek (C vitamini)', 'Sıcak çorba ve bitki çayları', 'Bir parça bitter çikolata'],
      avoid: ['Çok tuzlu atıştırmalıklar', 'Fazla gazlı içecekler', 'Aşırı şekerli yiyecekler'],
      exercises: ['Hafif tempolu yürüyüş', 'Esneme hareketleri', 'Rahatlatıcı yoga', 'Nefes egzersizleri'],
      waterGoal: 7,
      sleepHours: '9-10 saat',
      sleepTip: 'Yatmadan önce sıcak süt veya papatya çayı dene.',
    ),
    CyclePhase.follicular: PhaseWellness(
      nutrition: ['Yumurta veya peynirli kahvaltı', 'Yoğurt ve kefir (bağırsaklara iyi gelir)', 'Bol yeşillik ve salata', 'Tam buğday ekmek'],
      avoid: ['Fast food', 'Çok şekerli içecekler'],
      exercises: ['Bisiklete bin', 'Arkadaşlarınla yürüyüşe çık', 'Yüzme', 'Yeni bir dans videosu dene!'],
      waterGoal: 7,
      sleepHours: '8-9 saat',
      sleepTip: 'Enerjin yükseliyor ama uyku saatini aksatma.',
    ),
    CyclePhase.ovulation: PhaseWellness(
      nutrition: ['Renkli meyveler: böğürtlen, çilek, kivi', 'Yulaf ezmesi veya granola', 'Ceviz ve badem (bir avuç)', 'Bol sebzeli yemekler'],
      avoid: ['Hazır gıdalar ve cipsi azalt', 'Çok fazla kafeinli içecek'],
      exercises: ['Tempolu koşu veya ip atlama', 'Dans dersi veya Just Dance', 'Voleybol, basketbol gibi sporlar', 'Pilates videoları'],
      waterGoal: 8,
      sleepHours: '8-9 saat',
      sleepTip: 'En enerjik dönemin — ama gece 23:00\'dan sonra ekranları kapat.',
    ),
    CyclePhase.luteal: PhaseWellness(
      nutrition: ['Muz ve avokado (magnezyum)', 'Nohutlu veya mercimekli yemekler', 'Fındık ve kuru meyve', 'Papatya veya melisa çayı'],
      avoid: ['Çok tuzlu yemekler (şişkinlik yapar)', 'Aşırı şekerli atıştırmalıklar', 'Geç saatte ağır yemek'],
      exercises: ['Sakin tempolu yoga', 'Kısa bir yürüyüş', 'Esneme ve meditasyon', 'Hafif bisiklet'],
      waterGoal: 8,
      sleepHours: '9-10 saat',
      sleepTip: 'Uyku kaliten düşebilir. Yatmadan 1 saat önce telefonu bırak.',
    ),
  };

  static PhaseWellness forPhase(CyclePhase phase) => _wellnessMap[phase]!;

  static int waterDrunk = 4;
}
