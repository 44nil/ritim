import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/screen_gradient_background.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  Future<void> _toggleDaily(bool enabled) async {
    if (enabled && !await NotificationService.requestPermission()) {
      _showPermissionDenied();
      return;
    }
    final cycle = ref.read(cycleProvider);
    ref.read(cycleProvider.notifier).setDailyReminder(enabled: enabled);
    await NotificationService.setDailyReminder(
      enabled: enabled, hour: cycle.dailyReminderHour, minute: cycle.dailyReminderMinute,
    );
  }

  Future<void> _pickDailyTime() async {
    final cycle = ref.read(cycleProvider);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: cycle.dailyReminderHour, minute: cycle.dailyReminderMinute),
    );
    if (picked == null) return;
    ref.read(cycleProvider.notifier).setDailyReminder(enabled: true, hour: picked.hour, minute: picked.minute);
    await NotificationService.setDailyReminder(enabled: true, hour: picked.hour, minute: picked.minute);
  }

  Future<void> _togglePeriod(bool enabled) async {
    if (enabled && !await NotificationService.requestPermission()) {
      _showPermissionDenied();
      return;
    }
    final cycle = ref.read(cycleProvider);
    ref.read(cycleProvider.notifier).setPeriodReminder(enabled: enabled);
    await NotificationService.reschedulePeriodReminder(cycle, enabled: enabled, daysBefore: cycle.periodReminderDaysBefore);
  }

  Future<void> _adjustPeriodDays(int delta) async {
    final cycle = ref.read(cycleProvider);
    final days = (cycle.periodReminderDaysBefore + delta).clamp(1, 5);
    ref.read(cycleProvider.notifier).setPeriodReminder(enabled: cycle.periodReminderEnabled, daysBefore: days);
    if (cycle.periodReminderEnabled) {
      await NotificationService.reschedulePeriodReminder(ref.read(cycleProvider), enabled: true, daysBefore: days);
    }
  }

  void _showPermissionDenied() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Bildirimlere izin vermedin — telefon ayarlarından açabilirsin.'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cycle = ref.watch(cycleProvider);

    return Scaffold(
      backgroundColor: AppColors.cardCream,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      body: Stack(fit: StackFit.expand, children: [
        const ScreenGradientBackground(),
        SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bildirimler', style: AppTextStyles.heading(fontSize: 28, color: AppColors.ink)),
            const SizedBox(height: 6),
            Text(
              'Sunucu yok — bunlar tamamen telefonunda planlanan yerel hatırlatmalar, hiçbir veri gönderilmez.',
              style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.5), height: 1.4),
            ),
            const SizedBox(height: 24),

            _NotificationCard(
              icon: Icons.edit_calendar_outlined,
              title: 'Günlük Kayıt Hatırlatması',
              subtitle: 'Her gün belirlediğin saatte hatırlat',
              value: cycle.dailyReminderEnabled,
              onChanged: _toggleDaily,
              trailing: cycle.dailyReminderEnabled ? GestureDetector(
                onTap: _pickDailyTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.softPink.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                  child: Text(
                    '${cycle.dailyReminderHour.toString().padLeft(2, '0')}:${cycle.dailyReminderMinute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink.withValues(alpha: 0.7)),
                  ),
                ),
              ) : null,
            ),
            const SizedBox(height: 14),

            _NotificationCard(
              icon: Icons.water_drop_outlined,
              title: 'Adet Tahmini Hatırlatması',
              subtitle: cycle.canPredict
                  ? 'Tahmini adet tarihinden birkaç gün önce hatırlat'
                  : 'En az 3 döngü kaydettiğinde açılabilir',
              value: cycle.periodReminderEnabled,
              onChanged: cycle.canPredict ? _togglePeriod : null,
              trailing: (cycle.periodReminderEnabled && cycle.canPredict) ? Row(mainAxisSize: MainAxisSize.min, children: [
                _StepBtn(icon: Icons.remove_rounded, onTap: () => _adjustPeriodDays(-1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('${cycle.periodReminderDaysBefore} gün önce', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.6))),
                ),
                _StepBtn(icon: Icons.add_rounded, onTap: () => _adjustPeriodDays(1)),
              ]) : null,
            ),
          ]),
        )),
      ]),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.icon, required this.title, required this.subtitle,
    required this.value, required this.onChanged, this.trailing,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 20, color: AppColors.warmOrange),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
            Text(subtitle, style: TextStyle(fontSize: 11.5, color: AppColors.ink.withValues(alpha: 0.55))),
          ])),
          Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.softPink),
        ]),
        if (trailing != null) ...[
          const SizedBox(height: 12),
          trailing!,
        ],
      ]),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26, height: 26,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.softPink.withValues(alpha: 0.2)),
        child: Icon(icon, size: 15, color: AppColors.softPink),
      ),
    );
  }
}
