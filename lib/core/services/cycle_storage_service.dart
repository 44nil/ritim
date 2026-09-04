import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/cycle_provider.dart';

// Döngü verisini cihazın güvenli depolamasında tutar (iOS Keychain /
// Android Keystore ile şifreli). Hiçbir veri sunucuya gönderilmez.
class CycleStorageService {
  CycleStorageService._();

  static const _storage = FlutterSecureStorage();
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
}
