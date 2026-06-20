import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedAnswer;
  bool _answered = false;

  static const _correctAnswer = 1;

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
    });
  }

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
                    ? [AppColors.tertiary.withValues(alpha: 0.12), const Color(0xFF1A151E)]
                    : [const Color(0xFFF5EBE0), const Color(0xFFFFF8F6)],
                stops: const [0.0, 0.5],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppConstants.paddingM),
                  Text(
                    'Quiz',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Öğrenirken eğlen',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),

                  // Seri + puan
                  GlassCard(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3 Günlük Seri!',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Bugün de bir quiz çöz',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '240',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'puan',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),

                  // Günün sorusu
                  Text(
                    'Günün Sorusu',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingM),

                  GlassCard(
                    padding: const EdgeInsets.all(AppConstants.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                              ),
                              child: Text(
                                'Döngü Bilgisi',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '+20 puan',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ortalama bir adet döngüsü kaç gün sürer?',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Cevap seçenekleri
                        ...[
                          '14 gün',
                          '28 gün',
                          '35 gün',
                          '45 gün',
                        ].asMap().entries.map((e) {
                          final i = e.key;
                          final text = e.value;
                          final isSelected = _selectedAnswer == i;
                          final isCorrect = i == _correctAnswer;

                          Color bgColor;
                          Color borderColor;
                          if (!_answered) {
                            bgColor = theme.colorScheme.surfaceContainerHighest;
                            borderColor = Colors.transparent;
                          } else if (isCorrect) {
                            bgColor = AppColors.success.withValues(alpha: 0.15);
                            borderColor = AppColors.success;
                          } else if (isSelected && !isCorrect) {
                            bgColor = AppColors.error.withValues(alpha: 0.15);
                            borderColor = AppColors.error;
                          } else {
                            bgColor = theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5);
                            borderColor = Colors.transparent;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () => _selectAnswer(i),
                              child: AnimatedContainer(
                                duration: AppConstants.animDurationFast,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      String.fromCharCode(65 + i),
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(text, style: theme.textTheme.bodyMedium),
                                    const Spacer(),
                                    if (_answered && isCorrect)
                                      const Icon(Icons.check_circle_rounded,
                                          color: AppColors.success, size: 22),
                                    if (_answered && isSelected && !isCorrect)
                                      const Icon(Icons.cancel_rounded,
                                          color: AppColors.error, size: 22),
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
                    const SizedBox(height: AppConstants.paddingM),
                    GlassCard(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      tintColor: AppColors.success.withValues(alpha: 0.06),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Ortalama döngü 28 gün sürer ama 21-35 gün arası tamamen normal!',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAnswer = null;
                            _answered = false;
                          });
                          // TODO: Backend entegrasyonu — sonraki soru
                        },
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
