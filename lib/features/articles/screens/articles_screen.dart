import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/floating_particles.dart';
import '../../../shared/widgets/mesh_gradient_bg.dart';
import '../../../shared/widgets/staggered_list.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  static const _articles = [
    _ArticleItem(title: 'Döngünü Tanımak', subtitle: '5 dk', icon: Icons.auto_stories_outlined, color: AppColors.phaseMenstruation),
    _ArticleItem(title: 'Beslenme İpuçları', subtitle: '3 dk', icon: Icons.restaurant_outlined, color: AppColors.phaseOvulation),
    _ArticleItem(title: 'Ruh Halin Neden Değişiyor?', subtitle: '4 dk', icon: Icons.psychology_outlined, color: AppColors.secondary),
    _ArticleItem(title: 'Egzersiz ve Döngü', subtitle: '4 dk', icon: Icons.self_improvement_outlined, color: AppColors.phaseFollicular),
    _ArticleItem(title: 'Uyku Kaliteni Artır', subtitle: '3 dk', icon: Icons.nightlight_outlined, color: AppColors.phaseLuteal),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          MeshGradientBg(isDark: isDark),
          const FloatingParticles(),
          SafeArea(
            child: SingleChildScrollView(
              child: StaggeredList(
                children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Okuma\nKöşesi', style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Sana özel içerikler', style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  )),
                ),
                const SizedBox(height: 20),

                // Öne çıkan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CleanCard(
                    onTap: () {},
                    padding: const EdgeInsets.all(22),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('Öne Çıkan', style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.primary, fontWeight: FontWeight.w700,
                                )),
                              ),
                              const SizedBox(height: 10),
                              Text('Bedenini\nDinlemeyi Öğren', style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800, height: 1.15,
                              )),
                              const SizedBox(height: 8),
                              Text('6 dk okuma', style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              )),
                            ],
                          ),
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.spa_outlined, size: 28, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ..._articles.map((a) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: CleanCard(
                    onTap: () {},
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: a.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(a.icon, size: 22, color: a.color),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                              Text('${a.subtitle} okuma', style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              )),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                      ],
                    ),
                  ),
                )),
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

class _ArticleItem {
  const _ArticleItem({required this.title, required this.subtitle, required this.icon, required this.color});
  final String title, subtitle;
  final IconData icon;
  final Color color;
}
