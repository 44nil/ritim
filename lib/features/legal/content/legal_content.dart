/// Ritim'in yasal metinleri — TASLAK.
///
/// Bu metinler uygulamanın bugünkü gerçek davranışını anlatır (hangi veri
/// toplanıyor, neden, kiminle paylaşılmıyor). Veri sorumlusu/iletişim
/// bilgileri dolduruldu (2026-09-04), ama metnin içeriği henüz bir avukat
/// tarafından incelenmedi — yayına alınmadan önce hukuki inceleme gerekir,
/// bkz. docs/legal-compliance-notes.md (özellikle bölüm 7'deki açık
/// kararlar: VERBİS kaydı, ebeveyn kapısı eşiği, veri saklama süresi).
library;

/// Yasal metin ekranlarının üstünde gösterilen taslak uyarısı.
const kLegalDraftDisclaimer =
    'TASLAK — bu metin yayına alınmadan önce hukuki inceleme gerektirir.';

/// Rıza kaydında hangi metin versiyonuna onay verildiğini işaretlemek için.
const kLegalContentVersion = 'v3-2026-09-07';

const kKvkkAydinlatmaMetni = '''
Veri sorumlusu: Eduxperts Eğitim Teknoloji Danışmanlık
Ticaret Limited Şirketi (Girne Mah., 09100 Efeler/Aydın,
info@eduxperts.com.tr)

Ritim olarak, uygulamayı kullanırken bize verdiğin bilgileri neden ve nasıl
kullandığımızı burada açıkça anlatıyoruz.

Hangi bilgileri topluyoruz?
• Yaşın
• Regl döngünle ilgili bilgiler (başlangıç/bitiş tarihleri, döngü uzunluğu)
• Günlük ruh hali, belirti ve serbest metin notların
• Kendi yazdığın ilaç isimleri ve günlük alım sayıların (doz/mg gibi tıbbi
  bilgi tutulmaz, sadece kişisel bir hatırlatma sayacı)
• Sana nasıl hitap edeceğimizi belirlemen için bir isim/takma ad

Bu bilgileri neden topluyoruz?
Döngünü takip edebilmen, sana yaşına uygun genel bilgilendirme sunabilmemiz
ve (istersen) bir ebeveyn/vasinle güven içinde paylaşabilmen için.

Bu bilgiler nerede duruyor?
Bugün itibarıyla Ritim'in bir sunucu (backend) altyapısı yok. Girdiğin
bilgiler yalnızca cihazının hafızasında tutuluyor ve uygulamayı kapattığında
siliniyor. İleride bir sunucu altyapısı eklenirse, bu metin güncellenecek
ve hangi bilgilerin ne kadar süreyle, nerede saklanacağı burada açıkça
belirtilecek.

Kiminle paylaşıyoruz?
Hiçbir reklam, analiz (analytics) ya da üçüncü taraf hizmeti kullanmıyoruz.
Bilgilerin hiçbiri üçüncü taraflarla paylaşılmıyor, satılmıyor.

Ebeveyn paneli hakkında
İstersen bir ebeveyn/vasi, senin adına ayrı bir girişle döngü genel bakışını
görebilir. Ruh hali, belirti ve serbest metin notların bu panelde
gösterilmez — bu bilinçli bir tercih, sana özel ve dürüst kayıt tutabileceğin
bir alan tanımak için.

Hakların
Kişisel verilerinle ilgili bilgi alma, düzeltme, silinmesini isteme gibi
haklara sahipsin. Bu haklara nasıl başvuracağını, sunucu altyapısı devreye
girdiğinde burada ve Gizlilik Politikası'nda bulacaksın.
''';

const kGizlilikPolitikasi = '''
Bu Gizlilik Politikası, Ritim uygulamasının kişisel verilerini nasıl ele
aldığını açıklar.

Veri sorumlusu
Eduxperts Eğitim Teknoloji Danışmanlık Ticaret Limited
Şirketi
Girne Mah., 09100 Efeler/Aydın
E-posta: info@eduxperts.com.tr

Topladığımız veriler
KVKK Aydınlatma Metni'nde listelenen veriler (yaş, döngü bilgileri, ruh
hali/belirti/not, ilaç hatırlatma sayacı, isim/takma ad).

Saklama
Bugün: cihaz hafızasında, uygulama kapanınca silinir, hiçbir sunucuya
gönderilmez. Bir sunucu altyapısı eklendiğinde bu bölüm, saklama süresi ve
konumuyla birlikte güncellenecek.

Üçüncü taraflarla paylaşım
Hiçbir reklam, analitik veya üçüncü taraf servisiyle entegrasyonumuz yok.
Veriler satılmaz, paylaşılmaz.

Çocukların gizliliği
Ritim, 10-17 yaş arası kullanıcılar için tasarlanmıştır. 13 yaş altındaki
kullanıcılara, kuruluma bir ebeveyn/vasiyle birlikte başlamaları önerilir
(zorunlu değildir). Ebeveyn paneli üzerinden bir yetişkin, çocuğun genel
döngü bilgilerini görebilir; kişisel not/ruh hali/belirti kayıtları
gösterilmez.

Haklarınız
KVKK kapsamında bilgi alma, düzeltme, silme ve itiraz haklarına sahipsiniz.
Başvuru yöntemi, sunucu altyapısı devreye girdiğinde burada belirtilecektir.

İletişim
Eduxperts Eğitim Teknoloji Danışmanlık Ticaret Limited
Şirketi
Girne Mah., 09100 Efeler/Aydın
E-posta: info@eduxperts.com.tr
''';

const kKullanimSartlari = '''
Bu Kullanım Şartları, Ritim uygulamasını kullanırken geçerli olan temel
kuralları özetler.

Uygulamanın amacı
Ritim, regl döngüsü takibi ve yaşa uygun genel sağlık bilgilendirmesi
sunan bir uygulamadır. Tıbbi tanı, tedavi veya profesyonel sağlık
danışmanlığı yerine geçmez.

Yaş uygunluğu
Ritim 10-17 yaş arası kullanıcılar için tasarlanmıştır.

Sorumluluk sınırı
Uygulamadaki genel bilgilendirme içerikleri ve döngü tahminleri, kişisel
farklılıklar nedeniyle her zaman doğru olmayabilir. Sağlıkla ilgili
endişelerinde bir yetişkine veya sağlık uzmanına danışman önerilir.

Hesap ve veri
Bugün itibarıyla Ritim bir kullanıcı hesabı/girişi gerektirmez; girdiğin
bilgiler yalnızca cihazında tutulur. Ebeveyn paneli, isteğe bağlı ve ayrı
bir girişle çalışır.

Değişiklikler
Bu şartlar, uygulama geliştikçe (özellikle bir sunucu altyapısı
eklendiğinde) güncellenebilir. Güncel sürüm her zaman uygulama içinden
erişilebilir olacaktır.

İletişim
Eduxperts Eğitim Teknoloji Danışmanlık Ticaret Limited
Şirketi
Girne Mah., 09100 Efeler/Aydın
E-posta: info@eduxperts.com.tr
''';
