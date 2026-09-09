# Ritim — İçerik Kaynak Doğrulaması

> Bu belge bir tıbbi görüş değildir. Uygulamadaki her sağlık/döngü iddiasının
> hangi kaynağa dayandığını (veya henüz dayanmadığını) izlemek için tutulur.
> Yayından önce bu listenin gerçek bir doktor/uzman tarafından son kez
> onaylanması gerekir — bkz. docs/legal-compliance-notes.md bölüm 7.
> Son güncelleme: 2026-09-09.

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
| Adölesanda (10-17 yaş) normal döngü uzunluğu 21-45 gündür; yetişkinlerde bu 21-35 güne daralır; ilk adetten sonraki ~3 yıl içinde döngü kademeli olarak yetişkin aralığına yaklaşır. | `lib/core/providers/cycle_provider.dart` — `averageCycleLength` 21-45 aralığına sıkıştırılıyor (artık quiz'de değil, bkz. aşağıdaki "ARTIK GEÇERSİZ" notu) | [ACOG & AAP Committee Opinion No. 651 — "Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign" (2015)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign) |
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
| Östrojen arttıkça serotonin üretimi de artma eğilimindedir (iyi hissetme ile ilişkilendirilir); progesteron ise monoamin oksidaz (MAO) aktivitesini artırarak serotonini azaltabilir. Ruh hali değişkenliği, hormonların mutlak seviyesinden çok ne kadar hızlı değiştiğiyle daha ilişkili görünüyor. | `article_data.dart` — "Hormonlar ve Ruh Halin" | Mekanizma birincil literatürle doğrulandı: [Rapkin & Akopians — Pathophysiology of premenstrual syndrome and premenstrual dysphoric disorder, Menopause International (2012)](https://journals.sagepub.com/doi/10.1258/mi.2012.012014); hormon seviyesinden çok değişim hızının belirleyici olduğu bulgusu: [Schmidt et al. — PMDD Symptoms Following Ovarian Suppression: Triggered by Change in Ovarian Steroid Levels But Not Continuous Stable Levels, Am J Psychiatry (2017)](https://ajp.psychiatryonline.org/doi/10.1176/appi.ajp.2017.16101113). |
| Ovülasyondan sonra yükselen progesteron vücut sıcaklığını hafifçe artırır; gece uykuya dalmak için gereken doğal soğuma ile bu artış çakışabilir, bazı kadınlarda uykuya dalma gecikmesine yol açabilir. | `article_data.dart` — "Uyku ve Döngü İlişkisi" | Birincil literatürle doğrulandı: [Neurobiological and Hormonal Mechanisms Regulating Women's Sleep — Frontiers in Neuroscience (2021)](https://pmc.ncbi.nlm.nih.gov/articles/PMC7840832/) — not: kaynağa göre etki tek başına progesterondan çok östrojenle birlikte (sinerjik) olabilir; makale zaten "olası bir sebep"/"hafifçe" gibi temkinli dil kullanıyor, bu kalibrasyon korundu. |

## Doğrulanmış iddialar (devam) — 2026-09-09, quiz soru havuzu genişletmesi [ARTIK GEÇERSİZ]

> **Bu bölüm tarihsel kayıt amaçlı tutuluyor.** Aynı gün içinde
> `quiz_data.dart` tamamen değiştirildi — kullanıcının kendi hazırladığı,
> daha basit/sıcak, formel kaynak gerektirmeyen 10 soruluk bir set (temel
> bilgiler, hijyen, semptom rahatlama, mit-gerçek kategorileri) mevcut
> tüm soruların (hem bu 10'un hem orijinal 6'nın) yerini aldı. Aşağıdaki
> tablo artık `quiz_data.dart`'taki hiçbir soruyu karşılamıyor — sadece
> "neden böyle bir yaklaşım denendi, neden vazgeçildi" kaydı olarak
> duruyor (bkz. not, alttaki paragraf).

| İddia | Nerede | Kaynak |
|---|---|---|
| Tamponu 4-8 saatte bir değiştirmek ve hiçbir zaman 8 saatten uzun takılı bırakmamak, nadir ama ciddi bir enfeksiyon (Toksik Şok Sendromu) riskini azaltır. | `lib/features/quiz/data/quiz_data.dart` (soru 7) | [FDA — "The Facts on Tampons—and How to Use Them Safely"](https://www.fda.gov/consumers/consumer-updates/facts-tampons-and-how-use-them-safely) |
| İlk regl (menarş) genellikle 10-15 yaş arasında başlar, ortanca yaş ~12,4. | `quiz_data.dart` (soru 8) | [AAP — "Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign"](https://publications.aap.org/pediatrics/article/118/5/2245/69874/) |
| Regl günleri dışında berrak/hafif beyazımsı, kokusuz bir vajinal akıntı normaldir — vücudun kendini temizleme yollarından biri. | `quiz_data.dart` (soru 9) | [Nemours KidsHealth — "Is My Vaginal Discharge Normal? (for Teens)"](https://kidshealth.org/en/teens/vdischarge2.html) |
| Ped, akış hafif olsa bile birkaç saatte bir değiştirilmeli; yoğun akışta daha sık. | `quiz_data.dart` (soru 10) | [FDA — "Menstrual Pads and Liners"](https://www.fda.gov/medical-devices/menstrual-product-options-facts-and-safe-use/menstrual-pads-and-liners) |
| Reglden önceki günlerde kafeini azaltmak bazı kızlarda PMS belirtilerini hafifletebilir. | `quiz_data.dart` (soru 11) | [Office on Women's Health — "Premenstrual syndrome (PMS)"](https://womenshealth.gov/menstrual-cycle/premenstrual-syndrome) |
| Hafif egzersiz, adet krampı üzerinde sıcak su torbası ve akupresürden daha büyük etki büyüklüğüne sahip (g=2.16 vs 0.73/0.56). | `quiz_data.dart` (soru 12) | [Armour ve ark. — sistematik derleme/meta-analiz, PMC (2019)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6337810/) — WebFetch ile doğrulandı |
| Bir pedi/tamponu art arda birkaç saat boyunca saatte bir değiştirmek gerekmesi, ya da 7 günden uzun süren kanama, bir yetişkine söylenmesi gereken bir durumdur. | `quiz_data.dart` (soru 13) | [ACOG — "Heavy Menstrual Bleeding" FAQ](https://www.acog.org/womens-health/faqs/heavy-menstrual-bleeding) — WebSearch ile doğrulandı (doğrudan fetch bot-engeli nedeniyle engellendi) |
| Östrojen ve progesteron seviyelerindeki değişimler ruh halini gerçekten etkileyebilir. | `quiz_data.dart` (soru 14) | [Office on Women's Health — "Your menstrual cycle"](https://womenshealth.gov/menstrual-cycle/your-menstrual-cycle) |
| Ped, tampon ve menstrual kap — hepsi FDA tarafından düzenlenen, doğru kullanıldığında güvenli seçenekler; "en doğru" tek bir seçenek yok. | `quiz_data.dart` (soru 15) | [FDA — "Menstrual Product Options, Facts, and Safe Use"](https://www.fda.gov/medical-devices/products-and-medical-procedures/menstrual-product-options-facts-and-safe-use) |

Not: Bu iddialar bir alt ajan tarafından araştırıldı, ardından 3 tanesi
(TSS, ağır kanama, egzersiz/kramp) doğrudan WebFetch/WebSearch ile ayrıca
çapraz doğrulandı. Amenore (regl kesilmesi) sorusu, bu yaş grubunda ilk
yıllarda düzensiz döngünün zaten normal olduğu mesajıyla çelişip gereksiz
kaygı yaratabileceği için önce tek başına kaldırıldı, sonra kullanıcı
"eski sorular gibi duruyor, quiz kısmını beceremedik" diyerek kendi
hazırladığı basit soru setini birebir kullanmamı istedi — tüm bu 10 soru
(ve orijinal 6) o setle değiştirildi (2026-09-09).

**Kaynak gösterme yeri:** Quiz sorularının açıklama metinlerinde
"Kaynak: ..." satırı YOK ve olmayacak — akademik dipnot/kurum adı/link
uygulama içinde hiç görünmüyor. Yeni soru setindeki iddialar (regl =
hastalık değil, duş zararsız, PMS normal, hafif hareket rahatlatır vb.)
zaten tartışmasız/temel bilgiler; ayrı bir kaynak tablosu gerektirmiyor.

## Düzeltilen hatalar — 2026-09-05, 4 alt ajanla çapraz doğrulama sonrası

- **Demir karşılaştırması yanlış yöndeydi**: "Döngüne Göre Beslenme" makalesi
  14-18 yaş kızların demir ihtiyacının (15mg/gün) "yetişkinlere göre daha
  fazla" olduğunu söylüyordu. Bu yanlış — adet gören yetişkin kadınlar
  (19-50 yaş) günde 18mg'a ihtiyaç duyuyor, yani gençlerden DAHA FAZLA, daha
  az değil. Doğru karşılaştırma, henüz adet görmeyen çocuklara (8mg) göre —
  gençlerin ihtiyacı onlara göre neredeyse iki kat fazla. Metin buna göre
  düzeltildi. Kaynak: [NIH ODS — Iron Fact Sheet](https://ods.od.nih.gov/factsheets/Iron-HealthProfessional/) RDA tablosu.
- **Hormonlar makalesindeki kaynak yanlış eşleştirilmişti**: Serotonin/MAO
  mekanizması için "Menstrual cycle and mental health in adolescents"
  (Nayman & Klusmann, Neuropsychopharmacology 2025) referans gösterilmişti,
  ama bu makale kortiko-limbik beyin gelişimi üzerine bir perspektif yazısı
  — spesifik olarak serotonin/MAO mekanizmasından bahsetmiyor. Yukarıdaki
  tabloda doğru birincil kaynaklarla (Rapkin & Akopians 2012, Schmidt et al.
  2017) değiştirildi.

## Doğrulanmamış / kaynağı olmayan içerik (yayından önce ele alınmalı)

- Makale gövdelerindeki ilaç/dozaj referansları (ör. ibuprofen zamanlaması)
  kasıtlı olarak "bir yetişkine/eczacıya danış" çerçevesinde tutuldu, doğrudan
  dozaj talimatı verilmedi — bu çerçeve korunmalı, ileride değiştirilirse
  tekrar gözden geçirilmeli. 4 bağımsız alt ajanla yapılan çapraz doğrulamada
  bu çerçevenin hiçbir makalede ihlal edilmediği teyit edildi (2026-09-05).
- Yukarıdaki tüm iddialar artık birincil literatürle doğrulandı, ama bu
  dosya başındaki genel not hâlâ geçerli: yayından önce gerçek bir
  doktor/uzman tarafından son onay gerekiyor.

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

## Klinik olmayan, pratik tavsiye içeriği

- "Okul Çantanda Ne Olmalı?" ve "Okulda Kazara Olursa Ne Yaparım?"
  makaleleri (`article_data.dart`) hiçbir tıbbi/bilimsel iddia içermiyor —
  genel kabul görmüş, sağlık eğitiminde standart olan pratik tavsiyeler
  (yedek ped bulundurma, okul hemşiresinden yardım isteme vb.). Bu yüzden
  yukarıdaki kaynak doğrulama tablosuna girmiyorlar, doktor onayı
  gerektirmiyorlar — ama içerik yine de kullanıcı tarafından istendi,
  kasıtlı olarak tampon değil sadece ped öneriyor (genç/deneyimsiz
  kullanıcılar için daha basit ve TSS riski gibi endişeler taşımıyor).

## Değişiklik günlüğü

- 2026-09-05: Quiz sekmesi dezenfekte edildi — `quiz_screen.dart`'ta tek bir
  `static const` soru vardı, "Sonraki Soru" butonu sadece cevap durumunu
  sıfırlayıp aynı soruyu tekrar gösteriyordu (gerçek bir hataydı). Yeni
  `lib/features/quiz/data/quiz_data.dart` dosyasında 6 sorudan oluşan gerçek
  bir havuz oluşturuldu — hepsi makale içeriğiyle aynı, zaten doğrulanmış
  iddialara dayanıyor (ACOG 651/760/PMS FAQ, AASM, eatright.org, McMaster
  2023 — yeni bir iddia eklenmedi). Sahte "3 Günlük Seri"/"240 pt" kartı ve
  dokununca hiçbir yere gitmeyen, sabit sahte ilerleme yüzdeli "Konu Bazlı"
  quiz setleri kaldırıldı (gerçek bir ilerleme takibi altyapısı yok).
- 2026-09-05: 4 bağımsız alt ajanla tüm 7 makale çapraz doğrulandı (bilimsel
  doğruluk + çocuk dili). Bir gerçek hata (demir karşılaştırması ters
  yöndeydi) ve bir kaynak yanlış eşleştirmesi (hormonlar makalesi) düzeltildi;
  hormon ve uyku makalelerinin ikincil-kaynak uyarısı, bulunan birincil
  literatürle (Rapkin & Akopians 2012, Schmidt et al. 2017, Frontiers in
  Neuroscience 2021) kaldırıldı. Ayrıca 6 cümlede dil sadeleştirmesi yapıldı
  (çifte olumsuzlama, edilgen çatı, "eğiliminde"/"bağımsız olarak" gibi
  resmi kelimeler).
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
