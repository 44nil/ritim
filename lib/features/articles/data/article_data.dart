import 'package:flutter/material.dart';

/// Bir makale gövdesinin tek bir bölümü. `heading` doluysa (ör. adım
/// listelerinde) bu bölüm ayrı bir başlık altında gösterilir; boşsa düz bir
/// paragraf olarak akar.
class ArticleSection {
  const ArticleSection({this.heading, required this.text, this.icon});
  final String? heading;
  // `text` içinde **böyle** işaretlenmiş kelimeler kalın gösterilir (bkz.
  // article_detail_screen.dart _boldedText) — çocuğun gözünün anahtar
  // kelimelerde takılıp kalması için, ayrı bir zengin metin modeli
  // kurmadan basit bir işaretleme.
  final String text;
  final IconData? icon;
}

/// Bir makalenin başlığı, listedeki kısa tanıtımı VE gerçek gövde metni.
/// Gövdedeki her iddia docs/content-sources.md'de kaynağıyla izleniyor —
/// yayından önce gerçek bir uzman tarafından son onay bekliyor.
class Article {
  const Article({
    required this.title,
    required this.subtitle,
    required this.readTime,
    required this.level,
    required this.icon,
    required this.category,
    required this.body,
    this.isChecklist = false,
  });

  final String title;
  final String subtitle;
  final String readTime;
  final String level;
  final IconData icon;
  final String category;
  final List<ArticleSection> body;
  // Bir "adım listesi" değil de gerçek bir paket/kontrol listesiyse
  // (ör. çantanda ne olmalı) numaralı kartlar yerine daha sade, işaretli
  // bir kontrol listesi görünümü kullanılır — bkz. ArticleDetailScreen.
  final bool isChecklist;
}

class ArticleData {
  ArticleData._();

  static const featured = Article(
    title: 'Döngünü Tanımak:\nBaşlangıç Rehberi',
    subtitle:
        'Vücudunda her ay neler oluyor? İlk reglden döngü fazlarına, bilmen gereken her şey.',
    readTime: '6 dk',
    level: 'Başlangıç',
    icon: Icons.menu_book_rounded,
    category: 'Döngü',
    body: [
      ArticleSection(
        text:
            'Regl döngüsü sadece kanama günlerinden ibaret değil. Bedenin '
            'aslında ay boyunca sessizce çalışıyor — regl günü bunun sadece '
            'gözle görülen kısmı.',
      ),
      ArticleSection(
        heading: 'Döngü süresi kişiden kişiye değişir',
        icon: Icons.calendar_month_rounded,
        text:
            'Bu yaşlarda döngün henüz kendi ritmini arıyor. Yetişkinlerde '
            'döngü genelde 21-35 gün sürer, ama senin yaşında (10-17) bu '
            '**21-45 güne kadar çıkabilir** — bu tamamen normal. Bedenin ilk '
            'reglden sonraki birkaç yıl içinde kendi düzenini buluyor. Bu ay '
            'ile geçen ay farklı sürse bile kaygılanmana gerek yok.',
      ),
      ArticleSection(
        heading: 'Döngünün 4 evresi',
        icon: Icons.autorenew_rounded,
        text:
            '**Regl** (kanamanın olduğu günler) → **Toparlanma Dönemi** (regl '
            'bitip bedenin yeniden enerji topladığı dönem) → **Canlanma '
            'Dönemi** (kısa bir yumurtlama penceresi) → **Sakinleşme Dönemi** '
            '(bir sonraki regle kadar olan dönem). Ritim\'in sana her gün '
            'farklı bir faz göstermesinin sebebi bu.',
      ),
      ArticleSection(
        heading: 'Neden kaydediyoruz?',
        icon: Icons.edit_note_rounded,
        text:
            'Döngünü kaydetmek "doğru cevap" bulmak için değil — kendi '
            'düzenini tanımak için. Hangi günlerde nasıl hissettiğini fark '
            'etmek, zamanla bedenini daha iyi anlamana yardımcı olur.',
      ),
      ArticleSection(
        text:
            'Burada yargılanmadan, kendi hızında öğrenebilirsin. Her bedenin '
            'hikâyesi biraz farklı — ve bu tamamen senin hikâyen.',
      ),
    ],
  );

