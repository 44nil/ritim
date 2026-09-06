import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/screen_gradient_background.dart';
import '../data/quiz_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // "Günün Sorusu" o gün için sabit bir soruyla başlar (tarihe göre seçilir),
  // ama "Sonraki Soru" ile havuzdaki bir sonraki soruya geçilebilir — eskiden
  // tek bir sabit soru vardı ve bu buton sadece cevap durumunu sıfırlayıp
  // aynı soruyu tekrar gösteriyordu (gerçek bir hataydı).
  late int _questionIndex = _dayOfYear(DateTime.now()) % QuizData.questions.length;
  int? _selected;
  bool _answered = false;

  static int _dayOfYear(DateTime date) =>
      date.difference(DateTime(date.year)).inDays;

  void _nextQuestion() {
    setState(() {
      _questionIndex = (_questionIndex + 1) % QuizData.questions.length;
      _selected = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = QuizData.questions[_questionIndex];

    return Scaffold(
      backgroundColor: AppColors.cardOn(context),
      body: Stack(
        fit: StackFit.expand,
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
                    child: Text('Öğren &\nTest Et', style: AppTextStyles.heading(fontSize: 32, color: AppColors.inkOn(context))),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('bilgini sına, döngünü anla.', style: AppTextStyles.accent(fontSize: 18, color: AppColors.softPink)),
                  ),
                  const SizedBox(height: 24),

                  // Günün sorusu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.softPink.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Günün Sorusu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.softPink)),
                        const SizedBox(height: 14),
                        Text(q.question, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.inkOn(context), height: 1.4)),
                        const SizedBox(height: 18),
                        ...q.options.asMap().entries.map((e) {
                          final i = e.key;
                          final isSelected = _selected == i;
                          final isCorrect = i == q.correctIndex;

                          Color bg; Color textCol;
                          if (!_answered) {
                            bg = Colors.white.withValues(alpha: 0.85);
                            textCol = AppColors.inkOn(context);
                          } else if (isCorrect) {
                            bg = const Color(0xFFD4EDDA);
                            textCol = const Color(0xFF155724);
                          } else if (isSelected) {
                            bg = AppColors.cardPinkOn(context);
                            textCol = AppColors.inkOn(context).withValues(alpha: 0.5);
                          } else {
                            bg = AppColors.cardOn(context).withValues(alpha: 0.5);
                            textCol = AppColors.inkOn(context).withValues(alpha: 0.3);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: _answered ? null : () => setState(() { _selected = i; _answered = true; }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: _answered ? null : [
                                    BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
                                  ],
                                ),
                                child: Row(children: [
                                  Container(
                                    width: 26, height: 26,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.softPink.withValues(alpha: _answered ? 0.15 : 0.25),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(String.fromCharCode(65 + i), style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.inkOn(context).withValues(alpha: 0.7))),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(e.value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textCol))),
                                  if (_answered && isCorrect) Icon(Icons.check_circle_rounded, color: const Color(0xFF28A745), size: 20),
                                  if (_answered && isSelected && !isCorrect) Icon(Icons.cancel_rounded, color: AppColors.softPink, size: 20),
                                ]),
                              ),
                            ),
                          );
                        }),
                      ]),
                    ),
                  ),

                  if (_answered) ...[
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: AppColors.cardOn(context), borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Açıklama', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.warmOrange)),
                          const SizedBox(height: 8),
                          Text(q.explanation, style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.6), height: 1.5)),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: _nextQuestion,
                            child: Container(
                              width: double.infinity, height: 48,
                              decoration: BoxDecoration(color: AppColors.inkOn(context), borderRadius: BorderRadius.circular(24)),
                              alignment: Alignment.center,
                              child: Text('Sonraki Soru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
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
