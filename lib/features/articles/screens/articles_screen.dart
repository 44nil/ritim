import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/screen_gradient_background.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  String _selectedCategory = 'Tümü';

  static const _categories = ['Tümü', 'Döngü', 'Duygular', 'Beslenme', 'Sağlık', 'Egzersiz'];

  static const _featured = _ArticleItem(
    title: 'Döngünü Tanımak:\nBaşlangıç Rehberi',
    subtitle: 'Vücudunda her ay neler oluyor? İlk adetten döngü fazlarına, bilmen gereken her şey.',
    readTime: '6 dk',
    level: 'Başlangıç',
    icon: Icons.menu_book_rounded,
    category: 'Döngü',
  );

  static const _articles = [
    _ArticleItem(title: 'Adet Sancısıyla Başa Çıkmanın 5 Yolu', subtitle: 'Kramplar seni yıldırmasın', readTime: '4 dk', level: 'Başlangıç', icon: Icons.favorite_outline_rounded, category: 'Sağlık'),
    _ArticleItem(title: 'Hormonlar ve Ruh Halin', subtitle: 'Neden bazen çok mutlu, bazen çok üzgün oluyorsun?', readTime: '5 dk', level: 'Başlangıç', icon: Icons.psychology_outlined, category: 'Duygular'),
    _ArticleItem(title: 'Döngüne Göre Beslenme', subtitle: 'Her fazda vücudunun ihtiyacı farklı', readTime: '4 dk', level: 'Orta', icon: Icons.restaurant_outlined, category: 'Beslenme'),
    _ArticleItem(title: 'Uyku ve Döngü İlişkisi', subtitle: 'Neden bazı gecelerde uyuyamıyorsun?', readTime: '3 dk', level: 'Başlangıç', icon: Icons.nightlight_outlined, category: 'Sağlık'),
    _ArticleItem(title: 'Hareket ve Döngü', subtitle: 'Hangi fazda hangi egzersiz ideal?', readTime: '5 dk', level: 'Orta', icon: Icons.self_improvement_outlined, category: 'Egzersiz'),
    _ArticleItem(title: 'PMS Nedir?', subtitle: 'Adet öncesi sendrom hakkında bilmen gerekenler', readTime: '4 dk', level: 'Başlangıç', icon: Icons.info_outline_rounded, category: 'Döngü'),
  ];

  List<_ArticleItem> get _filtered {
    if (_selectedCategory == 'Tümü') return _articles;
    return _articles.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardCream,
      body: Stack(
        children: [
          const ScreenGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Okuma\nKöşesi', style: AppTextStyles.heading(fontSize: 32, color: AppColors.ink)),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('bedenini tanı, kendini keşfet.', style: AppTextStyles.accent(fontSize: 18, color: AppColors.softPink)),
                  ),
                  const SizedBox(height: 20),

                  // Kategori chip'leri
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: _categories.map((c) {
                        final isActive = c == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedCategory = c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.ink : Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(c, style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : AppColors.ink.withValues(alpha: 0.5),
                              )),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hero kart
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.softPink.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Bugünün Okuması', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.5))),
                        const SizedBox(height: 8),
                        Text(_featured.title, style: AppTextStyles.heading(fontSize: 22, color: AppColors.ink)),
                        const SizedBox(height: 8),
                        Text(_featured.subtitle, style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.5), height: 1.5)),
                        const SizedBox(height: 16),
                        Row(children: [
                          Text(_featured.readTime, style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.4))),
                          const Spacer(),
                          Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(22)),
                            alignment: Alignment.center,
                            child: Text('Okumaya Başla', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ]),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Tüm Makaleler', style: AppTextStyles.heading(fontSize: 20, color: AppColors.ink)),
                  ),
                  const SizedBox(height: 14),

                  ..._filtered.map((a) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardCream,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.warmOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(a.icon, size: 24, color: AppColors.ink.withValues(alpha: 0.6)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(a.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(a.subtitle, style: TextStyle(fontSize: 11, color: AppColors.ink.withValues(alpha: 0.4)), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(children: [
                            Text(a.category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.warmOrange)),
                            const SizedBox(width: 10),
                            Text(a.readTime, style: TextStyle(fontSize: 10, color: AppColors.ink.withValues(alpha: 0.3))),
                          ]),
                        ])),
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.ink),
                          child: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                        ),
                      ]),
                    ),
                  )),
                  const SizedBox(height: 110),
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
  const _ArticleItem({required this.title, required this.subtitle, required this.readTime, required this.level, required this.icon, required this.category});
  final String title, subtitle, readTime, level, category;
  final IconData icon;
}
