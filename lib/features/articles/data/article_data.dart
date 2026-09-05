import 'package:flutter/material.dart';

/// Bir makale gövdesinin tek bir bölümü. `heading` doluysa (ör. adım
/// listelerinde) bu bölüm ayrı bir başlık altında gösterilir; boşsa düz bir
/// paragraf olarak akar.
class ArticleSection {
  const ArticleSection({this.heading, required this.text});
  final String? heading;
  final String text;
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
  });

  final String title;
  final String subtitle;
  final String readTime;
  final String level;
  final IconData icon;
  final String category;
  final List<ArticleSection> body;
}

class ArticleData {
  ArticleData._();

  static const featured = Article(
    title: 'Döngünü Tanımak:\nBaşlangıç Rehberi',
    subtitle:
        'Vücudunda her ay neler oluyor? İlk adetten döngü fazlarına, bilmen gereken her şey.',
    readTime: '6 dk',
    level: 'Başlangıç',
    icon: Icons.menu_book_rounded,
    category: 'Döngü',
    body: [
      ArticleSection(
        text:
            'Adet döngüsü sadece kanama günlerinden ibaret değil. Bedenin '
            'aslında ay boyunca sessizce çalışıyor — adet günü bunun sadece '
            'gözle görülen kısmı.',
      ),
      ArticleSection(
        heading: 'Döngü süresi kişiden kişiye değişir',
        text:
            'Bu yaşlarda döngün henüz kendi ritmini arıyor. Yetişkinlerde '
            'döngü genelde 21-35 gün sürer, ama senin yaşında (10-17) bu '
            '21-45 güne kadar çıkabilir — bu tamamen normal. Bedenin ilk '
            'adetten sonraki birkaç yıl içinde kendi düzenini buluyor. Bu ay '
            'ile geçen ay farklı sürse bile kaygılanmana gerek yok.',
      ),
      ArticleSection(
        heading: 'Döngünün 4 evresi',
        text:
            'Adet (kanamanın olduğu günler) → Toparlanma Dönemi (adet bitip '
            'bedenin yeniden enerji topladığı dönem) → Zirve Dönemi (kısa bir '
            'yumurtlama penceresi) → Sakinleşme Dönemi (bir sonraki adete '
            'kadar olan dönem). Ritim\'in sana her gün farklı bir faz '
            'göstermesinin sebebi bu.',
      ),
      ArticleSection(
        heading: 'Neden kaydediyoruz?',
        text:
            'Döngünü kaydetmek "doğru cevap" bulmak için değil — kendi '
            'örüntünü tanımak için. Hangi günlerde nasıl hissettiğini fark '
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
      title: 'Adet Sancısıyla Başa Çıkmanın 5 Yolu',
      subtitle: 'Kramplar seni yıldırmasın',
      readTime: '4 dk',
      level: 'Başlangıç',
      icon: Icons.favorite_outline_rounded,
      category: 'Sağlık',
      body: [
        ArticleSection(
          text:
              'Adet krampı, genç kızlarda en sık yaşanan adet belirtisi '
              '(doktorlar buna "dismenore" der). Kramplar rahim kaslarının '
              'kanamayı kolaylaştırmak için kasılmasından kaynaklanır — yani '
              '"bir şey ters gidiyor" anlamına gelmez, çok yaygındır.',
        ),
        ArticleSection(
          heading: 'Sıcak uygulama',
          text:
              'Karnına veya beline sıcak su torbası koymak, araştırmalarda '
              'ağrı kesici hap kadar etkili bulunmuş — ikisini birlikte '
              'kullanmak rahatlamayı daha da hızlandırabiliyor.',
        ),
        ArticleSection(
          heading: 'Hafif hareket',
          text:
              'Yürüyüş, esneme ya da hafif germe hareketleri bazı kızlarda '
              'kramp şiddetini azaltabiliyor. Kendini zorlamana gerek yok, '
              'bedenin ne kadarını istiyorsa o kadarı yeterli.',
        ),
        ArticleSection(
          heading: 'Ağrı kesiciler',
          text:
              'İbuprofen gibi ilaçlar yaygın olarak kullanılıyor. Ama bu bir '
              'yetişkin kararı — hangi ilacı, ne zaman, ne kadar alman '
              'gerektiğini mutlaka bir ebeveynine veya eczacına sor.',
        ),
        ArticleSection(
          heading: 'Dinlenme ve sıcak içecekler',
          text:
              'Bedenine izin ver. Sıcak bir çay, rahat bir pozisyon ve biraz '
              'dinlenme çoğu zaman yardımcı oluyor.',
        ),
        ArticleSection(
          heading: 'Ne zaman bir yetişkinle konuşmalısın',
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
              'bedeninde gerçek bir biyolojik süreç yaşanıyor.',
        ),
        ArticleSection(
          heading: 'Neden bazen enerjik hissediyorsun',
          text:
              'Östrojen yükseldiğinde, beyninde mutluluk hissiyle ilişkili '
              'bir kimyasal olan serotonin de artma eğiliminde — bu yüzden '
              'döngünün bazı dönemlerinde kendini daha enerjik ve iyi '
              'hissedebilirsin.',
        ),
        ArticleSection(
          heading: 'Neden bazen daha hassas hissediyorsun',
          text:
              'Adetten önceki dönemde progesteron artıyor ve bu, serotonini '
              'azaltabiliyor — bazı kızlar bu günlerde kendini daha hassas '
              'ya da sinirli hissedebiliyor. Asıl belirleyici olan, '
              'hormonun ne kadar olduğu değil, ne kadar hızlı değiştiği.',
        ),
        ArticleSection(
          text:
              'Ergenlik döneminde bu hormonlar zaten yeni yeni devreye '
              'giriyor, bu yüzden duyguların bazen olduğundan daha yoğun '
              'hissedilmesi normal — beynin de bu değişimlere alışıyor.',
        ),
        ArticleSection(
          text:
              'Bunu bilmek, kendine karşı biraz daha nazik olmana yardımcı '
              'olabilir: her mod değişimi hormonlarla açıklanmaz ama '
              'hormonların gerçek bir payı var — ve bu senin suçun değil.',
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
          text:
              'Adet sırasında kan kaybıyla birlikte demir de kaybedilir — ve '
              'zaten büyüme çağında olduğun için bedeninin demire ihtiyacı '
              'yetişkinlere göre daha fazla (14-18 yaş için günde ~15mg).',
        ),
        ArticleSection(
          heading: 'Hangi besinler yardımcı olur',
          text:
              'Demirden zengin besinler (ıspanak, mercimek, kırmızı et gibi) '
              've yanında C vitamini içeren bir şey (portakal, biber gibi) '
              'yemek, demirin emilimini artırıyor — ikisini birlikte '
              'tüketmek daha etkili.',
        ),
        ArticleSection(
          heading: 'Magnezyum hakkında dürüst olalım',
          text:
              'Magnezyum (badem, muz, avokado gibi besinlerde bulunur) bazı '
              'araştırmalarda adet öncesi şişkinlikte yardımcı bulunmuş. Ama '
              'ruh hali üzerindeki etkisiyle ilgili kanıtlar henüz yeterince '
              'net değil — "magnezyum modunu düzeltir" diyemeyiz.',
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
              'Senin yaşındaki gençler için önerilen uyku süresi, döngünün '
              'hangi evresinde olduğundan bağımsız olarak günde 8-10 saat.',
        ),
        ArticleSection(
          heading: 'Adetten önce neden zorlanabilirsin',
          text:
              'Bazı kızlar adetten hemen önceki günlerde uykuya dalmakta '
              'biraz daha zorlanabiliyor. Olası bir sebep: yükselen '
              'progesteron vücut sıcaklığını hafifçe artırıyor. Beden derin '
              'uykuya geçmek için geceleri doğal olarak soğuması '
              'gerektiğinden, bu küçük artış uykuya dalmayı '
              'zorlaştırabiliyor.',
        ),
        ArticleSection(
          text:
              'Bu, herkeste ya da her ay aynı şekilde yaşanmıyor — sadece '
              '"bazı geceler neden daha zor" sorusuna bir açıklama. '
              'Endişelenmene gerek yok.',
        ),
        ArticleSection(
          heading: 'Yardımcı olabilecek küçük şeyler',
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
          text:
              'Bilim insanları bunu gerçekten test etti (2023\'te yapılan '
              'bir üniversite çalışması dahil) ve döngü fazının spor '
              'gücünü ya da bedeninin antrenmana ne kadar iyi uyum '
              'sağladığını değiştirdiğine dair bir kanıt bulamadılar. Yani '
              '"bu fazda güçlü değilsin" gibi kesin iddialar doğru değil.',
        ),
        ArticleSection(
          heading: 'Peki gerçekten işe yarayan ne',
          text:
              'Adet günlerinde hafif hareket — yürüyüş, esneme, yoga gibi — '
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
      subtitle: 'Adet öncesi sendrom hakkında bilmen gerekenler',
      readTime: '4 dk',
      level: 'Başlangıç',
      icon: Icons.info_outline_rounded,
      category: 'Döngü',
      body: [
        ArticleSection(
          text:
              'PMS (adet öncesi sendrom), adetten önceki günlerde bazı '
              'kızların yaşadığı fiziksel ve duygusal değişikliklerin genel '
              'adı.',
        ),
        ArticleSection(
          heading: 'Yaygın belirtiler',
          text:
              'Ani mod değişimleri, sinirlilik, kaygı, konsantrasyon '
              'güçlüğü, iştah değişiklikleri, uyku sorunları ve şişkinlik '
              'hissi.',
        ),
        ArticleSection(
          text:
              'Bu belirtiler çok yaygın ve normal — özellikle bedenin henüz '
              'kendi ritmini öğrendiği bu yaşlarda, ergenliğin doğal '
              'duygusal iniş çıkışlarından ayırt etmek bazen zor olabilir.',
        ),
        ArticleSection(
          heading: 'Ne zaman bir yetişkinle konuşmalısın',
          text:
              'Bu belirtiler okulunu, arkadaşlıklarını ya da günlük '
              'hayatını ciddi şekilde etkiliyorsa — bu "sadece katlanman '
              'gereken" bir şey değil. Güvendiğin bir yetişkine ya da '
              'doktora anlatmak, ne yaşadığını anlamlandırmana yardımcı '
              'olabilir.',
        ),
        ArticleSection(
          text:
              'Döngünü kaydetmek (tam da Ritim\'de yaptığın gibi) hangi '
              'günlerde nasıl hissettiğini fark etmene yardımcı olur.',
        ),
      ],
    ),
  ];

  static List<Article> get all => [featured, ...articles];
}
