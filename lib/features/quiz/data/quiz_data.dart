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
    QuizQuestion(
      question: 'Tampon kullanıyorsan hangisi doğrudur?',
      options: [
        'Bir tamponu 8 saatten uzun süre takılı bırakmak sorun değildir',
        'Tamponu 4-8 saatte bir değiştirmek, nadir ama ciddi bir enfeksiyon riskini (TSS) azaltır',
        'Tampon sadece yüzerken kullanılabilir',
        'Tampon kullanmak için önce doktor onayı şart',
      ],
      correctIndex: 1,
      explanation:
          'Toksik Şok Sendromu (TSS) çok nadir görülür ama ciddi olabilir. '
          'Tamponu 4-8 saatte bir değiştirmek ve hiçbir zaman 8 saatten uzun '
          'takılı bırakmamak riski azaltır. Ateş, döküntü ya da ani halsizlik '
          'hissedersen tamponu çıkarıp bir yetişkine söylemelisin.\n\n'
          'Kaynak: FDA — "The Facts on Tampons—and How to Use Them Safely"',
    ),
    QuizQuestion(
      question: 'İlk regl (menarş) genelde hangi yaşlar arasında başlar?',
      options: [
        'Sadece herkeste tam 13 yaşında',
        '8 yaşında başlamak da tamamen normaldir',
        'Genellikle 10-15 yaş arasında, ortalama yaklaşık 12,5',
        'Herkeste birebir aynı yaşta başlar',
      ],
      correctIndex: 2,
      explanation:
          'İlk regl çoğunlukla 10-15 yaş arasında başlar, ortanca yaş '
          '12,4 civarında. Biraz erken ya da geç başlaman çoğu zaman sorun '
          'değil — 9 yaşından önce ya da 15 yaşına kadar hiç başlamamışsa bir '
          'doktora danışmak iyi olur.\n\n'
          'Kaynak: American Academy of Pediatrics (AAP) — "Menstruation in '
          'Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign"',
    ),
    QuizQuestion(
      question: 'Regl günleri dışında iç çamaşırında berrak/beyazımsı bir akıntı görmek...',
      options: [
        'Her zaman bir enfeksiyon belirtisidir',
        'Genellikle tamamen normaldir, vücudun kendini temizleme şeklidir',
        'Sadece regl olduktan hemen sonra görülür',
        'Hemen ilaç kullanmayı gerektirir',
      ],
      correctIndex: 1,
      explanation:
          'Berrak ya da hafif beyazımsı, hafif kokulu bir akıntı görmek '
          'normal — vücudun kendini temizleme yollarından biri, ilk reglinden '
          '6 ay-1 yıl önce başlayabilir. Renk değişikliği (yeşil/gri), kötü '
          'koku, kaşıntı ya da yanma varsa bir yetişkine söylemek iyi bir '
          'adımdır.\n\n'
          'Kaynak: Nemours KidsHealth — "Is My Vaginal Discharge Normal? (for Teens)"',
    ),
    QuizQuestion(
      question: 'Ped kullanırken ne sıklıkla değiştirmek önerilir?',
      options: [
        'Günde sadece bir kez yeterlidir',
        'Akış hafif olsa bile birkaç saatte bir, yoğun akışta daha sık',
        'Sadece kirlendiğini fark edince',
        'Değiştirmeye gerek yok, tek ped bütün gün yeter',
      ],
      correctIndex: 1,
      explanation:
          'Akışın hafif olsa bile pedi birkaç saatte bir değiştirmek '
          'öneriliyor; akış yoğunsa daha sık değiştirmek gerekir. Bu hem '
          'hijyen hem de cilt tahrişini önlemek için önemli.\n\n'
          'Kaynak: FDA — "Menstrual Pads and Liners" (Menstrual Product '
          'Options, Facts, and Safe Use)',
    ),
    QuizQuestion(
      question: 'Kafein (kola, çikolata, bazı çaylar) PMS belirtileriyle nasıl ilişkilidir?',
      options: [
        'PMS\'i tamamen ortadan kaldırır',
        'Reglden önceki günlerde azaltmak bazı kızlarda belirtileri hafifletebilir',
        'Hiçbir etkisi olmadığı kesin olarak kanıtlanmıştır',
        'Sadece kahve bu etkiyi yapar, çikolata yapmaz',
      ],
      correctIndex: 1,
      explanation:
          'Reglden önceki iki hafta içinde kafeini (ayrıca tuz ve '
          'şekeri) azaltmak, bazı kızlarda PMS belirtilerini hafifletebiliyor. '
          'Bu herkes için aynı etkiyi yapmayabilir — kendi bedenini gözlemlemek '
          'en iyi yol.\n\n'
          'Kaynak: Office on Women\'s Health (OWH) — "Premenstrual syndrome (PMS)"',
    ),
    QuizQuestion(
      question: 'Kramp varken hafif egzersiz (yürüyüş, esneme gibi) yapmak konusunda araştırmalar ne diyor?',
      options: [
        'Egzersizin krampları azalttığına dair hiçbir kanıt yok',
        'Yapılan araştırmalarda egzersiz, sıcak su torbası ve akupresürden daha güçlü etkili bulundu',
        'Sadece yüzme işe yarar, başka hiçbir hareket etmez',
        'Regl döneminde spor yapmak tamamen yasaktır',
      ],
      correctIndex: 1,
      explanation:
          'Öz bakım yöntemlerini karşılaştıran bir sistematik derlemede '
          'egzersizin kramplara etkisi, sıcak su torbası ve akupresürden bile '
          'daha güçlü çıktı. Kendini kötü hissediyorsan zorlamana gerek yok — '
          'bedenine göre karar ver.\n\n'
          'Kaynak: Armour ve ark., BMC Complementary and Alternative Medicine '
          '(2019) — sistematik derleme ve meta-analiz',
    ),
    QuizQuestion(
      question: 'Aşağıdakilerden hangisi bir yetişkine/doktora söylenmesi gereken bir durumdur?',
      options: [
        'Reglin 5 gün sürmesi',
        'Bir pedi/tamponu art arda birkaç saat boyunca saatte bir değiştirmen gerekmesi',
        'Hafif kramp hissetmen',
        'Reglin arada bir birkaç gün erken/geç gelmesi',
      ],
      correctIndex: 1,
      explanation:
          'Bir pedi/tamponu art arda birkaç saat boyunca saatte bir ya '
          'da daha sık değiştirmen gerekiyorsa, ya da regl 7 günden uzun '
          'sürüyorsa bir yetişkinle konuşup doktora görünmek önemli. Diğer '
          'seçenekler genellikle normal sınırlar içinde.\n\n'
          'Kaynak: ACOG — "Heavy Menstrual Bleeding" (Hasta Bilgilendirmesi)',
    ),
    QuizQuestion(
      question: 'Reglin aylarca kesilmesine (hamile olmadan) ne sebep olabilir?',
      options: [
        'Bu asla olmaz, regl asla kesilmez',
        'Çok düşük vücut ağırlığı, aşırı yoğun antrenman ya da uzun süreli stres',
        'Sadece yaşlı kadınlarda görülür',
        'Sadece soğuk havada olur',
      ],
      correctIndex: 1,
      explanation:
          'Çok düşük vücut ağırlığı, aşırı yoğun antrenman ya da uzun '
          'süreli stres, vücudun hormon üretimini geçici olarak durdurmasına '
          '(amenore) yol açabilir. Bu, vücudunun bir uyarı sinyali olabilir — '
          'reglin 3 aydan uzun süre kesilirse bir yetişkinle konuşup doktora '
          'görünmek önemlidir.\n\n'
          'Kaynak: ACOG — "Amenorrhea: Absence of Periods" (Hasta Bilgilendirmesi)',
    ),
    QuizQuestion(
      question: 'Döngü boyunca ruh halinin dalgalanması hakkında hangisi doğrudur?',
      options: [
        'Bu sadece "kafanda kurduğun" bir şeydir, gerçek bir sebebi yoktur',
        'Östrojen ve progesteron seviyelerindeki gerçek değişimler ruh halini etkileyebilir',
        'Sadece zayıf iradeli kızlar ruh hali değişimi yaşar',
        'Ruh hali sadece regl bittikten sonra değişir',
      ],
      correctIndex: 1,
      explanation:
          'Döngü boyunca östrojen ve progesteron seviyeleri değişir ve '
          'bu, bedeninde birçok şeyi (duygular dahil) gerçekten etkileyebilir '
          '— yani hissettiklerinin gerçek bir biyolojik sebebi var, "kafanda '
          'kurduğun" bir şey değil.\n\n'
          'Kaynak: Office on Women\'s Health (OWH) — "Your menstrual cycle"',
    ),
    QuizQuestion(
      question: 'Ped, tampon ve menstrual kap arasında hangisi "en doğru" seçimdir?',
      options: [
        'Sadece ped kullanmak doğrudur, diğerleri güvenli değildir',
        'Hiçbiri "en doğru" değildir — doğru kullanıldıklarında hepsi güvenlidir, seçim sana kalmış',
        'Tampon kullanmak için evli olman gerekir',
        'Menstrual kap sadece yetişkinler için üretilir',
      ],
      correctIndex: 1,
      explanation:
          'Ped, tampon ve menstrual kap — hepsi FDA tarafından '
          'düzenlenen, doğru kullanıldığında güvenli seçenekler. Hangisinin '
          'sana daha rahat geldiği kişisel bir tercih ve istediğinde '
          'değiştirebilirsin. Yeni bir şey denemeden önce bir yetişkine '
          'sorman, doğru kullanımı öğrenmene yardımcı olur.\n\n'
          'Kaynak: FDA — "Menstrual Product Options, Facts, and Safe Use"',
    ),
  ];
}
