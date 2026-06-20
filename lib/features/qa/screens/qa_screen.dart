import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/mesh_gradient_bg.dart';
import '../../../shared/widgets/staggered_list.dart';

class QaScreen extends StatelessWidget {
  const QaScreen({super.key});

  static const _questions = [
    _FaqItem(question: 'Adet döngüsü nedir?', answer: 'Vücudunun her ay hamileliğe hazırlanma sürecidir. Ortalama 28 gün sürer ama 21-35 gün arası normaldir.', icon: Icons.water_drop_outlined, color: AppColors.phaseMenstruation),
    _FaqItem(question: 'İlk adetim ne zaman olur?', answer: 'Çoğu kız ilk adetini 10-15 yaş arasında görür. Bu tamamen kişiye göre değişir.', icon: Icons.eco_outlined, color: AppColors.phaseOvulation),
    _FaqItem(question: 'Kramp normal mi?', answer: 'Hafif kramplar çok yaygın ve normaldir. Sıcak su torbası ve hafif egzersiz yardımcı olabilir.', icon: Icons.favorite_outline_rounded, color: AppColors.primary),
    _FaqItem(question: 'Ruh halim neden değişiyor?', answer: 'Döngü boyunca hormon seviyelerin değişir. Bu ruh hali değişimlerine neden olabilir — tamamen normal!', icon: Icons.psychology_outlined, color: AppColors.secondary),
    _FaqItem(question: 'Adet döneminde spor yapabilir miyim?', answer: 'Evet! Hafif egzersiz aslında kramplara iyi gelir. Yürüyüş, yoga veya yüzme harika seçenekler.', icon: Icons.directions_run_rounded, color: AppColors.phaseFollicular),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          MeshGradientBg(isDark: isDark),
          SafeArea(
            child: SingleChildScrollView(
              child: StaggeredList(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Soru &\nCevap', style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Merak ettiğin her şey', style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    )),
                  ),
                  const SizedBox(height: 20),
                  ..._questions.map((q) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: _FaqCard(item: q),
                  )),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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

    return CleanCard(
      onTap: () => setState(() => _expanded = !_expanded),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: widget.item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.item.icon, size: 18, color: widget.item.color),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(widget.item.question, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: AppConstants.animDurationFast,
                child: Icon(Icons.expand_more_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12, left: 48),
              child: Text(widget.item.answer, style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.5,
              )),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: AppConstants.animDurationNormal,
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer, required this.icon, required this.color});
  final String question, answer;
  final IconData icon;
  final Color color;
}
