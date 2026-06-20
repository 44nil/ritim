import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selected;
  bool _answered = false;
  static const _correct = 1;

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
                    ? [const Color(0xFF201818), const Color(0xFF151015)]
                    : [const Color(0xFFF5EBE0), const Color(0xFFFAF6F4)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text('Quiz', style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800, letterSpacing: -0.5,
                  )),
                  const SizedBox(height: 4),
                  Text('Öğrenirken eğlen', style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  )),
                  const SizedBox(height: 20),

                  // Seri kartı
                  CleanCard(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.local_fire_department_rounded, size: 24, color: AppColors.tertiary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('3 Günlük Seri', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              Text('Bugün de devam et!', style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              )),
                            ],
                          ),
                        ),
                        Text('240', style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800, color: AppColors.tertiary,
                        )),
                        const SizedBox(width: 4),
                        Text('puan', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.tertiary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('Günün Sorusu', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),

                  // Soru
                  CleanCard(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ortalama bir adet döngüsü kaç gün sürer?',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, height: 1.3),
                        ),
                        const SizedBox(height: 20),

                        ...['14 gün', '28 gün', '35 gün', '45 gün'].asMap().entries.map((e) {
                          final i = e.key;
                          final isSelected = _selected == i;
                          final isCorrect = i == _correct;

                          Color bg;
                          Color border;
                          if (!_answered) {
                            bg = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
                            border = Colors.transparent;
                          } else if (isCorrect) {
                            bg = AppColors.success.withValues(alpha: 0.12);
                            border = AppColors.success;
                          } else if (isSelected) {
                            bg = AppColors.error.withValues(alpha: 0.12);
                            border = AppColors.error;
                          } else {
                            bg = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
                            border = Colors.transparent;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: _answered ? null : () => setState(() { _selected = i; _answered = true; }),
                              child: AnimatedContainer(
                                duration: AppConstants.animDurationFast,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: border, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    Text('${String.fromCharCode(65 + i)}  ', style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                    )),
                                    Text(e.value, style: theme.textTheme.bodyMedium),
                                    const Spacer(),
                                    if (_answered && isCorrect)
                                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                                    if (_answered && isSelected && !isCorrect)
                                      const Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  if (_answered) ...[
                    const SizedBox(height: 14),
                    CleanCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, size: 20, color: AppColors.phaseOvulation),
                          const SizedBox(width: 12),
                          Expanded(child: Text(
                            'Ortalama döngü 28 gün sürer ama 21-35 gün arası tamamen normal!',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.4,
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => setState(() { _selected = null; _answered = false; }),
                        child: const Text('Sonraki Soru →'),
                      ),
                    ),
                  ],
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
