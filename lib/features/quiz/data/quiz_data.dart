/// Tek bir quiz sorusu. Her iddia docs/content-sources.md'de kaynağıyla
/// izleniyor — yayından önce gerçek bir uzman tarafından son onay bekliyor.
class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class QuizData {
  QuizData._();

  static const questions = [
    QuizQuestion(
      question: 'Aşağıdakilerden hangisi regl döngüsü hakkında doğrudur?',
      options: [
        'Döngü her zaman tam 28 gün sürer',
        'Senin yaşında 21-45 gün arası döngü süresi normaldir',
        'Regl sadece 3 gün sürer',
        'Egzersiz regl döneminde zararlıdır',
      ],
      correctIndex: 1,
      explanation:
          'Senin yaşındaki (10-17) bir döngü için 21-45 gün arası tamamen '
          'normal — bu, yetişkinlerdeki aralıktan (21-35 gün) daha geniş. '
          'İlk reglden sonraki birkaç yıl içinde döngün kademeli olarak '
          'daha düzenli hale gelir. "28 gün" sadece bir ortalama, senin '
          'döngün farklı olabilir ve bu sorun değil.\n\n'
          'Kaynak: ACOG & AAP Committee Opinion No. 651 (2015)',
    ),
    QuizQuestion(
      question: 'PMS (regl öncesi sendrom) hakkında hangisi doğrudur?',
      options: [
        'PMS gerçek değildir, sadece hayal gücüdür',
        'Mod değişimi, sinirlilik ve şişkinlik gibi belirtiler yaşayabilirsin — çok yaygın ve normaldir',
        'PMS yaşayan herkesin mutlaka ilaç alması gerekir',
        'PMS sadece yetişkin kadınlarda görülür',
      ],
      correctIndex: 1,
      explanation:
          'PMS, reglden önceki günlerde bazı kızların yaşadığı fiziksel ve '
          'duygusal değişikliklerin genel adı — gerçek bir durum ve çok '
          'yaygın. Belirtiler günlük hayatını ciddi etkiliyorsa güvendiğin '
          'bir yetişkine söylemek iyi bir adımdır, ama her PMS ilaç '
          'gerektirmez.\n\n'
          'Kaynak: ACOG — Premenstrual Syndrome (PMS) FAQ',
    ),
    QuizQuestion(
      question:
          'Regl krampı için hangi yöntem araştırmalarla destekleniyor?',
      options: [
        'Sıcak su torbası — bazı araştırmalarda ağrı kesici hap kadar etkili bulunmuş',
        'Kramp varken hiç hareket etmemek',
        'Kramplara hiçbir şeyin faydası yoktur',
        'Sadece uyumak tek çözümdür',
      ],
      correctIndex: 0,
      explanation:
          'Karnına/beline sıcak su torbası koymak, araştırmalarda ibuprofen '
          'gibi ağrı kesicilere yakın etki göstermiş; ikisini birlikte '
          'kullanmak rahatlamayı hızlandırabiliyor. Hafif hareket de bazı '
          'kızlarda kramp şiddetini azaltabiliyor.\n\n'
          'Kaynak: ACOG Committee Opinion No. 760',
    ),
    QuizQuestion(
      question:
          '"Döngü fazına göre spor yap" trendi hakkında bilim ne diyor?',
      options: [
        'Kesinlikle doğru, her fazda tamamen farklı antrenman yapmalısın',
        'Kontrollü araştırmalar, döngü fazının spor gücünü ölçülebilir şekilde etkilediğine dair bir kanıt bulamadı',
        'Sadece regl gününde spor yapılabilir',
        'Spor regl döngüsünü tamamen durdurur',
      ],
      correctIndex: 1,
      explanation:
          'Bu trend sosyal medyada popüler ama bilim henüz doğrulamıyor. '
          '2023\'te yapılan bir üniversite çalışması, döngü fazının spor '
          'gücünü ya da bedeninin antrenmana verdiği tepkiyi '
          'değiştirdiğine dair bir kanıt bulamadı.\n\n'
          'Kaynak: Frontiers in Sports and Active Living derlemesi (2023)',
    ),
    QuizQuestion(
      question: 'Senin yaşındaki gençler için önerilen günlük uyku süresi nedir?',
      options: [
        '4-5 saat',
        '8-10 saat',
        'Sadece hafta sonu uyumak yeterli',
        'Döngü fazına göre değişir',
      ],
      correctIndex: 1,
      explanation:
          'Döngünün hangi gününde olursan ol, senin yaşındaki gençler için '
          'önerilen uyku süresi günde 8-10 saat.\n\n'
          'Kaynak: American Academy of Sleep Medicine — Teen Sleep '
          'Duration Health Advisory',
    ),
    QuizQuestion(
      question:
          '14-18 yaş kızlar neden yetişkin erkeklere/çocuklara göre daha fazla demire ihtiyaç duyar?',
      options: [
        'İhtiyaç duymazlar, herkeste aynıdır',
        'Regl ile demir kaybı + büyüme çağı olduğu için',
        'Sadece spor yapanlar demire ihtiyaç duyar',
        'Demir sadece et yiyenler için önemlidir',
      ],
      correctIndex: 1,
      explanation:
          'Regl sırasında kan kaybıyla birlikte demir de kaybedilir. '
          'Büyüme çağında olduğun için de bedeninin demire ihtiyacı artıyor '
          '— 14-18 yaş için önerilen günlük miktar (~15mg), henüz regl '
          'görmeyen çocuklara göre neredeyse iki kat fazla.\n\n'
          'Kaynak: Academy of Nutrition and Dietetics',
    ),
  ];
}
