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
- **VERBİS:** Genel istisna eşiği (2026 itibarıyla): yıllık çalışan sayısı
  50'den az VE yıllık mali bilanço 100 milyon TL'den az olan veri sorumluları
  VERBİS'ten muaf — **ancak** ana faaliyet konusu özel nitelikli kişisel veri
  işleme olanlar bu genel istisnadan yararlanamaz. Ritim'in ana işlevi (adet/
  sağlık verisi işleme) tam bu kategoriye girebilir. Eylül 2025'te bu
  kategori için ayrı, daha düşük bir **mikro ölçek istisnası** eklendi:
  çalışan sayısı 10'dan az VE yıllık bilanço 10 milyon TL'den az olanlar yine
  de muaf olabiliyor. Kayıt yükümlülüğüne aykırılığın idari para cezası
  (2026 itibarıyla) 85.437 TL – 17.092.242 TL bandında. Bu eşiklerin hangisi
  Ritim'e uygulanacağı — ve şirketin hangi tüzel yapı altında (EduXperts mi,
  ayrı bir şirket mi) faaliyet göstereceği — bir avukat/mali müşavirle
  netleştirilmeli; bu bir mühendislik görevi değil, hukuki bir tespit.
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

- [ ] Ebeveyn kapısı yaş eşiği (şu an: 13) — nihai risk toleransı kararı.
- [ ] Yumuşak öneri mi (mevcut) yoksa zorunlu engel mi olmalı — ürün/hukuk
      ortak kararı.
- [ ] Üç yasal metnin nihai metni — gerçek şirket/kişi adı, adres, iletişim
      bilgisi ve KVKK'nın istediği veri sorumlusu detayları eklenmeden
      yayına alınamaz.
- [ ] VERBİS kayıt gerekliliği tespiti (genel istisna mı, mikro istisna mı,
      yoksa kayıt zorunlu mu — bölüm 2).
- [ ] Yurt dışı veri aktarımı: Supabase (yurt dışı barındırma) + Standart
      Sözleşme/taahhütname mi, yoksa yerli barındırma mı — bölüm 2.
- [ ] Şirket yapısı: EduXperts çatısı altında mı, ayrı bir tüzel kişilik mi
      (sorumluluğu ayırma açısından fark yaratabilir).
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
