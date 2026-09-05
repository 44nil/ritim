# Ritim — İçerik Kaynak Doğrulaması

> Bu belge bir tıbbi görüş değildir. Uygulamadaki her sağlık/döngü iddiasının
> hangi kaynağa dayandığını (veya henüz dayanmadığını) izlemek için tutulur.
> Yayından önce bu listenin gerçek bir doktor/uzman tarafından son kez
> onaylanması gerekir — bkz. docs/legal-compliance-notes.md bölüm 7.
> Son güncelleme: 2026-09-04.

## Nasıl kaynak seçtik

Her iddia için üç şart aranıyor: (1) **hedef kitleye özel** — adölesan/genç
kız verisi, yetişkin verisi değil; (2) **klinik bir kurum tarafından
onaylanmış** — kişisel blog/sosyal medya değil; (3) **başka güvenilir
kaynaklar da ona atıf yapıyor** (UpToDate, Mayo Clinic gibi referans
kaynaklarda tekrar ediyor). Üçünü de sağlamayan bir iddia "doğrulanmadı"
olarak işaretlenir ve yayına kadar düzeltilir/kaldırılır ya da gerçek bir
doktora sorulur.

## Doğrulanmış iddialar

| İddia | Nerede | Kaynak |
|---|---|---|
| Adölesanda (10-17 yaş) normal döngü uzunluğu 21-45 gündür; yetişkinlerde bu 21-35 güne daralır; ilk adetten sonraki ~3 yıl içinde döngü kademeli olarak yetişkin aralığına yaklaşır. | `lib/features/quiz/screens/quiz_screen.dart` (günün sorusu) | [ACOG & AAP Committee Opinion No. 651 — "Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign" (2015)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign) |
| Adölesanların ~%80'i ilk adetten sonraki 2-4 yıl boyunca düzensiz döngü yaşar; bu hipotalamus-hipofiz-over aksının olgunlaşmamış olmasından kaynaklanır ve normaldir. | Genel yaklaşım/ton (kaygı azaltma) için referans, henüz belirli bir ekranda alıntılanmıyor | Türkiye Klinikleri, "Adölesanlarda Menstrüasyon Bozuklukları" — [turkiyeklinikleri.com](https://www.turkiyeklinikleri.com/article/tr-adolesanlarda-menstruasyon-bozukluklari-97963.html); ACOG Committee Opinion No. 651 (yukarıdaki) |
| 13-18 yaş için önerilen uyku süresi, döngü fazından bağımsız olarak 8-10 saattir. | `mock_wellness_data.dart` — tüm fazlarda `sleepHours` artık tek tip "8-10 saat" (önceden adet/luteal fazında 9-10, foliküler/ovülasyonda 8-9 olarak faza göre farklılaştırılmıştı — bu ayrımın hiçbir resmi kaynağı yoktu, düzeltildi). | [American Academy of Sleep Medicine, Teen Sleep Duration Health Advisory](https://aasm.org/advocacy/position-statements/teen-sleep-duration-health-advisory/) (AAP tarafından da destekleniyor) |
| Adet döneminde demir kaybı olur; büyüme çağındaki genç kızlar zaten demir eksikliği riski taşır — demir açısından zengin gıdalar (ıspanak, mercimek, kırmızı et) ve C vitamini (emilimi artırır) önerilir. 14-18 yaş için günlük 15mg demir hedefleniyor. | `mock_wellness_data.dart` — adet fazı `nutrition` listesi | [Academy of Nutrition and Dietetics — "Give Your Teen's Iron a Boost"](https://www.eatright.org/health/essential-nutrients/minerals/give-your-teens-iron-a-boost); ayrıca bkz. ağır adet kanamasıyla demir eksikliği ilişkisini gösteren gözden geçirilmiş çalışmalar (PMC) |
| Magnezyum (günde ~200mg, B6 ile birlikte alındığında daha etkili) adet öncesi şişkinlik/sıvı tutulumu gibi fiziksel semptomlarda yardımcı olabilir — ama psikolojik semptomlar (sinirlilik, mod değişimi) üzerindeki etkisi için kanıt yetersiz/karışık, kesin bir iddia değil. | `mock_wellness_data.dart` — luteal faz `nutrition` listesi (muz, avokado, fındık gibi magnezyum kaynakları) | Sistematik derleme/meta-analiz özetleri: magnezyum + B6 kombinasyonu anksiyete-ilişkili PMS semptomlarını azaltıyor, tek başına magnezyumun psikolojik semptomlara etkisi kanıtla desteklenmiyor — bkz. [PubMed sistematik derleme](https://pubmed.ncbi.nlm.nih.gov/30880352/) |

## Çözüldü: "cycle syncing" çerçevesi yumuşatıldı (2026-09-04)

`mock_cycle_data.dart`'taki faz `tip`/`bodyInfo` metinleri ve
`mock_wellness_data.dart`'taki `exercises` listeleri, popüler "cycle
syncing" trendini yansıtıyor: "foliküler fazda enerjin yüksek, bu sporları
dene", "luteal fazda yavaşla" gibi **performans/optimizasyon** çerçevesinde
faza göre değişen egzersiz önerileri. Bu spesifik iddia — döngü fazının
egzersiz performansını/kas adaptasyonunu etkilediği — kontrollü
araştırmalarla **çürütüldü**: [McMaster Üniversitesi çalışması (Journal of
Physiology, 2023)](https://news.mcmaster.ca/researchers-debunk-common-beliefs-about-cycle-syncing-and-muscles/)
ve [Frontiers in Sports and Active Living derlemesi](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10076834/)
döngü fazının akut kuvvet performansı ya da antrenman adaptasyonu üzerinde
ölçülebilir bir etkisi olmadığını gösteriyor; "cycle syncing" büyük ölçüde
sosyal medya kaynaklı bir trend, klinik konsensüs değil.

Bu, önerilerin "yanlış" olduğu anlamına gelmiyordu (hafif hareket kramplarda
gerçekten rahatlatıcı olabilir — bu ayrı, desteklenen bir iddia) sorun
**çerçevelemeydi**: "bu fazda vücudun böyle çalışıyor, bu yüzden bu sporu
yap" gibi bilimsel kesinlik iddia eden bir dil kullanılıyordu.

**Karar (kullanıcı, 2026-09-04):** Faza göre öneri yapısı korunsun (tamamen
kaldırmak yerine), ama dil "bilim" değil "nasıl hissedebileceğin"
çerçevesine çevrildi — `mock_cycle_data.dart`'taki foliküler/ovülasyon
fazlarının `tip`/`bodyInfo`/`selfCare` metinleri ve
`mock_wellness_data.dart`'taki ovülasyon `sleepTip`'i artık "bazı kızlar...
hissediyor", "hissediyorsan..." gibi olasılık dili kullanıyor, kesinlik
iddiası yok. Adet ve luteal fazı metinleri zaten yeterince yumuşaktı
("yaşayabilirsin", "azalabilir"), değiştirilmedi.

## Doğrulanmuş iddialar (devam) — 2026-09-05, makale gövdeleri

| İddia | Nerede | Kaynak |
|---|---|---|
| Primer dismenore (adet krampı), pelvik patoloji olmadan yaşanan adet ağrısıdır ve adölesanlarda en sık görülen adet belirtisidir; NSAID'ler genelde adet başlamadan 1-2 gün önce başlanıp ilk 2-3 gün sürdürülür. | `lib/features/articles/data/article_data.dart` — "Adet Sancısıyla Başa Çıkmanın 5 Yolu" | [ACOG Committee Opinion No. 760 — Dysmenorrhea and Endometriosis in the Adolescent](https://journals.lww.com/greenjournal/fulltext/10.1097/aog.0000000000002978~acog-committee-opinion-no-760-dysmenorrhea-and) |
| Sürekli, düşük seviyeli topikal ısı, adet ağrısında oral ibuprofene benzer ya da üstün bulunmuş; ısı + ibuprofen kombinasyonu tek başına ibuprofene göre ağrı kesilme süresini kısaltıyor. | Aynı makale | [ACOG — Dysmenorrhea: Painful Periods (FAQ)](https://www.acog.org/womens-health/faqs/dysmenorrhea-painful-periods); bkz. Pediatrics Nationwide özeti: [Improving Care for Adolescents and Young Women With Pelvic Pain](https://pediatricsnationwide.org/2019/03/21/improving-care-for-adolescents-and-young-women-with-pelvic-pain/) |
| PMS, adetten önceki günlerde yaşanan fiziksel/duygusal değişikliklerin genel adıdır (mod değişimi, sinirlilik, kaygı, konsantrasyon güçlüğü, iştah/uyku değişiklikleri, şişkinlik). Adölesanlarda bu belirtileri normal duygusal gelişimden ayırt etmek güç olabilir. | `article_data.dart` — "PMS Nedir?" | [ACOG — Premenstrual Syndrome (PMS) FAQ](https://www.acog.org/womens-health/faqs/premenstrual-syndrome); [ACOG Clinical Practice Guideline — Management of Premenstrual Disorders (2023)](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2023/12/management-of-premenstrual-disorders) |
| Östrojen arttıkça serotonin üretimi de artma eğilimindedir (iyi hissetme ile ilişkilendirilir); progesteron ise monoamin oksidaz (MAO) aktivitesini artırarak serotonini azaltabilir. Ruh hali değişkenliği, hormonların mutlak seviyesinden çok ne kadar hızlı değiştiğiyle daha ilişkili görünüyor; bu etkileşim adölesan beyin gelişiminde de rol oynar. | `article_data.dart` — "Hormonlar ve Ruh Halin" | Genel nöroendokrin mekanizma özeti (drbrighten.com, genomind.com); adölesana özel: [Menstrual cycle and mental health in adolescents: a developmental neuroendocrine perspective — Neuropsychopharmacology (2025)](https://www.nature.com/articles/s41386-025-02184-2) — **not: ilk iki kaynak popüler sağlık siteleri, klinik otorite değil; iddia genel mekanizma düzeyinde tutuldu, kesin/tanısal dil kullanılmadı.** |
| Ovülasyondan sonra yükselen progesteron vücut sıcaklığını ~0.4-1.0°F artırır; gece uykuya dalmak için gereken doğal soğuma ile bu artış çakışabilir, bazı kadınlarda luteal fazda uykuya dalma gecikmesi ve gece uyanmalarına yol açabilir. | `article_data.dart` — "Uyku ve Döngü İlişkisi" | 35 çalışmalık bir sistematik derlemenin özeti (bettersleep.com); mekanizma: [Menstrual Cycle Fluctuations of Progesterone and the Effect on Sleep Regulation — Restorative Medicine](https://restorativemedicine.org/journal/menstrual-cycle-fluctuations-progesterone-effect-sleep-regulation/) — **not: popüler özet kaynaklar kullanıldı, birincil literatür (PMC/APS makaleleri) yayından önce çapraz kontrol edilmeli.** |

## Doğrulanmamış / kaynağı olmayan içerik (yayından önce ele alınmalı)

- Yukarıdaki hormon/ruh hali ve uyku iddiaları ikincil (popüler sağlık
  sitesi) kaynaklara dayanıyor — yayından önce PMC/APS gibi birincil
  literatürle çapraz kontrol edilmeli, ardından gerçek bir uzman tarafından
  son onaylanmalı (bkz. dosya başındaki genel not).
- Makale gövdelerindeki ilaç/dozaj referansları (ör. ibuprofen zamanlaması)
  kasıtlı olarak "bir yetişkine/eczacıya danış" çerçevesinde tutuldu, doğrudan
  dozaj talimatı verilmedi — bu çerçeve korunmalı, ileride değiştirilirse
  tekrar gözden geçirilmeli.

## Kaldırılan içerik

- Eskiden `mock_cycle_data.dart` içinde bir `didYouKnow` listesi vardı
  ("ortalama bir kadın hayatında ~450 kez adet görür", "ilk adet 10-15 yaş
  arası başlar" vb.) — hiçbir ekranda kullanılmıyordu ve kaynaksızdı, bu
  yüzden dead code temizliğinde kaldırıldı. Gelecekte eklenirse önce bu
  tabloya girmeli.
- `lib/features/qa/screens/qa_screen.dart` — kurgusal doktor isimleri ve
  önceden yazılmış cevaplar içeren "Uzman Paneli" içeriği tamamen kaldırıldı
  (gerçek olmayan uzman onayı izlenimi veriyordu). Gerçek, onaylı içerik
  hazır olana kadar dürüst bir bekleme ekranı gösteriliyor.

## Değişiklik günlüğü

- 2026-09-04: İlk sürüm. Quiz sorusundaki döngü uzunluğu iddiası (21-35 gün)
  adölesana özel değildi, ACOG/AAP Committee Opinion No. 651'e göre
  21-45 güne düzeltildi.
- 2026-09-04: `mock_wellness_data.dart` kaynaklandı — demir/magnezyum
  önerileri kanıtla destekleniyor (magnezyum için kısmi/karışık kanıt
  notuyla), faza göre değişen uyku süresi iddiasının kaynağı olmadığı için
  tüm fazlar için tek tip "8-10 saat"e (AASM/AAP) düzeltildi. Faza göre
  değişen egzersiz önerilerinin dayandığı "cycle syncing" çerçevesinin
  kontrollü araştırmalarla çürütüldüğü tespit edildi.
- 2026-09-05: Makale gövdeleri yazıldı (`article_data.dart`, 7 makale) ve
  gerçek navigasyona bağlandı (`ArticleDetailScreen`) — daha önce sadece
  başlık/alt başlık gösterip hiçbir yere gitmeyen "Okumaya Başla" ve makale
  satırları artık gerçek, kaynaklı içerik açıyor. Kramp/ısı tedavisi (ACOG
  760 + FAQ), PMS tanımı (ACOG FAQ + 2023 kılavuzu), hormon-ruh hali
  mekanizması ve luteal faz uyku mekanizması yeni kaynaklandı — hormon/uyku
  iddiaları ikincil kaynaklara dayanıyor, yayından önce birincil literatürle
  çapraz kontrol + gerçek uzman onayı gerekiyor. "Hareket ve Döngü"
  makalesi, daha önce çürütülen "cycle syncing" çerçevesini makale içinde
  açıkça yanlışlıyor.
- 2026-09-04: "Cycle syncing" çerçevesi kararı uygulandı — foliküler ve
  ovülasyon fazlarındaki `tip`/`bodyInfo`/`selfCare` metinleri (ve ilgili
  `sleepTip`) kesinlik iddiasından olasılık diline çevrildi, faza göre
  öneri yapısı korundu.
