import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/bubble_categories.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/staggered_list.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  static const _featured = _ArticleItem(
    title: 'Döngünü Tanımak:\nBaşlangıç Rehberi',
    subtitle: 'Vücudunda her ay neler oluyor? İlk adetten döngü fazlarına, bilmen gereken her şey.',
    readTime: '6 dk',
    level: 'Başlangıç',
    icon: Icons.menu_book_rounded,
    color: AppColors.primary,
    category: 'Döngü',
  );

  static const _articles = [
    _ArticleItem(title: 'Adet Sancısıyla Başa Çıkmanın 5 Yolu', subtitle: 'Kramplar seni yıldırmasın', readTime: '4 dk', level: 'Başlangıç', icon: Icons.favorite_outline_rounded, color: AppColors.phaseMenstruation, category: 'Sağlık'),
    _ArticleItem(title: 'Hormonlar ve Ruh Halin', subtitle: 'Neden bazen çok mutlu, bazen çok üzgün oluyorsun?', readTime: '5 dk', level: 'Başlangıç', icon: Icons.psychology_outlined, color: AppColors.secondary, category: 'Duygular'),
    _ArticleItem(title: 'Döngüne Göre Beslenme', subtitle: 'Her fazda vücudunun ihtiyacı farklı', readTime: '4 dk', level: 'Orta', icon: Icons.restaurant_outlined, color: AppColors.phaseOvulation, category: 'Beslenme'),
    _ArticleItem(title: 'Uyku ve Döngü İlişkisi', subtitle: 'Neden bazı gecelerde uyuyamıyorsun?', readTime: '3 dk', level: 'Başlangıç', icon: Icons.nightlight_outlined, color: AppColors.phaseLuteal, category: 'Sağlık'),
    _ArticleItem(title: 'Hareket ve Döngü', subtitle: 'Hangi fazda hangi egzersiz ideal?', readTime: '5 dk', level: 'Orta', icon: Icons.self_improvement_outlined, color: AppColors.phaseFollicular, category: 'Egzersiz'),
    _ArticleItem(title: 'PMS Nedir?', subtitle: 'Adet öncesi sendrom hakkında bilmen gerekenler', readTime: '4 dk', level: 'Başlangıç', icon: Icons.info_outline_rounded, color: AppColors.primary, category: 'Döngü'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: isDark ? const Color(0xFF1A1518) : const Color(0xFFF8F3F0)),
          SafeArea(
            child: SingleChildScrollView(
              child: StaggeredList(children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Okuma\nKöşesi', style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Bedenini tanı, kendini keşfet', style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                ),
                const SizedBox(height: 10),

                // Bubble kategoriler
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BubbleCategories(
                    height: 300,
                    categories: [
                      BubbleCategory(label: 'Döngü', color: AppColors.phaseMenstruation, size: 120, offset: const Offset(80, 70)),
                      BubbleCategory(label: 'Duygular', color: AppColors.phaseLuteal, size: 130, offset: const Offset(210, 50)),
                      BubbleCategory(label: 'Beslenme', color: AppColors.phaseOvulation, size: 100, offset: const Offset(310, 110)),
                      BubbleCategory(label: 'Sağlık', color: AppColors.primary, size: 110, offset: const Offset(110, 195)),
                      BubbleCategory(label: 'Egzersiz', color: AppColors.phaseFollicular, size: 95, offset: const Offset(245, 210)),
                      BubbleCategory(label: 'Beden', color: AppColors.secondary, size: 80, offset: const Offset(340, 230)),
                    ],
                    onTap: (category) {
                      // TODO: Kategoriye göre filtreleme
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Bugünün Okuması — koyu hero kart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard.withValues(alpha: 0.9) : AppColors.darkCard,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Bugünün Okuması', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(_featured.level, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.6))),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        Text(_featured.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
                        const SizedBox(height: 8),
                        Text(_featured.subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6), height: 1.4)),
                        const SizedBox(height: 16),
                        Row(children: [
                          Icon(Icons.schedule_rounded, size: 14, color: Colors.white.withValues(alpha: 0.4)),
                          const SizedBox(width: 4),
                          Text(_featured.readTime, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Okumaya Başla →', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Faza özel öneri
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CleanCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.phaseOvulation.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.phaseOvulation),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(
                        'Ovülasyon fazındasın — "Hareket ve Döngü" makalesi sana uygun!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.3, fontSize: 11),
                      )),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),

                // Makale listesi başlığı
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Tüm Makaleler', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 12),

                // Makale kartları
                ..._articles.map((a) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: CleanCard(
                    onTap: () {},
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: a.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Icon(a.icon, size: 22, color: a.color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(a.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(a.subtitle, style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: a.color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
                            child: Text(a.category, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: a.color)),
                          ),
                          const SizedBox(width: 8),
                          Text(a.readTime, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
                          const SizedBox(width: 8),
                          Text(a.level, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
                        ]),
                      ])),
                      Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                    ]),
                  ),
                )),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleItem {
  const _ArticleItem({required this.title, required this.subtitle, required this.readTime, required this.level, required this.icon, required this.color, required this.category});
  final String title, subtitle, readTime, level, category;
  final IconData icon;
  final Color color;
}
