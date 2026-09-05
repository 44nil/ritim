import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/screen_gradient_background.dart';
import '../data/article_data.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardCream,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      body: Stack(
        children: [
          const ScreenGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.warmOrange.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      article.icon,
                      size: 28,
                      color: AppColors.ink.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.category,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        article.readTime,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.ink.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: AppTextStyles.heading(
                      fontSize: 26,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ..._buildSections(article.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Başlıklı bölümler (adım listeleri) numaralı, renkli kartlara dönüşür;
/// başlıksız bölümler (giriş/kapanış paragrafları) düz akan metin olarak
/// kalır — kullanıcı "çok düz duruyor" geri bildirimi üzerine seçildi.
List<Widget> _buildSections(List<ArticleSection> sections) {
  var stepIndex = 0;
  return sections.map((section) {
    if (section.heading == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Text(
          section.text,
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: AppColors.ink.withValues(alpha: 0.75),
          ),
        ),
      );
    }
    final tint = stepIndex.isEven ? AppColors.softPink : AppColors.warmOrange;
    stepIndex++;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _StepCard(
        number: stepIndex,
        tint: tint,
        heading: section.heading!,
        text: section.text,
      ),
    );
  }).toList();
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.tint,
    required this.heading,
    required this.text,
  });
  final int number;
  final Color tint;
  final String heading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  heading,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: AppColors.ink.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
