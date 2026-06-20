import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/mesh_gradient_bg.dart';
import '../../../shared/widgets/staggered_list.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          MeshGradientBg(isDark: isDark),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StaggeredList(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryContainer,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                    ),
                    child: const Center(child: Text('E', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.primary))),
                  ),
                  const SizedBox(height: 12),
                  Text('Ela', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text('14 yaşında', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      _Stat(icon: Icons.calendar_month_outlined, value: '3', label: 'Ay', color: AppColors.primary),
                      const SizedBox(width: 10),
                      _Stat(icon: Icons.local_fire_department_outlined, value: '12', label: 'Seri', color: AppColors.tertiary),
                      const SizedBox(width: 10),
                      _Stat(icon: Icons.emoji_events_outlined, value: '240', label: 'Puan', color: AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _Section(title: 'Hesap', children: [
                    _Row(icon: Icons.person_outline_rounded, label: 'Profili Düzenle', onTap: () {}),
                    _Row(icon: Icons.notifications_none_rounded, label: 'Bildirimler', onTap: () {}),
                    _Row(icon: Icons.lock_outline_rounded, label: 'Gizlilik', onTap: () {}),
                  ]),
                  const SizedBox(height: 14),

                  _Section(title: 'Uygulama', children: [
                    _Row(
                      icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      label: 'Görünüm',
                      trailing: Text(isDark ? 'Koyu' : 'Açık'),
                      onTap: () {
                        ref.read(themeModeProvider.notifier).state = isDark ? ThemeMode.light : ThemeMode.dark;
                      },
                    ),
                    _Row(icon: Icons.language_rounded, label: 'Dil', trailing: const Text('Türkçe'), onTap: () {}),
                  ]),
                  const SizedBox(height: 14),

                  CleanCard(
                    onTap: () => context.pushNamed(RouteNames.parentLogin),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.shield_outlined, color: AppColors.secondary, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ebeveyn Paneli', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                              Text('Ebeveyn girişi ile erişin', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
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

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label, required this.color});
  final IconData icon;
  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: CleanCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 6),
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<_Row> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.w600,
          )),
        ),
        CleanCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: children.asMap().entries.map((e) {
              return Column(children: [
                e.value,
                if (e.key < children.length - 1)
                  Divider(height: 0.5, indent: 52, color: Theme.of(e.value.onTap.hashCode > 0 ? context : context).colorScheme.outline.withValues(alpha: 0.1)),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.onTap, this.trailing});
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
            Icon(icon, size: 22, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            if (trailing != null) DefaultTextStyle(style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)), child: trailing!),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
          ],
        ),
      ),
    );
  }
}
