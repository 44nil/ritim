import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  static const _articles = [
    _ArticleItem(
      title: 'Döngünü Tanımak: Başlangıç Rehberi',
      subtitle: '5 dk okuma',
      emoji: '📖',
      category: 'Döngü',
      color: AppColors.phaseMenstruation,
    ),
    _ArticleItem(
      title: 'Adet Döneminde Beslenme İpuçları',
      subtitle: '3 dk okuma',
      emoji: '🥗',
      category: 'Beslenme',
      color: AppColors.phaseOvulation,
    ),
    _ArticleItem(
      title: 'Ruh Halin Neden Değişiyor?',
      subtitle: '4 dk okuma',
      emoji: '🧠',
      category: 'Psikoloji',
      color: AppColors.secondary,
    ),
    _ArticleItem(
      title: 'Egzersiz ve Döngü: Ne Zaman, Nasıl?',
      subtitle: '4 dk okuma',
      emoji: '🧘‍♀️',
      category: 'Egzersiz',
      color: AppColors.phaseFollicular,
    ),
    _ArticleItem(
      title: 'Uyku Kaliteni Artırmanın 5 Yolu',
      subtitle: '3 dk okuma',
      emoji: '😴',
      category: 'Sağlık',
      color: AppColors.phaseLuteal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                    ? [AppColors.phaseFollicular.withValues(alpha: 0.1), const Color(0xFF1A151E)]
                    : [const Color(0xFFE8F0F8), const Color(0xFFFFF8F6)],
                stops: const [0.0, 0.5],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingM, AppConstants.paddingM,
                    AppConstants.paddingM, 0,
                  ),
                  child: Text(
                    'Makaleler',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                  child: Text(
                    'Sana özel seçilmiş bilgiler',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Kategoriler
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                    children: ['Tümü', 'Döngü', 'Beslenme', 'Psikoloji', 'Egzersiz', 'Sağlık']
                        .map((c) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(c),
                                selected: c == 'Tümü',
                                onSelected: (_) {},
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Öne çıkan makale — büyük kart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppConstants.paddingL),
                    onTap: () {
                      // TODO: Backend entegrasyonu — makale detay
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                                ),
                                child: Text(
                                  'Öne Çıkan',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Bedenini Dinlemeyi Öğren',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Döngünün her fazında vücudun sana ne söylüyor?',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '6 dk okuma →',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('🌸', style: TextStyle(fontSize: 56)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Makale listesi
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                    itemCount: _articles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _ArticleCard(article: _articles[i]),
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

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final _ArticleItem article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      onTap: () {
        // TODO: Backend entegrasyonu — makale detay sayfası
      },
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: article.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            alignment: Alignment.center,
            child: Text(article.emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: article.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.category,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: article.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      article.subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
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
    );
  }
}

class _ArticleItem {
  const _ArticleItem({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.category,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String emoji;
  final String category;
  final Color color;
}
