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
    // ─── Temel Bilgiler ────────────────────────────────────────────────
    QuizQuestion(
      question: 'Regl (menstrüasyon) olmak ne anlama gelir?',
      options: [
        'Vücudun hasta olduğunu gösterir',
        'Büyüdüğümüzün ve vücudumuzun sağlıklı çalıştığının doğal bir işaretidir',
        'Sadece çok yaşlı insanların yaşadığı bir durumdur',
      ],
      correctIndex: 1,
      explanation:
          'Regl olmak, vücudunun büyüdüğünü ve sağlıklı çalıştığını '
          'gösteren doğal bir işaret — hastalık değil!',
    ),
    QuizQuestion(
      question: 'İlk regl genellikle hangi yaşlar arasında başlar?',
      options: ['4-6 yaş', '9-16 yaş', '30-40 yaş'],
      correctIndex: 1,
      explanation:
          'Herkesin vücut saati farklıdır, bu yaş aralığı tamamen normaldir!',
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

    // ─── Hijyen ve Özbakım ─────────────────────────────────────────────
    QuizQuestion(
      question: 'Kullanılmış bir pedi değiştirdikten sonra ne yapmalıyız?',
      options: [
        'Tuvalete atıp sifonu çekmeliyiz',
        'Temiz bir kağıda veya ped poşetine sarıp çöp kutusuna atmalıyız',
        'Odamızda masanın üstünde bırakmalıyız',
      ],
      correctIndex: 1,
      explanation:
          'Tuvalete atmak tıkanıklığa yol açar, çöpe atmak en doğrusudur!',
    ),
    QuizQuestion(
      question:
          'Sağlığımız ve temizliğimiz için gün içinde hijyenik pedi '
          'ortalama ne sıklıkla değiştirmeliyiz?',
      options: [
        '3-4 günde bir',
        'Kanama yoğunluğuna göre 4-6 saatte bir',
        'Sadece geceleri uyumadan önce',
      ],
      correctIndex: 1,
      explanation:
          'Pedi düzenli değiştirmek hem hijyen hem rahatlık için önemli.',
    ),
    QuizQuestion(
      question: 'Regl döneminde banyo yapmak veya duş almak zararlı mıdır?',
      options: [
        'Hayır, aksine ılık bir duş almak bizi temiz tutar ve rahatlatır',
        'Evet, reglken suya dokunulmamalıdır',
      ],
      correctIndex: 0,
      explanation:
          'Bu sadece bir efsane — duş almak seni temiz tutar ve '
          'rahatlatır, hiç zararı yok.',
    ),

    // ─── Semptomlar ve Rahatlama Yöntemleri ────────────────────────────
    QuizQuestion(
      question:
          'Regl olmadan birkaç gün önce kendimizi biraz halsiz, sinirli '
          'veya duygusal hissetmemiz normal midir?',
      options: [
        'Hayır, bu bir hastalıktır',
        'Evet, hormonlarımızın değişmesinden kaynaklanan çok normal bir '
            'durumdur (Buna PMS denir)',
      ],
      correctIndex: 1,
      explanation:
          'Buna PMS denir ve çok yaygındır — hormonlarının değişmesinden '
          'kaynaklanır, hastalık değildir.',
    ),
    QuizQuestion(
      question:
          'Hafif regl sancısı (karın ağrısı) yaşadığımızda aşağıdakilerden '
          'hangisi bizi rahatlatabilir?',
      options: [
        'Çok hızlı koşmak',
        'Karnımıza ılık (aşırı sıcak olmayan) bir su torbası koymak ve dinlenmek',
        'Saatlerce ağlamak',
      ],
      correctIndex: 1,
      explanation:
          'Ilık bir su torbası ve dinlenmek, kramp ağrısını hafifletmeye '
          'yardımcı olabilir.',
    ),

    // ─── Mitler ve Gerçekler ────────────────────────────────────────────
    QuizQuestion(
      question:
          '"Regl olan bir çocuk spor yapamaz veya beden eğitimi dersine '
          'katılamaz." Bu bilgi doğru mu, yanlış mı?',
      options: [
        'Doğru, ağır hareketler yapılmamalıdır',
        'Yanlış, kendimizi iyi hissettiğimiz sürece yürüyüş, esneme ve '
            'spor yapmak ağrıları azaltmaya bile yardımcı olur',
      ],
      correctIndex: 1,
      explanation:
          'Bu bir mit! Kendini iyi hissediyorsan spor yapmak seni '
          'durdurmamalı — hatta hareket etmek ağrıları azaltabilir.',
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
