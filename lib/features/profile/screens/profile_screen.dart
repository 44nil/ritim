import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [AppColors.primary.withValues(alpha: 0.15), const Color(0xFF1A151E)]
                    : [const Color(0xFFFAE8F2), const Color(0xFFFFF8F6)],
                stops: const [0.0, 0.45],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
              child: Column(
                children: [
                  const SizedBox(height: AppConstants.paddingL),

                  // Avatar
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          AppColors.secondary.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text('E', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Ela', style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
                  Text(
                    '14 yaşında',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),

                  // İstatistik kartları
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          emoji: '📅',
                          value: '3',
                          label: 'Ay takip',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          emoji: '🔥',
                          value: '12',
                          label: 'Gün seri',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          emoji: '🏆',
                          value: '240',
                          label: 'Quiz puan',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingL),

                  // Ayarlar
                  _SettingsGroup(
                    title: 'Hesap',
                    items: [
                      _SettingsRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Profili Düzenle',
                        onTap: () {},
                      ),
                      _SettingsRow(
                        icon: Icons.notifications_outlined,
                        label: 'Bildirimler',
                        onTap: () {},
                      ),
                      _SettingsRow(
                        icon: Icons.lock_outline_rounded,
                        label: 'Gizlilik',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),

                  _SettingsGroup(
                    title: 'Uygulama',
                    items: [
                      _SettingsRow(
                        icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        label: 'Görünüm',
                        trailing: Text(isDark ? 'Koyu' : 'Açık'),
                        onTap: () {
                          ref.read(themeModeProvider.notifier).state =
                              isDark ? ThemeMode.light : ThemeMode.dark;
                        },
                      ),
                      _SettingsRow(
                        icon: Icons.language_rounded,
                        label: 'Dil',
                        trailing: const Text('Türkçe'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),

                  // Ebeveyn paneli
                  GlassCard(
                    onTap: () => context.pushNamed(RouteNames.parentLogin),
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          ),
                          child: const Icon(Icons.shield_outlined,
                              color: AppColors.secondary, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ebeveyn Paneli',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Ebeveyn girişi ile erişin',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.emoji, required this.value, required this.label});
  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          )),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});
  final String title;
  final List<_SettingsRow> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    Divider(
                      height: 0.5,
                      indent: 52,
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: theme.textTheme.bodyMedium),
            ),
            if (trailing != null)
              DefaultTextStyle(
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                child: trailing!,
              ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
