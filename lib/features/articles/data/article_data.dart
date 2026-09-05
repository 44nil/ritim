import 'package:flutter/material.dart';

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
  final List<String> body;
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
      'Adet döngüsü sadece kanama günlerinden ibaret değil — aslında bedeninin '
          'ay boyunca sessizce çalıştığı, dört evreden oluşan bir döngü. Adet '
          'günü sadece bu döngünün gözle görülen kısmı.',
      'Bu yaşlarda döngün henüz "kendi ritmini" arıyor. Yetişkin bir kadında '
          'döngü genelde 21-35 gün sürerken, adölesan dönemde (10-17 yaş) bu '
          'aralık 21-45 güne kadar çıkabilir — ve bu tamamen normal. Vücudun '
          'ilk adetten sonraki birkaç yıl içinde kademeli olarak kendi düzenini '
          'buluyor, yani bu ay ile geçen ay farklı sürse bile kaygılanmana '
          'gerek yok.',
      'Döngü kabaca dört evreye ayrılır: Adet (kanamanın olduğu günler), '
          'Foliküler (adetin bitip yeni bir yumurtanın olgunlaştığı dönem), '
          'Ovülasyon (yumurtlamanın gerçekleştiği kısa pencere) ve Luteal '
          '(ovülasyondan sonraki, bir sonraki adete kadar olan dönem). Ritim\'in '
          'sana her gün farklı bir faz göstermesinin sebebi bu.',
      'Döngünü kaydetmek bir "doğru cevap" bulmak için değil — kendi '
          'örüntünü tanımak için. Hangi günlerde nasıl hissettiğini fark etmek, '
          'zamanla bedenini daha iyi anlamana yardımcı olur.',
      'Burada yargılanmadan, kendi hızında öğrenebilirsin. Her bedenin '
          'hikâyesi biraz farklı — ve bu tamamen senin hikâyen.',
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
        'Adet krampları (dismenore), genç kızlar arasında en sık yaşanan adet '
            'belirtisi. Yaşadığın kramplar rahim kaslarının kanamayı '
            'kolaylaştırmak için kasılmasından kaynaklanıyor — yani "bir şey ters '
            'gidiyor" anlamına gelmiyor, çok yaygın bir durum.',
        '1. Sıcak uygulama: Karnına veya beline sıcak su torbası/ısı yastığı '
            'koymak, araştırmalarda ağrı kesici hap kadar etkili bulunmuş — '
            'ikisini birlikte kullanmak rahatlamayı daha da hızlandırabiliyor.',
        '2. Hafif hareket: Yürüyüş, esneme ya da hafif germe hareketleri '
            'bazı kızlarda kramp şiddetini azaltabiliyor. Kendini zorlamana '
            'gerek yok, bedenin ne kadarını istiyorsa o kadarı yeterli.',
        '3. Ağrı kesiciler: İbuprofen gibi ilaçlar dismenorede yaygın olarak '
            'kullanılıyor ve doktorlar genelde adet başlamadan 1-2 gün önce '
            'başlanıp ilk birkaç gün sürdürülmesini öneriyor. Ama bu bir yetişkin '
            'kararı — hangi ilacı, ne zaman, ne kadar alman gerektiğini mutlaka '
            'bir ebeveynine veya eczacına sor.',
        '4. Dinlenme ve sıcak içecekler: Bedenine izin ver. Sıcak bir çay, '
            'rahat bir pozisyon ve biraz dinlenme çoğu zaman yardımcı oluyor.',
        '5. Ne zaman bir yetişkinle konuşmalısın: Kramplar okulu, uykunu ya '
            'da günlük hayatını gerçekten engelliyorsa, ya da ağrı kesicilere '
            'rağmen geçmiyorsa — bu "dayanman gereken" bir şey değil. Güvendiğin '
            'bir yetişkine söyle, bir doktora görünmek tamamen normal ve doğru '
            'bir adım.',
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
        'Döngün boyunca östrojen ve progesteron adlı iki hormonun seviyesi '
            'sürekli değişiyor — ve bu değişim gerçekten ruh haline yansıyabilir. '
            'Yani "aşırı tepki veriyorsun" değil, bedeninde gerçek bir biyolojik '
            'süreç yaşanıyor.',
        'Östrojen yükseldiğinde, beyninde mutluluk hissiyle ilişkili bir '
            'kimyasal olan serotonin de artma eğiliminde — bu yüzden döngünün '
            'bazı dönemlerinde kendini daha enerjik ve iyi hissedebilirsin.',
        'Adetten önceki (luteal) dönemde ise progesteron artıyor ve bu, '
            'serotonini azaltıcı yönde etkileyebiliyor — bazı kızlar bu '
            'günlerde kendini daha hassas, sinirli ya da düşük enerjili '
            'hissedebiliyor. Araştırmalar aslında hormonların "seviyesinden" '
            'çok, ne kadar hızlı değiştiğinin ruh hali üzerinde daha belirleyici '
            'olabileceğini gösteriyor.',
        'Ergenlik döneminde bu hormonlar zaten yeni yeni devreye giriyor, bu '
            'yüzden duyguların bazen olduğundan daha yoğun hissedilmesi normal '
            '— beynin de bu değişimlere alışıyor.',
        'Bunu bilmek, kendine karşı biraz daha nazik olmana yardımcı olabilir: '
            'her mod değişimi hormonlarla açıklanmaz ama hormonların gerçek bir '
            'payı var — ve bu senin suçun değil.',
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
        'Adet sırasında kan kaybıyla birlikte demir de kaybedilir — ve zaten '
            'büyüme çağında olduğun için bedeninin demire ihtiyacı yetişkinlere '
            'göre daha fazla. 14-18 yaş için önerilen günlük demir miktarı '
            'yaklaşık 15mg.',
        'Demirden zengin besinler (ıspanak, mercimek, kırmızı et gibi) ve '
            'yanında C vitamini içeren bir şey (portakal, biber gibi) yemek, '
            'demirin emilimini artırıyor — yani ikisini birlikte tüketmek daha '
            'etkili.',
        'Magnezyum (badem, muz, avokado gibi besinlerde bulunur) bazı '
            'araştırmalarda adet öncesi şişkinlik gibi fiziksel belirtilerde '
            'yardımcı bulunmuş. Ama dürüst olmak gerekirse, ruh hali üzerindeki '
            'etkisiyle ilgili kanıtlar henüz yeterince net değil — bu yüzden '
            '"magnezyum modunu düzeltir" gibi kesin bir söz veremeyiz.',
        'Genel olarak aşırı bir diyete ihtiyacın yok. Dengeli beslenmek, '
            'döngünün her evresinde bedenini destekler.',
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
        'Senin yaşındaki gençler için önerilen uyku süresi, döngünün hangi '
            'evresinde olduğundan bağımsız olarak günde 8-10 saat.',
        'Ama bazı kızlar adetten hemen önceki günlerde uykuya dalmakta biraz '
            'daha zorlanabiliyor. Bunun olası bir sebebi: ovülasyondan sonra '
            'yükselen progesteron, vücut sıcaklığını hafifçe artırıyor. Bedenin '
            'derin uykuya geçmek için geceleri doğal olarak soğuması '
            'gerektiğinden, bu küçük sıcaklık artışı uykuya dalmayı '
            'zorlaştırabiliyor ya da gece uyanmalarına yol açabiliyor.',
        'Bu, herkeste ya da her ay aynı şekilde yaşanmıyor — sadece "bazı '
            'geceler neden daha zor" sorusuna bir açıklama. Endişelenmene '
            'gerek yok.',
        'Yardımcı olabilecek küçük şeyler: düzenli bir uyku saatine sadık '
            'kalmak, odanı serin tutmak ve yatmadan önce ekrandan biraz uzak '
            'durmak.',
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
        'İnternette "döngü fazına göre spor yap" diye bir trend görmüş '
            'olabilirsin — foliküler fazda ağır antrenman, luteal fazda hafif '
            'egzersiz gibi. Dürüst olalım: bu trend sosyal medyada çok popüler '
            'ama bilimsel bir konsensüs değil.',
        'Kontrollü araştırmalar (2023\'te yapılan bir üniversite çalışması '
            'dahil), döngü fazının kas gücü performansını ya da antrenmana '
            'vücudun uyum sağlama hızını ölçülebilir şekilde etkilemediğini '
            'gösterdi. Yani "bu fazda güçlü değilsin" gibi kesin iddialar '
            'bilimle desteklenmiyor.',
        'Ama gerçekten desteklenen bir şey var: adet günlerinde hafif hareket '
            '— yürüyüş, esneme, yoga gibi — kramp şiddetini azaltmaya yardımcı '
            'olabiliyor.',
        'Sonuç olarak: "doğru gün" diye bir baskı yapmana gerek yok. Bedenin '
            'o gün nasıl hissediyorsa öyle hareket et — bazı günler enerjik, '
            'bazı günler yavaş olman tamamen normal, bunun "bilimsel bir '
            'kuralı" yok.',
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
        'PMS (adet öncesi sendrom), adetten önceki günlerde bazı kızların '
            'yaşadığı fiziksel ve duygusal değişikliklerin genel adı.',
        'Yaygın belirtiler arasında ani mod değişimleri, sinirlilik, '
            'kaygı, konsantrasyon güçlüğü, iştah değişiklikleri, uyku sorunları '
            've şişkinlik hissi sayılabilir.',
        'Bu belirtiler çok yaygın ve normal — özellikle bedenin henüz kendi '
            'ritmini öğrendiği bu yaşlarda, ergenlik döneminin doğal duygusal '
            'iniş çıkışlarından ayırt etmek bazen zor olabilir.',
        'Eğer bu belirtiler okulunu, arkadaşlıklarını ya da günlük hayatını '
            'ciddi şekilde etkiliyorsa — bu "sadece katlanman gereken" bir şey '
            'değil. Güvendiğin bir yetişkine ya da doktora anlatmak, ne '
            'yaşadığını anlamlandırmana yardımcı olabilir.',
        'Döngünü kaydetmek (tam da Ritim\'de yaptığın gibi) hangi günlerde '
            'nasıl hissettiğini fark etmene yardımcı olur — bu, hem kendini '
            'anlaman hem de gerekirse bir yetişkinle konuşurken örüntünü '
            'göstermen için değerli bir bilgi.',
      ],
    ),
  ];

  static List<Article> get all => [featured, ...articles];
}
