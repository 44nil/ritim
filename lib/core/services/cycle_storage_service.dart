import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/cycle_provider.dart';

// Döngü verisini cihazın güvenli depolamasında tutar (iOS Keychain /
// Android Keystore ile şifreli). Hiçbir veri sunucuya gönderilmez.
//
// iOS'ta synchronizable: true ile bu, kullanıcının Apple ID'sine bağlı
// iCloud Keychain'e senkronize olur (kullanıcı iCloud Keychain'i açıksa) —
// telefon kaybolsa/sıfırlansa/değişse bile aynı Apple ID'ye girince veri
// geri gelir. Hâlâ uçtan uca Apple'ın kendi şifrelemesiyle korunuyor, bize
// (veya bir sunucuya) hiçbir zaman gitmiyor — sadece "cihaz tek nokta
// arızası olmasın" diye.
class CycleStorageService {
  CycleStorageService._();

  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(synchronizable: true),
  );
  static const _key = 'ritim_cycle_state_v1';

  static Future<CycleState?> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    try {
      return CycleState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Bozuk/okunamayan kayıt — sıfırdan başlamak, çökmekten iyidir.
      return null;
    }
  }

  static Future<void> save(CycleState state) {
    return _storage.write(key: _key, value: jsonEncode(state.toJson()));
  }

  // Not: iOS'ta Keychain uygulama silinse bile kalır — bu yüzden "verilerimi
  // sil" isteği gerçek bir silme çağrısı gerektiriyor, sadece uygulamayı
  // kaldırmak yeterli değil.
  static Future<void> delete() {
    return _storage.delete(key: _key);
  }

  // Elle yedekleme — özellikle Android'de, Keystore anahtarları cihaz
  // dışına çıkamadığı için otomatik bir "yeni telefonda geri gel"
  // mekanizması yok (bkz. iOS'taki iCloud Anahtarlık senkronizasyonu).
  // Kullanıcı bu dosyayı istediği yere (Drive, e-posta, Dosyalar) kendi
  // kaydedip, yeni cihazda geri yükleyebilir.
  static Future<File> exportToTempFile(CycleState state) async {
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    final name = 'ritim-yedek-${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.json';
    final file = File('${dir.path}/$name');
    return file.writeAsString(jsonEncode(state.toJson()));
  }

  static Future<CycleState?> importFromFile(File file) async {
    try {
      final raw = await file.readAsString();
      return CycleState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Bozuk/uyumsuz dosya — çökmek yerine null döndürüp UI'da uyarı gösteriyoruz.
      return null;
    }
  }
}
