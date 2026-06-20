import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';

/// Profil ekranı — kullanıcı ayarları ve ebeveyn paneline erişim.
/// TODO: Backend entegrasyonu — kullanıcı profili ve tercihler API'den gelecek.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar ve isim bölümü
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingXL),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_rounded,
                      size: 44,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // TODO: Backend entegrasyonu — kullanıcı adı
                  Text('Kullanıcı Adı', style: theme.textTheme.headlineMedium),
                  Text(
                    '14 yaşında',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Ayarlar listesi
            _SettingsSection(
              title: 'Hesap',
              items: [
                _SettingsItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profili Düzenle',
                  onTap: () {/* TODO */},
                ),
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  label: 'Bildirim Ayarları',
                  onTap: () {/* TODO */},
                ),
                _SettingsItem(
                  icon: Icons.lock_outline_rounded,
                  label: 'Gizlilik',
                  onTap: () {/* TODO */},
                ),
              ],
            ),

            _SettingsSection(
              title: 'Uygulama',
              items: [
                _SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Görünüm',
                  trailing: const Text('Sistem'),
                  onTap: () {/* TODO */},
                ),
                _SettingsItem(
                  icon: Icons.language_rounded,
                  label: 'Dil',
                  trailing: const Text('Türkçe'),
                  onTap: () {/* TODO */},
                ),
              ],
            ),

            // Ebeveyn paneli erişimi — ayrı akış
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
                vertical: AppConstants.paddingS,
              ),
              child: OutlinedButton.icon(
                onPressed: () => context.pushNamed(RouteNames.parentLogin),
                icon: const Icon(Icons.shield_outlined),
                label: const Text('Ebeveyn Paneline Geç'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.secondary,
                  side: BorderSide(color: theme.colorScheme.secondary),
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.items});
  final String title;
  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: AppConstants.paddingS,
            ),
            child: Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(child: Column(children: items)),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
      title: Text(label, style: theme.textTheme.bodyMedium),
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
      onTap: onTap,
    );
  }
}