  static const articles = [
    Article(
      title: 'Regl Sancısıyla Başa Çıkmanın 5 Yolu',
      subtitle: 'Kramplar seni yıldırmasın',
      readTime: '4 dk',
      level: 'Başlangıç',
      icon: Icons.favorite_outline_rounded,
      category: 'Sağlık',
      body: [
        ArticleSection(
          text:
              'Regl krampı, genç kızlarda en sık yaşanan regl belirtisi '
              '(doktorlar buna **"dismenore"** der). Kramplar rahim '
              'kaslarının kanamayı kolaylaştırmak için kasılmasından '
              'kaynaklanır — yani "bir şey ters gidiyor" anlamına gelmez, '
              'çok yaygındır.',
        ),
        ArticleSection(
          heading: 'Sıcak uygulama',
          icon: Icons.spa_rounded,
          text:
              'Karnına veya beline sıcak su torbası koymak, araştırmalarda '
              '**ağrı kesici hap kadar etkili** bulunmuş — ikisini birlikte '
              'kullanmak rahatlamayı daha da hızlandırabiliyor.',
        ),
        ArticleSection(
          heading: 'Hafif hareket',
          icon: Icons.self_improvement_rounded,
          text:
              'Yürüyüş, esneme ya da hafif germe hareketleri bazı kızlarda '
              'kramp şiddetini azaltabiliyor. Kendini zorlamana gerek yok, '
              'bedenin ne kadarını istiyorsa o kadarı yeterli.',
        ),
        ArticleSection(
          heading: 'Ağrı kesiciler',
          icon: Icons.medication_outlined,
          text:
              'İbuprofen gibi ilaçlar yaygın olarak kullanılıyor. Ama bu bir '
              'yetişkin kararı — hangi ilacı, ne zaman, ne kadar alman '
              'gerektiğini mutlaka bir ebeveynine veya eczacına sor.',
        ),
        ArticleSection(
          heading: 'Dinlenme ve sıcak içecekler',
          icon: Icons.local_cafe_rounded,
          text:
              'Bedenine izin ver. Sıcak bir çay, rahat bir pozisyon ve biraz '
              'dinlenme çoğu zaman yardımcı oluyor.',
        ),
        ArticleSection(
          heading: 'Ne zaman bir yetişkinle konuşmalısın',
          icon: Icons.chat_bubble_outline_rounded,
          text:
              'Kramplar okulunu ya da günlük hayatını gerçekten '
              'engelliyorsa, ya da ağrı kesicilere rağmen geçmiyorsa — bu '
              '"dayanman gereken" bir şey değil. Güvendiğin bir yetişkine '
              'söyle, bir doktora görünmek tamamen normal ve doğru bir adım.',
        ),
      ],
    ),
    Article(
      title: 'Hormonlar ve Ruh Halin',
      subtitle: 'Neden bazen çok mutlu, bazen çok üzgün oluyorsun?',
      readTime: '5 dk',
      level: 'Başlangıç',
      icon: Icons.psychology_outlined,
      category: 'Duygular',
      body: [
        ArticleSection(
          text:
              'Döngün boyunca östrojen ve progesteron adlı iki hormonun '
              'seviyesi sürekli değişiyor — ve bu değişim gerçekten ruh '
              'haline yansıyabilir. Yani "aşırı tepki veriyorsun" değil, '
              '**bedeninde gerçek bir biyolojik süreç yaşanıyor**.',
        ),
        ArticleSection(
          heading: 'Neden bazen enerjik hissediyorsun',
          icon: Icons.wb_sunny_rounded,
          text:
              'Östrojen yükseldiğinde, beyninde mutluluk hissiyle ilişkili '
              'bir kimyasal olan **serotonin** de genellikle artıyor — bu '
              'yüzden döngünün bazı dönemlerinde kendini daha enerjik ve '
              'iyi hissedebilirsin.',
        ),
        ArticleSection(
          heading: 'Neden bazen daha hassas hissediyorsun',
          icon: Icons.cloud_rounded,
          text:
              'Reglden önceki dönemde progesteron artıyor ve bu, serotonini '
              'azaltabiliyor — bazı kızlar bu günlerde kendini daha hassas '
              'ya da sinirli hissedebiliyor. Buradaki asıl mesele hormon '
              'miktarı değil, **o hormonun ne kadar hızlı yükselip '
              'alçaldığı**.',
        ),
        ArticleSection(
          text:
              'Ergenlik döneminde bu hormonlar zaten yeni yeni devreye '
              'giriyor, bu yüzden bazen duygularını olduğundan daha yoğun '
              'hissetmen normal — beynin de bu değişime alışıyor.',
        ),
        ArticleSection(
          text:
              'Bunu bilmek, kendine karşı biraz daha nazik olmana yardımcı '
              'olabilir: her mod değişimi hormonlarla açıklanmaz ama '
              'hormonların gerçek bir payı var — ve **bu senin suçun değil**.',
        ),
      ],
    ),
    Article(
      title: 'Döngüne Göre Beslenme',
      subtitle: 'Her fazda vücudunun ihtiyacı farklı',
      readTime: '4 dk',
      level: 'Orta',
      icon: Icons.restaurant_outlined,
      category: 'Beslenme',
      body: [
        ArticleSection(
          heading: 'Demir neden önemli',
          icon: Icons.bloodtype_rounded,
          text:
              'Regl sırasında kan kaybıyla birlikte demir de kaybedilir. '
              'Sen de büyüme çağında olduğun için demire normalden daha çok '
              'ihtiyacın var — **14-18 yaş kızlar için önerilen günlük '
              'miktar ~15mg**, henüz regl görmeyen çocuklara göre neredeyse '
              'iki kat fazla.',
        ),
        ArticleSection(
          heading: 'Hangi besinler yardımcı olur',
          icon: Icons.restaurant_menu_rounded,
          text:
              'Demirden zengin besinler (ıspanak, mercimek, kırmızı et gibi) '
              've yanında C vitamini içeren bir şey (portakal, biber gibi) '
              'yemek, vücudunun demiri daha kolay kullanmasını sağlıyor. '
              '**İkisini birlikte tüketmek daha etkili.**',
        ),
        ArticleSection(
          heading: 'Magnezyum hakkında dürüst olalım',
          icon: Icons.fact_check_outlined,
          text:
              'Magnezyum (badem, muz, avokado gibi besinlerde bulunur) bazı '
              'araştırmalarda regl öncesi şişkinlikte yardımcı bulunmuş. Ama '
              'ruh hali üzerindeki etkisiyle ilgili **kanıtlar henüz '
              'yeterince net değil** — "magnezyum modunu düzeltir" diyemeyiz.',
        ),
        ArticleSection(
          text:
              'Genel olarak aşırı bir diyete ihtiyacın yok. Dengeli '
              'beslenmek, döngünün her evresinde bedenini destekler.',
        ),
      ],
    ),
    Article(
      title: 'Uyku ve Döngü İlişkisi',
      subtitle: 'Neden bazı gecelerde uyuyamıyorsun?',
      readTime: '3 dk',
      level: 'Başlangıç',
      icon: Icons.nightlight_outlined,
      category: 'Sağlık',
      body: [
        ArticleSection(
          text:
              'Döngünün hangi gününde olursan ol, senin yaşındaki gençler '
              'için önerilen uyku süresi **günde 8-10 saat**.',
        ),
        ArticleSection(
          heading: 'Reglden önce neden zorlanabilirsin',
          icon: Icons.bedtime_rounded,
          text:
              'Bazı kızlar reglden hemen önceki günlerde uykuya dalmakta '
              'biraz daha zorlanabiliyor. Olası bir sebep: yükselen '
              'progesteron **vücut sıcaklığını hafifçe artırıyor**. '
              'Vücudun derin uykuya geçebilmesi için geceleri biraz '
              'soğuması gerekiyor — bu küçük sıcaklık artışı da uykuya '
              'dalmayı biraz zorlaştırabiliyor.',
        ),
        ArticleSection(
          text:
              'Bu, herkeste ya da her ay aynı şekilde yaşanmıyor — sadece '
              '"bazı geceler neden daha zor" sorusuna bir açıklama. '
              'Endişelenmene gerek yok.',
        ),
        ArticleSection(
          heading: 'Yardımcı olabilecek küçük şeyler',
          icon: Icons.tips_and_updates_rounded,
          text:
              'Düzenli bir uyku saatine sadık kalmak, odanı serin tutmak ve '
              'yatmadan önce ekrandan biraz uzak durmak.',
        ),
      ],
    ),
    Article(
      title: 'Hareket ve Döngü',
      subtitle: 'Hangi fazda hangi egzersiz ideal?',
      readTime: '5 dk',
      level: 'Orta',
      icon: Icons.self_improvement_outlined,
      category: 'Egzersiz',
      body: [
        ArticleSection(
          text:
              'İnternette "döngü fazına göre spor yap" diye bir trend '
              'görmüş olabilirsin. Dürüst olalım: bu trend sosyal medyada '
              'çok popüler, ama bilim bunu henüz doğrulamıyor.',
        ),
        ArticleSection(
          heading: 'Bilim ne diyor',
          icon: Icons.science_outlined,
          text:
              'Bilim insanları bunu gerçekten test etti — 2023\'te bir '
              'üniversite bile bu konuyu araştırdı. Sonuç: **döngü fazı ne '
              'spor gücünü ne de bedeninin antrenmana verdiği tepkiyi '
              'değiştiriyormuş.** Yani "bu fazda güçlü değilsin" gibi kesin '
              'iddialar doğru değil.',
        ),
        ArticleSection(
          heading: 'Peki gerçekten işe yarayan ne',
          icon: Icons.check_circle_outline_rounded,
          text:
              'Regl günlerinde hafif hareket — yürüyüş, esneme, yoga gibi — '
              'kramp şiddetini azaltmaya yardımcı olabiliyor.',
        ),
        ArticleSection(
          text:
              'Sonuç: "doğru gün" diye bir baskı yapmana gerek yok. Bedenin '
              'o gün nasıl hissediyorsa öyle hareket et — bazı günler '
              'enerjik, bazı günler yavaş olman tamamen normal.',
        ),
      ],
    ),
    Article(
      title: 'PMS Nedir?',
      subtitle: 'Regl öncesi sendrom hakkında bilmen gerekenler',
      readTime: '4 dk',
      level: 'Başlangıç',
      icon: Icons.info_outline_rounded,
      category: 'Döngü',
      body: [
        ArticleSection(
          text:
              '**PMS (regl öncesi sendrom)**, reglden önceki günlerde bazı '
              'kızların yaşadığı fiziksel ve duygusal değişikliklerin genel '
              'adı.',
        ),
        ArticleSection(
          heading: 'Yaygın belirtiler',
          icon: Icons.checklist_rounded,
          text:
              'Ani mod değişimleri, sinirlilik, kaygı, konsantrasyon '
              'güçlüğü, iştah değişiklikleri, uyku sorunları ve şişkinlik '
              'hissi.',
        ),
        ArticleSection(
          text:
              'Bu belirtiler çok yaygın ve normal. Bu yaşlarda bedenin '
              'henüz kendi ritmini öğrendiği için, PMS\'i ergenliğin doğal '
              'duygusal iniş çıkışlarından ayırt etmek bazen zor olabilir.',
        ),
        ArticleSection(
          heading: 'Ne zaman bir yetişkinle konuşmalısın',
          icon: Icons.chat_bubble_outline_rounded,
          text:
              'Bu belirtiler **günlük hayatını ciddi şekilde etkiliyorsa** '
              '— bu "sadece katlanman gereken" bir şey değil. Güvendiğin '
              'bir yetişkine ya da doktora anlatmak, ne yaşadığını '
              'anlamlandırmana yardımcı olabilir.',
        ),
        ArticleSection(
          text:
              'Döngünü kaydetmek (tam da Ritim\'de yaptığın gibi) hangi '
              'günlerde nasıl hissettiğini fark etmene yardımcı olur.',
        ),
      ],
    ),
    Article(
      title: 'Okul Çantanda Ne Olmalı?',
      subtitle: 'Hazırlıklı olmak seni rahatlatır',
      readTime: '3 dk',
      level: 'Başlangıç',
      icon: Icons.backpack_outlined,
      category: 'Sağlık',
      isChecklist: true,
      body: [
        ArticleSection(
          text:
              'Reglin ne zaman başlayacağını bazen tam olarak bilemezsin, '
              'özellikle döngün henüz düzene oturmadıysa. Çantanda birkaç '
              'küçük şey bulundurmak, "ya okulda başlarsa" endişesini büyük '
              'ölçüde azaltır.',
        ),
        ArticleSection(
          heading: 'Yedek ped',
          icon: Icons.inventory_2_outlined,
          text:
              'Regl olmasan bile çantanda her zaman bir tane bulunsun. '
              'İhtiyacın olmasa bile, bir arkadaşının ihtiyacı olabilir — '
              '**birbirinize göz kulak olmak güzel bir şey**.',
        ),
        ArticleSection(
          heading: 'Yedek iç çamaşırı',
          icon: Icons.checkroom_rounded,
          text:
              'Katlanmış bir tane çantanda dursun. Kullanmasan da orada '
              'olması içini rahatlatır.',
        ),
        ArticleSection(
          heading: 'Islak mendil',
          icon: Icons.clean_hands_rounded,
          text:
              'Tuvalette su olmayabilir ya da yetmeyebilir. Küçük bir paket '
              'ıslak mendil işini görür.',
        ),
        ArticleSection(
          text:
              'Bunları bir kere hazırlayıp çantanda unutabilirsin — her '
              'seferinde yeniden düşünmene gerek kalmaz. Hazırlıklı olmak, '
              'endişelenmekten çok daha iyi bir seçim.',
        ),
      ],
    ),
    Article(
      title: 'Okulda Kazara Olursa Ne Yaparım?',
      subtitle: 'Herkesin başına gelebilir, panik yapma',
      readTime: '3 dk',
      level: 'Başlangıç',
      icon: Icons.favorite_border_rounded,
      category: 'Sağlık',
      body: [
        ArticleSection(
          text:
              'Regl lekesi okulda fark edilirse dünyanın sonu değil — bu, '
              'regl gören hemen hemen her kızın başına en az bir kez gelen '
              'bir şey. **Kimse bunu senin sandığın kadar fark etmez ya da '
              'takmaz.**',
        ),
        ArticleSection(
          heading: 'Önce kendine sakin ol',
          icon: Icons.air_rounded,
          text:
              'Derin bir nefes al. Bu an geçecek ve birkaç dakika içinde '
              'çözülebilecek bir şey — panik yapmana gerek yok.',
        ),
        ArticleSection(
          heading: 'Ne yapmalısın',
          icon: Icons.checklist_rounded,
          text:
              'Tuvalete git. Çantanda yedek ped ve iç çamaşırı varsa '
              'değiştir.',
        ),
        ArticleSection(
          heading: 'Yedek yoksa kimden yardım isteyebilirsin',
          icon: Icons.support_agent_rounded,
          text:
              'Okul hemşiresi tam da bunun için orada — çekinmeden gidebilirsin. '
              'Güvendiğin bir öğretmen ya da yakın bir arkadaşından da ped '
              'isteyebilirsin. Bunu istemek utanılacak bir şey değil, '
              'gayet normal bir yardımlaşma.',
        ),
        ArticleSection(
          heading: 'Unutma',
          icon: Icons.favorite_rounded,
          text:
              '**Bu senin suçun değil** ve bedeninin doğal bir işlevi. '
              'Yaşandığında hissettiğin utanç, olayın kendisinden çok '
              'daha büyük hissettirir — ama gerçekte kimse bunu senin kadar '
              'önemsemiyor.',
        ),
      ],
    ),
  ];

  static List<Article> get all => [featured, ...articles];
}
