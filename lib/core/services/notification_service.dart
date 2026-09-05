import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../providers/cycle_provider.dart';

/// Yerel (cihaz üstü) bildirimler — sunucu yok, hiçbir veri dışarı gitmiyor.
/// İki bildirim türü var: günlük kayıt hatırlatması (tekrarlı) ve adet
/// tahmini hatırlatması (tahmin her değiştiğinde yeniden planlanan, tek
/// seferlik bir bildirim).
class NotificationService {
  NotificationService._();

  static const _dailyReminderId = 1;
  static const _periodReminderId = 2;

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    await _plugin.initialize(settings: const InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ));
    _initialized = true;
  }

  /// Sistem izin diyaloğunu gösterir. Kullanıcı bir açıklama ekranı gördükten
  /// SONRA çağrılmalı — kamera izninde olduğu gibi, hazırlıksız yakalamamak için.
  static Future<bool> requestPermission() async {
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    final android = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return (ios ?? android ?? true);
  }

  static Future<void> setDailyReminder({required bool enabled, required int hour, required int minute}) async {
    await _plugin.cancel(id: _dailyReminderId);
    if (!enabled) return;
    await _plugin.zonedSchedule(
      id: _dailyReminderId,
      title: 'Bugünü kaydetmeyi unutma',
      body: 'Ruh halini, belirtilerini ya da bir notunu ekleyebilirsin.',
      scheduledDate: _nextInstanceOf(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('daily_reminder', 'Günlük Kayıt Hatırlatması'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Tahmini adet tarihinden `daysBefore` gün önce, saat 09:00'da tek
  /// seferlik bir hatırlatma planlar. Tahmin her değiştiğinde (yeni kayıt,
  /// yeni döngü) yeniden çağrılmalı — bu yüzden state'e bağlı bir "setter"
  /// değil, mevcut CycleState'i parametre olarak alan saf bir fonksiyon.
  static Future<void> reschedulePeriodReminder(CycleState cycle, {required bool enabled, required int daysBefore}) async {
    await _plugin.cancel(id: _periodReminderId);
    if (!enabled) return;
    final estimate = cycle.nextPeriodEstimate;
    if (estimate == null) return;
    final reminderDate = estimate.subtract(Duration(days: daysBefore));
    final scheduled = tz.TZDateTime(tz.local, reminderDate.year, reminderDate.month, reminderDate.day, 9);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: _periodReminderId,
      title: 'Adetin yaklaşıyor',
      body: 'Tahminlere göre $daysBefore gün içinde adetin başlayabilir.',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('period_reminder', 'Adet Tahmini Hatırlatması'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
