/// "Günün Sözü" kartında dönen olumlama/motivasyon cümleleri.
class AffirmationData {
  AffirmationData._();

  static const affirmations = [
    // Vücudumla barışığım
    'Vücudum büyüyor, gelişiyor ve benim için harika işler yapıyor. Onunla gurur duyuyorum! 🌟',
    'Regl olmak, büyüdüğümün ve vücudumun sağlıklı çalıştığının en doğal işaretidir. 🌸',
    'Her vücudun ritmi kendine özeldir. Kendi büyüme yolculuğumu çok seviyorum! ✨',
    'Bugün vücuduma daha nazik davranacağım. O çok güçlü ve değerli. 💜',
    'Vücudumdaki her değişim, beni ben yapan harika birer adım!',
    'Ben harikayım, vücudum harika! Birlikte büyümek çok güzel. 🦄',
    'Büyüme yolculuğumda vücudumun sesini dinlemeyi ve ona iyi bakmayı öğreniyorum.',
    // Duygusal destek ve güven
    'Bugün kendimi biraz yorgun veya duygusal hissetmem çok normal. Kendime dinlenmek için izin veriyorum. 🛋️',
    'Duygularım tıpkı bulutlar gibi; gelirler, geçerler ve hava yeniden güneş açar. ☀️',
    'Bugün ekstra şefkati hak ediyorum. Kendime en sevdiğim aktiviteyle küçük bir ödül vereceğim. 🍪',
    'Unutma, yalnız değilsin. Dünyadaki milyonlarca kız çocuk şu an seninle aynı harika süreci paylaşıyor! 🌍',
    'İçimdeki güç, hissettiğim her türlü yorgunluktan çok daha büyük! 💪',
    'Dinlenmek tembellik değildir; vücudumun şarj olma yöntemidir. Bugün bol bol dinlenebilirim.',
    'Bazen biraz durmak ve derin bir nefes almak her şeye iyi gelir. Derin bir nefes al, sen harikasın! 🍃',
    // Motivasyon ve güç
    'Regl olmam, hayallerimin peşinden koşmama asla engel değil. Bugün de parlamaya devam edeceğim! ⭐',
    'Kendimi iyi hissettiğim sürece spor yapabilir, dans edebilir ve dünyayı keşfedebilirim! 🏃‍♀️',
    'Bugün çantamda pedim, kalbimde cesaretim var. Okulda veya dışarıda her şeye hazırım! 🎒',
    'Kafama bir şey takılırsa güvendiğim bir yetişkine sormaktan çekinmem. Soru sormak beni güçlendirir! 💬',
    'Küçük kazalar (lekeler) her zaman olur ve bu çok doğaldır. Ben her halimle güvendeyim ve güçlüyüm! 🛡️',
    'Bugün kendime "Yapabilirim!" diyorum. Çünkü ben kendi hikayemin kahramanıyım!',
    'Gülümse! Yeni bir gün, yeni bir enerji ve büyüyen harika bir SEN demek! 🌈',
  ];

  static String forDay(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year)).inDays;
    return affirmations[dayOfYear % affirmations.length];
  }
}
