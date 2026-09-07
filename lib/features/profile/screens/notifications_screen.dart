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
      enabled: enabled, hour: cycle.dailyReminderHour, minute: cycle.dailyReminderMinute, warmTone: cycle.warmNotificationTone,
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
    await NotificationService.setDailyReminder(enabled: true, hour: picked.hour, minute: picked.minute, warmTone: cycle.warmNotificationTone);
  }

  Future<void> _togglePeriod(bool enabled) async {
    if (enabled && !await NotificationService.requestPermission()) {
      _showPermissionDenied();
      return;
    }
    final cycle = ref.read(cycleProvider);
    ref.read(cycleProvider.notifier).setPeriodReminder(enabled: enabled);
    await NotificationService.reschedulePeriodReminder(cycle, enabled: enabled, daysBefore: cycle.periodReminderDaysBefore, warmTone: cycle.warmNotificationTone);
  }

  Future<void> _adjustPeriodDays(int delta) async {
    final cycle = ref.read(cycleProvider);
    final days = (cycle.periodReminderDaysBefore + delta).clamp(1, 5);
    ref.read(cycleProvider.notifier).setPeriodReminder(enabled: cycle.periodReminderEnabled, daysBefore: days);
    if (cycle.periodReminderEnabled) {
      await NotificationService.reschedulePeriodReminder(ref.read(cycleProvider), enabled: true, daysBefore: days, warmTone: cycle.warmNotificationTone);
    }
  }

  // Ton değişince, o an zaten zamanlanmış bildirimler varsa yeni metinle
  // hemen yeniden planlanır — yoksa değişiklik ancak bir sonraki
  // planlamada (ör. saat değiştirince) fark edilirdi.
  Future<void> _toggleTone(bool warm) async {
    ref.read(cycleProvider.notifier).setNotificationTone(warm: warm);
    final cycle = ref.read(cycleProvider);
    if (cycle.dailyReminderEnabled) {
      await NotificationService.setDailyReminder(enabled: true, hour: cycle.dailyReminderHour, minute: cycle.dailyReminderMinute, warmTone: warm);
    }
    if (cycle.periodReminderEnabled) {
      await NotificationService.reschedulePeriodReminder(cycle, enabled: true, daysBefore: cycle.periodReminderDaysBefore, warmTone: warm);
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
      backgroundColor: AppColors.cardOn(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.inkOn(context)),
      ),
      body: Stack(fit: StackFit.expand, children: [
        const ScreenGradientBackground(),
        SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bildirimler', style: AppTextStyles.heading(fontSize: 28, color: AppColors.inkOn(context))),
            const SizedBox(height: 6),
            Text(
              'Sunucu yok — bunlar tamamen telefonunda planlanan yerel hatırlatmalar, hiçbir veri gönderilmez.',
              style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.4),
            ),
            const SizedBox(height: 24),

            _NotificationCard(
              icon: Icons.edit_calendar_outlined,
              title: 'Günlük Kayıt Hatırlatması',
              subtitle: 'Her gün birkaç saniyende bir not bırak — döngünü ve ruh halini zamanla daha net görürsün.',
              value: cycle.dailyReminderEnabled,
              onChanged: _toggleDaily,
              trailing: cycle.dailyReminderEnabled ? GestureDetector(
                onTap: _pickDailyTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.softPink.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                  child: Text(
                    '${cycle.dailyReminderHour.toString().padLeft(2, '0')}:${cycle.dailyReminderMinute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.inkOn(context).withValues(alpha: 0.7)),
                  ),
                ),
              ) : null,
            ),
            const SizedBox(height: 14),

            _NotificationCard(
              icon: Icons.water_drop_outlined,
              title: 'Regl Yaklaşıyor Hatırlatması',
              subtitle: cycle.canPredict
                  ? 'Dönemin yaklaşırken çantana ped atman için seni uyarır'
                  : 'En az 3 döngü kaydettiğinde açılabilir',
              value: cycle.periodReminderEnabled,
              onChanged: cycle.canPredict ? _togglePeriod : null,
              trailing: (cycle.periodReminderEnabled && cycle.canPredict) ? Row(mainAxisSize: MainAxisSize.min, children: [
                _StepBtn(icon: Icons.remove_rounded, semanticLabel: 'Azalt', onTap: () => _adjustPeriodDays(-1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('${cycle.periodReminderDaysBefore} gün önce', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.6))),
                ),
                _StepBtn(icon: Icons.add_rounded, semanticLabel: 'Artır', onTap: () => _adjustPeriodDays(1)),
              ]) : null,
            ),
            const SizedBox(height: 14),

            _ToneCard(warm: cycle.warmNotificationTone, onSelect: _toggleTone),
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
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.inkOn(context))),
            Text(subtitle, style: TextStyle(fontSize: 11.5, color: AppColors.inkOn(context).withValues(alpha: 0.55))),
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

class _ToneCard extends StatelessWidget {
  const _ToneCard({required this.warm, required this.onSelect});
  final bool warm;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.tune_rounded, size: 20, color: AppColors.warmOrange),
          const SizedBox(width: 10),
          Text('Bildirim Tonu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.inkOn(context))),
        ]),
        const SizedBox(height: 6),
        Text(
          'Bildirimin tonunu sana bıraktık 🙂 Tercih senin.',
          style: TextStyle(fontSize: 11.5, color: AppColors.inkOn(context).withValues(alpha: 0.55), height: 1.4),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _ToneOption(label: 'Cana Yakın', selected: warm, onTap: () => onSelect(true))),
          const SizedBox(width: 10),
          Expanded(child: _ToneOption(label: 'Sade', selected: !warm, onTap: () => onSelect(false))),
        ]),
      ]),
    );
  }
}

class _ToneOption extends StatelessWidget {
  const _ToneOption({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.softPink : AppColors.softPink.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.inkOn(context).withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap, required this.semanticLabel});
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(button: true, label: semanticLabel, child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26, height: 26,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.softPink.withValues(alpha: 0.2)),
        child: Icon(icon, size: 15, color: AppColors.softPink),
      ),
    ));
  }
}
