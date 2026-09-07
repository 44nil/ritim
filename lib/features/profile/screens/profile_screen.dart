import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/router/route_names.dart';
import '../../../core/services/cycle_storage_service.dart';
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
    final cycle = ref.watch(cycleProvider);
    final userName = cycle.userName;

    // Android'de (ve iCloud Anahtarlığı kapalı iOS'ta) otomatik bir
    // senkronizasyon olmadığı için, kullanıcı hiç yedeklememişse ya da
    // uzun süredir yedeklememişse nazikçe hatırlatıyoruz — zorlamadan,
    // sadece görünür kılarak.
    final daysSinceExport = cycle.lastExportDate == null
        ? null
        : DateTime.now().difference(cycle.lastExportDate!).inDays;
    final exportOverdue = daysSinceExport == null || daysSinceExport >= 30;
    final exportSubtitle = daysSinceExport == null
        ? 'Hiç yedeklenmedi'
        : daysSinceExport == 0
            ? 'Bugün'
            : '$daysSinceExport gün önce';

    return Scaffold(
      backgroundColor: AppColors.cardOn(context),
      body: Stack(
        fit: StackFit.expand,
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
                      color: AppColors.cardOn(context),
                      border: Border.all(color: AppColors.softPink.withValues(alpha: 0.3), width: 3),
                    ),
                    child: Center(child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : '?', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.inkOn(context)))),
                  ),
                  const SizedBox(height: 12),
                  Text(userName, style: AppTextStyles.heading(fontSize: 24, color: AppColors.inkOn(context))),
                ])),
                const SizedBox(height: 20),

                // İstatistikler — gerçek cycleProvider verisinden hesaplanır
                // (eskiden "3 Ay / 12 Seri / 240 Puan" gibi sabit/sahte
                // değerlerdi, hiç kimse hiçbir şey yapmadan bunları görürdü).
                Row(children: [
                  _StatMini(value: '${cycle.currentStreak}', label: 'Gün Seri', icon: Icons.local_fire_department_outlined, color: AppColors.tertiary),
                  const SizedBox(width: 8),
                  _StatMini(value: '${cycle.logs.length}', label: 'Kayıt Günü', icon: Icons.edit_calendar_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  _StatMini(value: '${cycle.periods.length}', label: 'Döngü', icon: Icons.water_drop_outlined, color: AppColors.secondary),
                ]),
                const SizedBox(height: 20),

                // Ayarlar
                _SettingsGroup(title: 'Hesap', items: [
                  _SettingsRow(icon: Icons.person_outline_rounded, label: 'Profili Düzenle', onTap: () => context.pushNamed(RouteNames.editProfile)),
                  _SettingsRow(icon: Icons.notifications_none_rounded, label: 'Bildirimler', onTap: () => context.pushNamed(RouteNames.notifications)),
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
                  // onTap yok — henüz çok dillilik desteklenmiyor, bu satır
                  // sadece bilgi amaçlı (yanlış gezinme çağrışımı yapmasın diye).
                  _SettingsRow(icon: Icons.language_rounded, label: 'Dil', trailing: const Text('Türkçe')),
                ]),
                const SizedBox(height: 12),
                _SettingsGroup(title: 'Veri', items: [
                  _SettingsRow(
                    icon: Icons.ios_share_rounded,
                    label: 'Verilerimi Dışa Aktar',
                    trailing: Text(
                      exportSubtitle,
                      style: TextStyle(
                        fontWeight: exportOverdue ? FontWeight.w700 : null,
                        color: exportOverdue ? AppColors.warning : null,
                      ),
                    ),
                    onTap: () => _exportData(context, ref, cycle),
                  ),
                  _SettingsRow(
                    icon: Icons.settings_backup_restore_rounded,
                    label: 'Yedekten Geri Yükle',
                    onTap: () => _importData(context, ref),
                  ),
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
                  onTap: () => context.pushNamed(RouteNames.parentQr),
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
                      Text('Veline göstermek için QR oluştur', style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 11)),
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

// Android'de Keystore anahtarları cihaz dışına çıkamadığı için (iOS'taki
// iCloud Anahtarlık senkronizasyonunun aksine) otomatik bir "yeni telefonda
// geri gel" yolu yok — bu, kullanıcının kendi elleriyle alabileceği bir
// yedek (Drive, e-posta, Dosyalar'a kaydedebilir).
Future<void> _exportData(BuildContext context, WidgetRef ref, CycleState cycle) async {
  final file = await CycleStorageService.exportToTempFile(cycle);
  final result = await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], text: 'Ritim yedeğim'));
  // Sadece kullanıcı gerçekten bir yere kaydettiyse/gönderdiyse "yedeklendi"
  // sayıyoruz — paylaşım sayfasını kapatıp vazgeçtiyse hatırlatma kalmalı.
  if (result.status == ShareResultStatus.success) {
    ref.read(cycleProvider.notifier).recordExport();
  }
}

Future<void> _importData(BuildContext context, WidgetRef ref) async {
  final picked = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
  if (picked.isEmpty) return;
  final path = picked.first.path;
  if (path == null || !context.mounted) return;

  final imported = await CycleStorageService.importFromFile(File(path));
  if (!context.mounted) return;
  if (imported == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Bu dosya okunamadı — geçerli bir Ritim yedeği değil'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.error,
    ));
    return;
  }

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Yedekten geri yükle?'),
      content: const Text(
        'Bu, cihazındaki mevcut verinin üzerine yazar. Şu anki verin kaybolur.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            ref.read(cycleProvider.notifier).restore(imported);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Yedek geri yüklendi'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.softPink,
            ));
          },
          child: Text('Evet, Geri Yükle', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
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
        Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.55))),
      ]),
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
          color: theme.colorScheme.onSurface.withValues(alpha: 0.55), fontWeight: FontWeight.w600))),
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
  const _SettingsRow({required this.icon, required this.label, this.onTap, this.trailing, this.color});
  final IconData icon;
  final String label;
  // Null bırakılırsa satır sadece bilgi amaçlıdır — dokunma efekti ve
  // "buraya gidilir" çağrışımı yapan ok ikonu olmadan gösterilir (ör. tek
  // desteklenen dili gösteren "Dil" satırı, henüz çok dillilik yok).
  final VoidCallback? onTap;
  final Widget? trailing;
  // Belirtilirse (ör. yıkıcı bir eylem için) satırı bu renkte vurgular.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showChevron = onTap != null && color == null;
    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Icon(icon, size: 20, color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: color, fontWeight: color != null ? FontWeight.w600 : null))),
        if (trailing != null) DefaultTextStyle(
          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.55)),
          child: trailing!),
        const SizedBox(width: 4),
        if (showChevron)
          Icon(Icons.chevron_right_rounded, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
      ]),
    );
    return onTap != null ? InkWell(onTap: onTap, child: row) : row;
  }
}
