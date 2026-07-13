import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selected;
  bool _answered = false;

  static const _quizSets = [
    _QuizSet(title: 'Döngü Bilgisi', icon: Icons.autorenew_rounded, questionCount: 8, completed: 5),
    _QuizSet(title: 'Mitleri Yık', icon: Icons.cancel_outlined, questionCount: 6, completed: 2),
    _QuizSet(title: 'Beslenme', icon: Icons.restaurant_outlined, questionCount: 5, completed: 0),
    _QuizSet(title: 'Duygular', icon: Icons.psychology_outlined, questionCount: 7, completed: 0),
  ];

  static const _question = 'Aşağıdakilerden hangisi adet döngüsü hakkında doğrudur?';
  static const _options = [
    'Döngü her zaman tam 28 gün sürer',
    '21-35 gün arası döngü süresi normaldir',
    'Adet sadece 3 gün sürer',
    'Egzersiz adet döneminde zararlıdır',
  ];
  static const _correct = 1;
  static const _explanation = 'Her kadının döngüsü farklıdır. 21-35 gün arasında değişen döngü süreleri tamamen normaldir. "28 gün" sadece bir ortalamadır.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: AppColors.gradientHeroSoft,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Öğren &\nTest Et', style: AppTextStyles.heading(fontSize: 32, color: AppColors.ink)),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('bilgini sına, rozetler kazan.', style: AppTextStyles.accent(fontSize: 18, color: AppColors.softPink)),
                  ),
                  const SizedBox(height: 24),

                  // Seri + puan
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.cardCream,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: AppColors.warmOrange.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                          child: Icon(Icons.local_fire_department_rounded, size: 24, color: AppColors.warmOrange),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('3 Günlük Seri', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                          Text('Her gün çöz, serisini koru!', style: TextStyle(fontSize: 11, color: AppColors.ink.withValues(alpha: 0.4))),
                        ])),
                        Text('240', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.warmOrange)),
                        Text(' pt', style: TextStyle(fontSize: 12, color: AppColors.warmOrange.withValues(alpha: 0.6))),
                      ]),
                    ),
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
                        Row(children: [
                          Text('Günün Sorusu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.softPink)),
                          const Spacer(),
                          Text('+20 puan', style: TextStyle(fontSize: 11, color: AppColors.ink.withValues(alpha: 0.35))),
                        ]),
                        const SizedBox(height: 14),
                        Text(_question, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.4)),
                        const SizedBox(height: 18),
                        ..._options.asMap().entries.map((e) {
                          final i = e.key;
                          final isSelected = _selected == i;
                          final isCorrect = i == _correct;

                          Color bg; Color textCol;
                          if (!_answered) {
                            bg = Colors.white;
                            textCol = AppColors.ink;
                          } else if (isCorrect) {
                            bg = const Color(0xFFD4EDDA);
                            textCol = const Color(0xFF155724);
                          } else if (isSelected) {
                            bg = AppColors.cardPink;
                            textCol = AppColors.ink.withValues(alpha: 0.5);
                          } else {
                            bg = Colors.white.withValues(alpha: 0.5);
                            textCol = AppColors.ink.withValues(alpha: 0.3);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: _answered ? null : () => setState(() { _selected = i; _answered = true; }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
                                child: Row(children: [
                                  Text(String.fromCharCode(65 + i), style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink.withValues(alpha: 0.25))),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(e.value, style: TextStyle(fontSize: 14, color: textCol))),
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
                        decoration: BoxDecoration(color: AppColors.cardCream, borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Açıklama', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.warmOrange)),
                          const SizedBox(height: 8),
                          Text(_explanation, style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.6), height: 1.5)),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () => setState(() { _selected = null; _answered = false; }),
                            child: Container(
                              width: double.infinity, height: 48,
                              decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(24)),
                              alignment: Alignment.center,
                              child: Text('Sonraki Soru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  // Quiz setleri
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Konu Bazlı', style: AppTextStyles.heading(fontSize: 20, color: AppColors.ink)),
                  ),
                  const SizedBox(height: 14),

                  ..._quizSets.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardPink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: AppColors.softPink.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                          child: Icon(s.icon, size: 22, color: AppColors.ink.withValues(alpha: 0.6)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: s.completed / s.questionCount,
                              backgroundColor: AppColors.softPink.withValues(alpha: 0.15),
                              color: AppColors.softPink,
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${s.completed}/${s.questionCount} tamamlandı', style: TextStyle(fontSize: 10, color: AppColors.ink.withValues(alpha: 0.35))),
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

class _QuizSet {
  const _QuizSet({required this.title, required this.icon, required this.questionCount, required this.completed});
  final String title;
  final IconData icon;
  final int questionCount, completed;
}
