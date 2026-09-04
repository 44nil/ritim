# Ritim — Yasal / Uyumluluk Notları (KVKK / Play / Apple)

> Bu belge bir hukuki görüş değildir. Claude Code tarafından kamuya açık
> kaynaklar ve kod incelemesi baz alınarak yazılmıştır. Herhangi bir
> yayın/başvuru kararından önce avukat/mali müşavir incelemesi gerekir.
> Son güncelleme: 2026-08-13.

## 1. Kapsam

Ritim, 10-17 yaş arası kullanıcılar için bir adet döngüsü / ruh hali takip
uygulaması. Bu belge, backend (Supabase) devreye girmeden önce ele alınması
gereken yasal riskleri ve uygulama içi karşılıklarını özetler.

**Bugünkü durum:** Hiçbir veri kalıcı olarak saklanmıyor (in-memory Riverpod
state, uygulama kapanınca sıfırlanıyor), backend yok, üçüncü taraf
analytics/reklam SDK'sı yok, izin (permission) talebi yok. Yani şu an gerçek
bir "veri işleme" (KVKK anlamında) yok. Ama onboarding zaten özel nitelikli
veri (yaş, adet tarihleri, döngü uzunluğu) topluyor ve Supabase entegrasyonu
planlı — bu notlar, backend geldiğinde patlamaması için şimdiden kurulan
desenleri (aydınlatma → rıza → kayıt) belgeler.

## 2. KVKK özeti

- **Özel nitelikli kişisel veri:** Sağlıkla ilgili veri (adet/döngü verisi,
  semptomlar, ruh hali) KVKK Madde 6 kapsamında özel nitelikli kişisel
  veridir. İşlenmesi genel kural olarak **açık rıza** gerektirir.
- **Çocuklara ait veri:** KVKK'da çocuklara özel, sabit bir dijital rıza yaşı
  yoktur. Uygulamada Türk Medeni Kanunu'nun velayet hükümlerine ve çocuğun
  "ayırt etme gücü"ne bakılır — somut duruma göre değerlendirme gerekir.
  Bu belirsizlik nedeniyle Ritim, 13 yaş altı kullanıcılara ebeveyn/vasi
  eşliğini **öneren** (zorunlu kılmayan) bir ürün kararı uyguluyor — bkz.
  bölüm 3. Bu eşik ve yaklaşım hukuki bir zorunluluk değil, risk azaltma
  tercihidir; nihai karar avukat onayı gerektirir.
- **Aydınlatma yükümlülüğü (Madde 10):** Rıza gerekip gerekmediğinden
  bağımsız olarak, veri sorumlusu veri işlemeden önce ilgili kişiyi
  bilgilendirmek zorundadır (hangi veri, neden, kime aktarılıyor, saklama
  süresi, haklar). Ritim'de bu, onboarding'deki yeni "Aydınlatma Metni"
  adımıyla karşılanıyor.
- **VERBİS — ÇÖZÜLDÜ (2026-09-04):** Genel istisna eşiği: yıllık çalışan
  sayısı 50'den az VE yıllık mali bilanço 100 milyon TL'den az olan veri
  sorumluları VERBİS'ten muaf. Ana faaliyet konusu özel nitelikli kişisel
  veri işleme olanlar için ayrı, daha dar bir **mikro ölçek istisnası** var
  (04.09.2025 tarihli 2025/1572 sayılı Kurul Kararı): çalışan sayısı 10'dan
  az VE yıllık bilanço 10 milyon TL'den az olanlar da muaf.
  Kullanıcı, KVKK'nın resmi "Sorularla VERBİS" belgesini (Soru 7) kaynak
  göstererek EduXperts'in ölçeğini bildirdi: **10'dan az çalışan, 10 milyon
  TL altı yıllık bilanço.** Bu, "ana faaliyet" EduXperts'in genel iş modeli
  (LMS/EduQR/Erasmus+ danışmanlık) mi yoksa Ritim'in özel nitelikli veri
  işlemesi mi sayılırsa sayılsın, **her iki eşiği de** (genel 50/100M ve
  mikro 10/10M) karşılıyor — yani hangi sınıflandırma uygulanırsa uygulansın
  sonuç değişmiyor. Bu nedenle **VERBİS kaydı gerekmiyor** sonucuna makul
  güvenle varılabildi, ayrı bir avukat/mali müşavir tespitine gerek
  kalmadı. (Şirket ölçeği ileride büyürse — özellikle 10 çalışan/10M TL
  sınırına yaklaşılırsa — bu değerlendirme tekrar yapılmalı.)
