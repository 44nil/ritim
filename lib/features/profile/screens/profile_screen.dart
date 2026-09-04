import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/staggered_list.dart';
import '../../../shared/widgets/screen_gradient_background.dart';
import '../../../core/providers/cycle_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userName = ref.watch(cycleProvider).userName;

    return Scaffold(
      backgroundColor: AppColors.cardCream,
      body: Stack(
        children: [
          const ScreenGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StaggeredList(children: [
                const SizedBox(height: 24),

                Center(child: Column(children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: AppColors.softPink.withValues(alpha: 0.3), width: 3),
                    ),
                    child: Center(child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.ink))),
                  ),
                  const SizedBox(height: 12),
                  Text(userName, style: AppTextStyles.heading(fontSize: 24, color: AppColors.ink)),
                ])),
                const SizedBox(height: 20),

                // İstatistikler
                Row(children: [
                  _StatMini(value: '3', label: 'Ay', icon: Icons.calendar_month_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  _StatMini(value: '12', label: 'Seri', icon: Icons.local_fire_department_outlined, color: AppColors.tertiary),
                  const SizedBox(width: 8),
                  _StatMini(value: '240', label: 'Puan', icon: Icons.emoji_events_outlined, color: AppColors.secondary),
                ]),
                const SizedBox(height: 20),

                // Öğrenme İlerlemesi
                Text('Öğrenme İlerlemen', style: AppTextStyles.heading(fontSize: 18, color: AppColors.ink)),
                const SizedBox(height: 12),
                CleanCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(children: [
                    _ProgressRow(label: 'Quiz', value: 7, total: 26, color: AppColors.primary),
                    const SizedBox(height: 12),
                    _ProgressRow(label: 'Makale', value: 4, total: 12, color: AppColors.phaseFollicular),
                    const SizedBox(height: 12),
                    _ProgressRow(label: 'Kayıt Günü', value: 18, total: 30, color: AppColors.phaseMenstruation),
                  ]),
                ),
                const SizedBox(height: 20),

                // Rozetler
                Text('Rozetlerin', style: AppTextStyles.heading(fontSize: 18, color: AppColors.ink)),
                const SizedBox(height: 12),
                Row(children: [
                  _Badge(icon: Icons.water_drop_rounded, label: 'İlk Kayıt', earned: true, color: AppColors.phaseMenstruation),
                  const SizedBox(width: 8),
                  _Badge(icon: Icons.local_fire_department_rounded, label: '7 Gün Seri', earned: true, color: AppColors.tertiary),
                  const SizedBox(width: 8),
                  _Badge(icon: Icons.school_rounded, label: '5 Quiz', earned: true, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  _Badge(icon: Icons.auto_stories_rounded, label: '10 Makale', earned: false, color: AppColors.phaseFollicular),
                ]),
                const SizedBox(height: 20),

                // Ayarlar
                _SettingsGroup(title: 'Hesap', items: [
                  _SettingsRow(icon: Icons.person_outline_rounded, label: 'Profili Düzenle', onTap: () {}),
                  _SettingsRow(icon: Icons.notifications_none_rounded, label: 'Bildirimler', onTap: () {}),
                  _SettingsRow(icon: Icons.lock_outline_rounded, label: 'Gizlilik', onTap: () => context.pushNamed(RouteNames.privacyPolicy)),
                ]),
                const SizedBox(height: 12),
                _SettingsGroup(title: 'Uygulama', items: [
                  _SettingsRow(
                    icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    label: 'Görünüm',
                    trailing: Text(isDark ? 'Koyu' : 'Açık'),
                    onTap: () => ref.read(themeModeProvider.notifier).state = isDark ? ThemeMode.light : ThemeMode.dark,
                  ),
                  _SettingsRow(icon: Icons.language_rounded, label: 'Dil', trailing: const Text('Türkçe'), onTap: () {}),
                ]),
                const SizedBox(height: 12),
                _SettingsGroup(title: 'Veri', items: [
                  _SettingsRow(
                    icon: Icons.delete_outline_rounded,
                    label: 'Tüm Verilerimi Sil',
                    color: AppColors.error,
                    onTap: () => _confirmDeleteAllData(context, ref),
                  ),
                ]),
                const SizedBox(height: 12),

                // Ebeveyn paneli
                CleanCard(
                  onTap: () => context.pushNamed(RouteNames.parentLogin),
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.shield_outlined, color: AppColors.secondary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Ebeveyn Paneli', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('Ebeveyn girişi ile erişin', style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 11)),
                    ])),
                    Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                  ]),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// Cihazdaki şifreli kaydı gerçekten siler — uygulamayı silmek yeterli
// değildir çünkü iOS'ta Keychain kalıcıdır (bkz. cycle_storage_service.dart).
void _confirmDeleteAllData(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Tüm verilerini sil?'),
      content: const Text(
        'Döngü kayıtların, notların ve ayarların cihazından kalıcı olarak '
        'silinir. Bu işlem geri alınamaz.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
        TextButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await ref.read(cycleProvider.notifier).deleteAll();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Tüm verilerin silindi'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.error,
              ));
            }
          },
          child: Text('Evet, Sil', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}

class _StatMini extends StatelessWidget {
  const _StatMini({required this.value, required this.label, required this.icon, required this.color});
  final String value, label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(child: CleanCard(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
        Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
      ]),
    ));
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.label, required this.value, required this.total, required this.color});
  final String label;
  final int value, total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
        const Spacer(),
        Text('$value/$total', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: value / total,
          backgroundColor: color.withValues(alpha: 0.1),
          color: color,
          minHeight: 5,
        ),
      ),
    ]);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.earned, required this.color});
  final IconData icon;
  final String label;
  final bool earned;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(child: CleanCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Opacity(
        opacity: earned ? 1.0 : 0.3,
        child: Column(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: earned ? color.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: earned ? color : Colors.grey),
          ),
          const SizedBox(height: 6),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(fontSize: 9, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ),
    ));
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});
  final String title;
  final List<_SettingsRow> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(title, style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.w600))),
      CleanCard(
        padding: EdgeInsets.zero,
        child: Column(children: items.asMap().entries.map((e) => Column(children: [
          e.value,
          if (e.key < items.length - 1)
            Divider(height: 0.5, indent: 52, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        ])).toList()),
      ),
    ]);
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.label, required this.onTap, this.trailing, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  // Belirtilirse (ör. yıkıcı bir eylem için) satırı bu renkte vurgular ve
  // gezinme çağrışımı yapan ok ikonunu gizler — bu bir sayfaya gitmiyor.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(onTap: onTap, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Icon(icon, size: 20, color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: color, fontWeight: color != null ? FontWeight.w600 : null))),
        if (trailing != null) DefaultTextStyle(
          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
          child: trailing!),
        const SizedBox(width: 4),
        if (color == null)
          Icon(Icons.chevron_right_rounded, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
      ]),
    ));
  }
}
