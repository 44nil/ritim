import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class QaScreen extends StatelessWidget {
  const QaScreen({super.key});

  static const _questions = [
    _FaqItem(
      question: 'Adet döngüsü nedir?',
      answer: 'Adet döngüsü, vücudunun her ay hamileliğe hazırlanma sürecidir. Ortalama 28 gün sürer ama 21-35 gün arası normaldir.',
      category: 'Döngü',
      emoji: '🩸',
    ),
    _FaqItem(
      question: 'İlk adetim ne zaman olur?',
      answer: 'Çoğu kız ilk adetini 10-15 yaş arasında görür. Bu tamamen kişiye göre değişir ve her yaş normaldir.',
      category: 'Beden',
      emoji: '🌱',
    ),
    _FaqItem(
      question: 'Kramp normal mi?',
      answer: 'Hafif kramplar çok yaygın ve normaldir. Sıcak su torbası, hafif egzersiz ve bol su içmek yardımcı olabilir.',
      category: 'Sağlık',
      emoji: '💪',
    ),
    _FaqItem(
      question: 'Ruh halim neden bu kadar değişiyor?',
      answer: 'Döngü boyunca hormon seviyelerin değişir. Bu ruh hali değişimlerine neden olabilir — tamamen normal!',
      category: 'Psikoloji',
      emoji: '🧠',
    ),
    _FaqItem(
      question: 'Adet döneminde spor yapabilir miyim?',
      answer: 'Evet! Hafif egzersiz aslında kramplara iyi gelir. Yürüyüş, yoga veya yüzme harika seçenekler.',
      category: 'Egzersiz',
      emoji: '🏃‍♀️',
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
          // Gradient arka plan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [AppColors.secondary.withValues(alpha: 0.15), const Color(0xFF1A151E)]
                    : [const Color(0xFFEDE8F8), const Color(0xFFFFF8F6)],
                stops: const [0.0, 0.5],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingM, AppConstants.paddingM,
                    AppConstants.paddingM, 0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Soru & Cevap',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GlassCard(
                        padding: const EdgeInsets.all(10),
                        borderRadius: AppConstants.radiusRound,
                        opacity: 0.5,
                        onTap: () {
                          // TODO: Backend entegrasyonu — soru arama
                        },
                        child: Icon(Icons.search_rounded, size: 22,
                          color: theme.colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                  child: Text(
                    'Merak ettiğin soruları keşfet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Kategori chip'leri
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                    children: ['Tümü', 'Döngü', 'Beden', 'Psikoloji', 'Sağlık', 'Egzersiz']
                        .map((cat) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(cat),
                                selected: cat == 'Tümü',
                                onSelected: (_) {},
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // Soru kartları
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                    itemCount: _questions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _FaqCard(item: _questions[i]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Backend entegrasyonu — anonim soru gönder
        },
        icon: const Icon(Icons.help_outline_rounded),
        label: const Text('Soru Sor'),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
      ),
    );
  }
}

class _FaqCard extends StatefulWidget {
  const _FaqCard({required this.item});
  final _FaqItem item;

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      onTap: () => setState(() => _expanded = !_expanded),
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.item.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.item.question,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: AppConstants.animDurationFast,
                child: Icon(
                  Icons.expand_more_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12, left: 36),
              child: Text(
                widget.item.answer,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppConstants.animDurationNormal,
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    required this.question,
    required this.answer,
    required this.category,
    required this.emoji,
  });

  final String question;
  final String answer;
  final String category;
  final String emoji;
}