- **Yurt dışına veri aktarımı:** 10 Temmuz 2024'te yürürlüğe giren yeni
  yönetmelikle KVKK'nın yurt dışı aktarım kuralları değişti — Standart
  Sözleşme (Kurul'un ilan ettiği 4 model: veri sorumlusundan veri
  sorumlusuna/işleyene, veri işleyenden veri sorumlusuna/işleyene) veya
  Kurul onaylı Bağlayıcı Şirket Kuralları gibi bir mekanizma olmadan kişisel
  veri yurt dışına aktarılamıyor. **Bu doğrudan Supabase planını ilgilendirir:**
  Supabase'in standart bölgeleri Türkiye'de değil (AWS altyapısı, genelde
  ABD/AB bölgeleri) — yani Supabase'e geçildiği an bu "yurt dışı aktarım"
  kapsamına girilir ve bir Standart Sözleşme/taahhütname süreci gerekir.
  Alternatif olarak Türkiye merkezli bir barındırma/veritabanı seçeneği bu
  yükümlülüğü baştan ortadan kaldırabilir — Supabase kararından önce bu
  ikisi (yurt dışı aktarım süreci vs. yerli barındırma) bir avukatla/mali
  müşavirle karşılaştırılmalı.
- **Cihazda kalan, sunucuya hiç gitmeyen veri** (bugünkü Ritim'in durumu)
  hem VERBİS hem yurt dışı aktarım risklerini pratikte sıfıra yaklaştırır —
  KVKK anlamında teknik olarak "işleme" yine de oluyor (elde etme/kullanma),
  ama aktarım/saklama kaynaklı riskler oluşmuyor. Backend'e geçilene kadar
  bu, en düşük riskli seçenek olmaya devam ediyor.

Kaynaklar: kvkk.gov.tr (Özel Nitelikli Kişisel Veriler rehberi, Yurt Dışına
Aktarım rehberi), eralp.av.tr ve sengunhukukyayinlari.com'daki çocuk verisi/
KVKK-GDPR karşılaştırma yazıları, erdem-erdem.av.tr ve regulfy.com'daki 2026
VERBİS istisna eşiği özetleri. Not: Bu rakamlar zaman içinde Kurul kararlarıyla
değişebilir — bu belgeyi kullanmadan önce güncelliğini kvkk.gov.tr üzerinden
teyit et.

## 3. Uygulama içi karşılık (bu değişiklik setiyle eklenenler)

- `lib/features/legal/` modülü: KVKK Aydınlatma Metni, Gizlilik Politikası,
  Kullanım Şartları — hepsi **TASLAK** etiketli.
- Onboarding sırası: Yaş → (13 altıysa) Ebeveyn Kapısı → Aydınlatma Metni →
  Açık Rıza (varsayılan işaretsiz checkbox) → mevcut veri adımları.
- Rıza kaydı (`onboarding_consent_provider.dart`) şu an in-memory: hangi
  metin versiyonuna, ne zaman, kimin (kendi/ebeveyn eşliğinde) rıza
  verdiğini tutuyor. Supabase entegrasyonunda bu alanların kalıcı hale
  gelmesi gerekiyor (bkz. bölüm 6).
- Ebeveyn panelindeki "Girişi tamamla (demo)" butonu `kDebugMode` ile
  release build'lerden çıkarıldı (tek tıkla sahte kimlik doğrulama riski).
- Ebeveyn panelinin çocuğun ruh hali/semptom/not verilerini **göstermemesi**
  bilinçli bir tasarım kararı olarak korundu — bu iyi bir mahremiyet
  pratiği, "eksiklik" olarak görülüp değiştirilmemeli.
- Takma ad kabul eden isim alanı (gerçek isim zorunlu değil) — veri
  minimizasyonu örneği, değiştirilmedi.

## 4. Google Play Families Policy kontrol listesi

- [ ] Play Console'da hedef yaş aralığı (target audience) doğru beyan
      edilmeli — Ritim'in 10-17 aralığı "çocukları da kapsayan" bir uygulama
      sayılabilir, bu daha yüksek bir uyum barı getirir.
- [ ] Data Safety formu, gerçekte toplanan veriyle birebir eşleşmeli
      (bugün: hiçbir şey kalıcı değil; Supabase sonrası güncellenmeli).
- [ ] Çocuk hedef kitlesi varsa, onaylanmamış SDK'lar (reklam/analytics)
      kullanılmamalı; bugün hiç SDK yok, bu iyi durumda.
- [ ] COPPA/GDPR gibi ilgili düzenlemelere uyum beyanı gerekebilir.

## 5. Apple App Store kontrol listesi

- [ ] Barındırılan, herkese açık bir Gizlilik Politikası URL'i — App Store
      Connect başvurusunun **zorunlu** bir parçası. Bugün elimizde yok,
      taslak metin var ama yayına alınmadı (bkz. bölüm 3 not).
- [ ] Yaş derecelendirmesi anketi — muhtemelen 12+, "Kids Category" (tipik
      5-11 yaş bandı) Ritim'in 10-17 hedef kitlesine uymuyor.
- [ ] Sağlıkla ilgili içerik/veri, ek inceleme riski taşıyabilir — doğruluk
      ve yöntem açıklaması istenebilir.
- [ ] Reşit olmayan kullanıcıdan veri toplayan/aktaran uygulamalar ilgili
      çocuk mahremiyeti mevzuatına uymalı.

## 6. Supabase backend'e geçerken gereken rıza kaydı alanları

`onboarding_consent_provider.dart`'taki `ConsentState` şu alanları tutuyor,
Supabase'e taşınırken bunların kalıcı ve sorgulanabilir olması gerekiyor:

- `consentGivenAt` (timestamp)
- `contentVersion` (hangi metin versiyonuna rıza verildi)
- `ageAtOnboarding`
- `guardianAssisted` (bool)
- `privacyNoticeSeenAt` (timestamp)

Ayrıca backend aşamasında ele alınması gerekenler:
- Veri saklama süresi politikası
- Silme / veri taşınabilirliği (KVKK Madde 11 hakları) için bir mekanizma
- VERBİS eşiği tekrar kontrol edilmeli (bölüm 2 — genel 50/100M eşiği mi,
  yoksa özel nitelikli veri ana faaliyeti için 10/10M mikro istisnası mı
  uygulanıyor, bir avukatla netleştirilmeli)
- Supabase seçilirse: Standart Sözleşme/taahhütname süreci mi, yoksa yerli
  barındırmaya mı geçilecek — bölüm 2'deki yurt dışı aktarım notuna bakın

## 7. İnsan/avukat onayı gereken açık kararlar

- [x] Ebeveyn kapısı yaş eşiği ve yumuşak/zorunlu kararı — **ÇÖZÜLDÜ
      (2026-09-04): 13 eşiği ve mevcut yumuşak/opsiyonel yaklaşım
      korunuyor, değişiklik yok.** Gerekçe: KVKK'da sabit bir dijital rıza
      yaşı yok (Medeni Kanun'un "ayırt etme gücü" ölçütüne bakıyor); local-
      first mimaride şirket hiçbir veri toplamadığı için klasik "veli
      onayı olmadan çocuktan veri toplama" riski zaten düşük; ve en
      önemlisi, zorunlu bir engel tam da uygulamanın hedef kitlesini
      (örn. okulda tek başına ilk adetini yaşayan 10 yaşındaki bir kız)
      en çok ihtiyaç duyduğu anda dışarıda bırakırdı. Kullanıcı bunu
      teyit etti — 10 yaşındaki bir kullanıcının "kendi başıma devam
      etmek istiyorum" diyip uygulamayı kullanabilmesi kasıtlı bir ürün
      kararı, kod tarafında zaten böyle çalışıyor (doğrulandı: `setup_
      screen.dart`'taki `_age < 13` sadece ekranı gösterip göstermeme
      kararı, `guardianAssisted` seçimi akışı bloklamıyor, sadece
      kaydediliyor).
- [x] Üç yasal metnin veri sorumlusu/iletişim bilgisi — dolduruldu
      (2026-09-04, aşağıya bkz.). **Ama** metnin içeriği (aydınlatma
      kapsamı, haklar bölümü, saklama süresi ifadeleri vb.) henüz bir
      avukat tarafından incelenmedi — "nihai" sayılamaz, hâlâ TASLAK.
- [x] VERBİS kayıt gerekliliği tespiti — **kayıt gerekmiyor** (bölüm 2,
      2026-09-04): EduXperts'in ölçeği hem genel hem mikro istisna eşiğini
      karşılıyor.
- [ ] Yurt dışı veri aktarımı: Supabase (yurt dışı barındırma) + Standart
      Sözleşme/taahhütname mi, yoksa yerli barındırma mı — bölüm 2. (Not:
      backend henüz yok, bu madde şimdilik düşük öncelikli.)
- [x] Şirket yapısı: **EduXperts çatısı altında** yayınlanacak (kullanıcı
      kararı, 2026-09-04) — ayrı bir tüzel kişilik kurulmayacak.
- [ ] App Store Connect yaş derecelendirme anketinin ve Play Console Data
      Safety / hedef kitle formunun resmi gönderimi.

## 8. Değişiklik günlüğü

- 2026-08-12: İlk sürüm — demo-bypass butonu gate'lendi, `legal/` modülü ve
  onboarding aydınlatma/rıza/ebeveyn kapısı adımları eklendi.
- 2026-08-13: VERBİS bölümü güncellendi (Eylül 2025 mikro ölçek istisnası —
  10 çalışan/10M TL — eklendi, önceki "hiç istisna yok" ifadesi düzeltildi).
  Yurt dışına veri aktarımı bölümü eklendi (Supabase'in yurt dışı barındırma
  olması ve 2024 yönetmeliği gereği Standart Sözleşme/taahhütname
  gerekliliği). Kaynak: kullanıcının paylaştığı bir AI-üretimi metindeki
  iddialar tek tek doğrulandı; bazıları teyit edildi (VERBİS mikro istisna,
  yurt dışı aktarım), bazıları doğrulanamadı (net "15 yaş" eşiği iddiası) —
  doğrulanamayanlar bu belgeye eklenmedi.
- 2026-09-04: Şirket yapısı kararı verildi (EduXperts çatısı altında).
  Kullanıcıdan alınan gerçek bilgilerle (unvan: Esra Nil Doğan Eduxperts
  Eğitim Teknoloji Danışmanlık Ticaret Limited Şirketi; adres: Girne Mah.,
  09100 Efeler/Aydın; e-posta: info@eduxperts.com.tr — vergi/MERSİS no
  kullanıcı tarafından bilinçli olarak eklenmedi) üç yasal metindeki veri
  sorumlusu/iletişim placeholder'ları dolduruldu, `kLegalContentVersion`
  v2-2026-09-04'e yükseltildi. Metnin içeriği hâlâ avukat incelemesi
  bekliyor — TASLAK etiketi kaldırılmadı.
- 2026-09-04: VERBİS sorusu çözüldü. Kullanıcı KVKK'nın resmi "Sorularla
  VERBİS" belgesini (Soru 7) kaynak gösterdi ve EduXperts'in ölçeğini
  bildirdi (10'dan az çalışan, 10M TL altı bilanço) — bu ölçek hem genel
  hem mikro istisna eşiğini karşıladığı için "ana faaliyet" sınıflandırması
  ne olursa olsun sonuç değişmiyor: VERBİS kaydı gerekmiyor. Ayrı bir
  avukat/mali müşavir tespitine gerek kalmadı.
- 2026-09-04: Ebeveyn kapısı sorusu çözüldü — 13 yaş eşiği ve yumuşak/
  opsiyonel yaklaşım (mevcut davranış) korunuyor, kod değişikliği yok.
  Bkz. bölüm 7 için gerekçe.
