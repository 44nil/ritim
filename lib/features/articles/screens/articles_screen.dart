import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  static const _articles = [
    _ArticleItem(title: 'Döngünü Tanımak', subtitle: '5 dk', emoji: '📖', color: AppColors.phaseMenstruation),
    _ArticleItem(title: 'Beslenme İpuçları', subtitle: '3 dk', emoji: '🥗', color: AppColors.phaseOvulation),
    _ArticleItem(title: 'Ruh Halin Neden Değişiyor?', subtitle: '4 dk', emoji: '🧠', color: AppColors.secondary),
    _ArticleItem(title: 'Egzersiz ve Döngü', subtitle: '4 dk', emoji: '🧘‍♀️', color: AppColors.phaseFollicular),
    _ArticleItem(title: 'Uyku Kaliteni Artır', subtitle: '3 dk', emoji: '😴', color: AppColors.phaseLuteal),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF181820), const Color(0xFF151015)]
                    : [const Color(0xFFEEF2F5), const Color(0xFFFAF6F4)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Okuma\nKöşesi', style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5,
                  )),
                ),
                const SizedBox(height: 4),
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
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2030) : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Öne Çıkan', style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.w700,
                              )),
                              const SizedBox(height: 8),
                              Text('Bedenini\nDinlemeyi Öğren', style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800, height: 1.15,
                              )),
                              const SizedBox(height: 8),
                              Text('6 dk okuma →', style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.w600,
                              )),
                            ],
                          ),
                        ),
                        const Text('🌸', style: TextStyle(fontSize: 52)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _articles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final a = _articles[i];
                      return CleanCard(
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
                              alignment: Alignment.center,
                              child: Text(a.emoji, style: const TextStyle(fontSize: 22)),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleItem {
  const _ArticleItem({required this.title, required this.subtitle, required this.emoji, required this.color});
  final String title, subtitle, emoji;
  final Color color;
}
