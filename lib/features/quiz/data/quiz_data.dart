/// Tek bir quiz sorusu. Şık sayısı sabit değil (2 ya da 3 olabilir).
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
    // ─── Vücudumuzu Tanıyalım ──────────────────────────────────────────
    QuizQuestion(
      question:
          'Regl olmak (adet görmek), büyüyen kızların vücudunun harika bir '
          'parçasıdır. Sence regl dönemi vücudumuz için ne anlama gelir?',
      options: [
        'Vücudun hasta olduğunu gösteren geçici bir durumdur',
        'Vücudun sağlıklı bir şekilde büyüdüğünü ve geliştiğini gösteren doğal bir süreçtir',
        'Sadece bazı sporları yapmamızı engelleyen bir zamandır',
      ],
      correctIndex: 1,
      explanation:
          'Kesinlikle harika bir süreç! Regl olmak bir hastalık veya '
          'saklanması gereken bir sır değildir. Kadın üreme sisteminin '
          'sağlıklı ve tıkır tıkır çalıştığının en tatlı işaretidir.',
    ),
    QuizQuestion(
      question: 'İlk regl kanaması her arkadaşımızda tam olarak aynı yaşta mı başlar?',
      options: [
        'Evet, her kız tam olarak 12 yaşını doldurduğu gün regl olur',
        'Hayır, her kızın vücut saati farklıdır; genellikle 10 ila 15 '
            'yaşları arasında herhangi bir zamanda başlayabilir',
        'Hayır, ilk regl sadece lise bittikten sonra başlar',
      ],
      correctIndex: 1,
      explanation:
          'Tıpkı hepimizin boyunun, saç renginin veya ayak numarasının '
          'farklı olması gibi, vücudumuzun iç saati de kendine özeldir. '
          'Arkadaşından daha erken veya geç regl olman tamamen normaldir.',
    ),
    QuizQuestion(
      question:
          'Ortalama bir regl döngüsü (bir reglin ilk gününden sonraki '
          'reglin ilk gününe kadar geçen süre) kaç gün sürer?',
      options: ['1 gün', 'Yaklaşık 21 ila 35 gün', 'Tam bir yıl'],
      correctIndex: 1,
      explanation:
          'Döngü süresi kişiden kişiye değişebilir, 21-35 gün arası '
          'tamamen normal kabul edilir.',
    ),
    QuizQuestion(
      question:
          'İlk regl dönemi başladıktan sonraki ilk birkaç yıl boyunca, '
          'sonraki regl günlerinin tam vaktinde gelmemesi veya bazı '
          'aylarda gecikmesi normal midir?',
      options: [
        'Hayır, bu vücudumuzun bozulduğunu gösterir ve hemen hastaneye yatılması gerekir',
        'Evet, tamamen normaldir! Vücudumuz ve hormonlarımız bu yeni duruma alışmaya çalışıyordur',
        'Normal değildir, regl başladıktan sonra her ay bir saat gibi kusursuz çalışmalıdır',
      ],
      correctIndex: 1,
      explanation:
          'Endişelenme! İlk yıllarda regl takviminin biraz şaşırması, '
          'düzensiz olması çok doğaldır. Vücudun bu yeni sistemi öğreniyor '
          've zamanla kendi ritmini (düzenini) bulacaktır.',
    ),

    // ─── Özbakım ve Hijyen Kahramanları ────────────────────────────────
    QuizQuestion(
      question:
          'Gün içinde hijyenik pedleri veya diğer regl ürünlerini ne '
          'sıklıkla değiştirmek en sağlıklı ve rahat olanıdır?',
      options: [
        'Yoğunluğa bağlı olarak her 3-4 saatte bir düzenli olarak',
        'Sabah takıp bütün gün boyunca hiç değiştirmemek yeterlidir',
        'Sadece uyumadan önce günde bir kez değiştirmek gerekir',
      ],
      correctIndex: 0,
      explanation:
          'Aferin! Pedleri düzenli değiştirmek cildimizi korur, kendimizi '
          'tertemiz, ferah ve güvende hissetmemizi sağlar. Yanında her '
          'zaman yedek bir ped bulundurmayı unutma!',
    ),
    QuizQuestion(
      question:
          'Kullanılmış bir pedi değiştirdikten sonra onu en doğru '
          'şekilde nasıl vedalaştırmalıyız?',
      options: [
        'Tuvalete atıp sifonu çekerek',
        'Temiz bir tuvalet kağıdına veya yeni pedin ambalajına sarıp çöp kutusuna atarak',
        'Odamızdaki çalışma masasının üzerinde bırakarak',
      ],
      correctIndex: 1,
      explanation:
          'Doğru cevap! Pedler tuvalete atıldığında boruları tıkayabilir. '
          'Bu yüzden onu güzelce sarıp çöpe göndermek en temiz ve en '
          'çevreci yoldur.',
    ),
    QuizQuestion(
      question:
          '"Regl döneminde banyo yapmak, duş almak veya saç yıkamak '
          'zararlıdır, kanı durdurur" inanışı doğru mudur?',
      options: [
        'Doğrudur, regl bitene kadar suya hiç dokunmamalıyız',
        'Yanlıştır! Ayakta alınan ılık bir duş bizi temiz tutar, mikroplardan korur ve ağrılarımızı hafifletir',
        'Doğrudur, sadece parmak uçlarımızı yıkayabiliriz',
      ],
      correctIndex: 1,
      explanation:
          'Tam bir temizlik zamanı! Reglken temizliğe daha çok dikkat '
          'etmeliyiz. Ilık bir duş almak kaslarını gevşetir ve seni çok '
          'rahatlatır — küvette oturmak yerine ayakta duş almayı tercih et.',
    ),
    QuizQuestion(
      question:
          'Regl döneminde karnımızda veya belimizde hafif ağrılar '
          '(kramplar) hissettiğimizde, kendimizi daha iyi hissetmek için '
          'ne yapabiliriz?',
      options: [
        'Buz gibi soğuk suyla duş alıp saatlerce ağlamak',
        'Karnımıza ılık (aşırı sıcak olmayan) bir su torbası koymak, '
            'dinlenmek ve ılık süt veya bitki çayı içmek',
        'Çok ağır eşyaları kaldırmaya çalışmak',
      ],
      correctIndex: 1,
      explanation:
          'Harika bir yöntem! Ilık uygulamalar ve dinlenmek, karın '
          'kaslarının gevşemesini sağlar ve ağrıyı hafifletir. Ağrın çok '
          'fazlaysa mutlaka annene veya güvendiğin bir büyüğüne haber ver.',
    ),
    QuizQuestion(
      question:
          'Regl döneminde genital bölgemizi (özel bölgemizi) '
          'temizlerken parfümlü sabunlar, duş jelleri veya deodorantlar '
          'kullanmalı mıyız?',
      options: [
        'Hayır, o bölgenin sağlığı için sadece duru su kullanmak en '
            'doğrusudur. Parfümlü ürünler cildimizi tahriş edebilir',
        'Evet, güzel kokması için bol bol parfüm ve sabun sıkmalıyız',
        'Evet, çamaşır suyu ile temizlemeliyiz',
      ],
      correctIndex: 0,
      explanation:
          'Harika bir bilgi! Vücudumuzun o bölgesi kendi kendini koruyan '
          'özel bir sisteme sahiptir. Kimyasal ve parfümlü ürünler bu '
          'sistemi bozabilir. Sadece temiz suyla önden arkaya doğru '
          'yıkamak tamamen yeterli ve sağlıklıdır.',
    ),

    // ─── Günlük Hayat ve Pratik Çözümler ────────────────────────────────
    QuizQuestion(
      question:
          'Okuldayken veya dışarıdayken aniden regl olursak ve yanımızda '
          'hiç ped yoksa ne yapmalıyız?',
      options: [
        'Panik yapıp ağlamalı ve okulu terk etmeliyiz',
        'Hiç kimseye söylemeden sessizce sıramızda oturmalıyız',
        'Okul hemşiresinden, kadın öğretmenlerimizden veya bir kız arkadaşımızdan yardım istemeliyiz',
      ],
      correctIndex: 2,
      explanation:
          'Unutma, dünyadaki tüm kadınlar ve öğretmenlerin bu süreci '
          'yaşıyor! Bu yüzden yardım istemekten asla çekinme. Geçici bir '
          'çözüm olarak tuvalet kağıdını katlayıp çamaşırına koyabilir ve '
          'hemen bir büyüğünden ped isteyebilirsin.',
    ),
    QuizQuestion(
      question:
          'Regl dönemindeyken iç çamaşırımıza veya kıyafetimize kazara '
          'kan lekesi geçerse bu utanılacak bir durum mudur?',
      options: [
        'Evet, bu çok büyük bir hatadır ve herkes bizimle alay eder',
        'Kesinlikle hayır! Bu, regl olan her insanın başına gelebilecek çok doğal bir kazadır',
        'Evet, leke olan kıyafeti hemen çöpe atmalıyız',
      ],
      correctIndex: 1,
      explanation:
          'Hiç utanma, bu sadece küçük bir kaza! Lekeli kıyafetini soğuk '
          'su ve sabunla yıkayarak kolayca temizleyebilirsin. Okula '
          'giderken çantana yedek bir iç çamaşırı ve koyu renkli bir '
          'hırka atmak her zaman iyi bir fikirdir.',
    ),

    // ─── Mitler ve Duygular ─────────────────────────────────────────────
    QuizQuestion(
      question:
          '"Regl dönemindeyken spor yapmak, yüzmek, koşmak veya dans '
          'etmek yasaktır" sözünü duyarsan ne düşünmelisin?',
      options: [
        'Bu çok doğrudur, reglken yataktan hiç çıkmamalıyız',
        'Bu tamamen bir mittir (uydurmadır)! Kendimizi iyi hissettiğimiz '
            'sürece sevdiğimiz tüm hareketleri yapabiliriz',
        'Sadece yürüyüş yapabiliriz ama asla koşamayız',
      ],
      correctIndex: 1,
      explanation:
          'Hareket etmek harikadır! Hatta hafif yürüyüşler, dans etmek '
          'veya esnemek karın ağrılarını azaltmaya ve bizi çok daha mutlu '
          'hissettirmeye yardımcı olur.',
    ),
    QuizQuestion(
      question:
          'Regl olmadan birkaç gün önce veya regl döneminde kendimizi '
          'bazen biraz daha hassas, duygusal ya da çabuk yorulur '
          'hissetmemiz neden tamamen normaldir?',
      options: [
        'Vücudumuzdaki "hormon" adı verilen doğal kimyasal mesajcıların '
            'seviyelerinde küçük değişimler olduğu için',
        'Çünkü artık büyümeyi bıraktığımız için',
        'Çok fazla kitap okuduğumuz için',
      ],
      correctIndex: 0,
      explanation:
          'Hormonlar vücudumuzun gizli şefleri gibidir. Bu dönemde biraz '
          'fazla duygulanman veya çabuk sinirlenmen tamamen onların '
          'dansından kaynaklanır. Kendine şefkatli davran, bu geçici bir durum!',
    ),
    QuizQuestion(
      question: 'Regl dönemiyle ilgili kafamıza bir şey takıldığında en doğrusu ne yapmaktır?',
      options: [
        'İnternetteki korkunç hikayeleri okumak',
        'Annemizle, öğretmenimizle, okul hemşiresiyle veya güvendiğimiz '
            'bir yetişkinle konuşmak',
        'Kimseye söylemeyip gizlemek',
      ],
      correctIndex: 1,
      explanation:
          'Güvendiğin bir yetişkinle konuşmak, doğru ve güvenilir '
          'bilgiye ulaşmanın en iyi yolu.',
    ),
  ];
}
