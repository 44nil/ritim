import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/staggered_list.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selected;
  bool _answered = false;

  static const _quizSets = [
    _QuizSet(title: 'Döngü Bilgisi', icon: Icons.autorenew_rounded, color: AppColors.primary, questionCount: 8, completed: 5),
    _QuizSet(title: 'Mitleri Yık', icon: Icons.cancel_outlined, color: AppColors.phaseMenstruation, questionCount: 6, completed: 2),
    _QuizSet(title: 'Beslenme', icon: Icons.restaurant_outlined, color: AppColors.phaseOvulation, questionCount: 5, completed: 0),
    _QuizSet(title: 'Duygular', icon: Icons.psychology_outlined, color: AppColors.secondary, questionCount: 7, completed: 0),
  ];

  // Günün sorusu
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: isDark ? const Color(0xFF1A1518) : const Color(0xFFF8F3F0)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StaggeredList(children: [
                const SizedBox(height: 12),
                Text('Öğren &\nTest Et', style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5)),
                const SizedBox(height: 4),
                Text('Bilgini sına, rozetler kazan', style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                const SizedBox(height: 20),

                // Seri + puan
                CleanCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.tertiary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(11)),
                      child: const Icon(Icons.local_fire_department_rounded, size: 22, color: AppColors.tertiary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('3 Günlük Seri', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      Text('Her gün çöz, serisini koru!', style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 11)),
                    ])),
                    Column(children: [
                      Text('240', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.tertiary)),
                      Text('puan', style: TextStyle(fontSize: 10, color: AppColors.tertiary.withValues(alpha: 0.6))),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),

                // Günün sorusu — koyu kart
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard.withValues(alpha: 0.9) : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Text('Günün Sorusu', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                      const Spacer(),
                      Text('+20 puan', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4))),
                    ]),
                    const SizedBox(height: 16),
                    Text(_question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3)),
                    const SizedBox(height: 18),
                    ..._options.asMap().entries.map((e) {
                      final i = e.key;
                      final isSelected = _selected == i;
                      final isCorrect = i == _correct;

                      Color bg; Color border; Color textCol;
                      if (!_answered) {
                        bg = Colors.white.withValues(alpha: 0.08);
                        border = Colors.transparent;
                        textCol = Colors.white.withValues(alpha: 0.9);
                      } else if (isCorrect) {
                        bg = AppColors.success.withValues(alpha: 0.15);
                        border = AppColors.success;
                        textCol = Colors.white;
                      } else if (isSelected) {
                        bg = AppColors.error.withValues(alpha: 0.15);
                        border = AppColors.error;
                        textCol = Colors.white.withValues(alpha: 0.6);
                      } else {
                        bg = Colors.white.withValues(alpha: 0.04);
                        border = Colors.transparent;
                        textCol = Colors.white.withValues(alpha: 0.3);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: _answered ? null : () => setState(() { _selected = i; _answered = true; }),
                          child: AnimatedContainer(
                            duration: AppConstants.animDurationFast,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: border, width: 1.5)),
                            child: Row(children: [
                              Text(String.fromCharCode(65 + i), style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.3))),
                              const SizedBox(width: 10),
                              Expanded(child: Text(e.value, style: TextStyle(fontSize: 13, color: textCol))),
                              if (_answered && isCorrect) const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                              if (_answered && isSelected && !isCorrect) const Icon(Icons.cancel_rounded, color: AppColors.error, size: 18),
                            ]),
                          ),
                        ),
                      );
                    }),
                  ]),
                ),

                // Açıklama kartı
                if (_answered) ...[
                  const SizedBox(height: 14),
                  CleanCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.school_outlined, size: 16, color: AppColors.phaseOvulation),
                        const SizedBox(width: 8),
                        Text('Açıklama', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.phaseOvulation)),
                      ]),
                      const SizedBox(height: 8),
                      Text(_explanation, style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7), height: 1.5)),
                      const SizedBox(height: 14),
                      SizedBox(width: double.infinity, height: 44, child: ElevatedButton(
                        onPressed: () => setState(() { _selected = null; _answered = false; }),
                        child: const Text('Sonraki Soru →'),
                      )),
                    ]),
                  ),
                ],
                const SizedBox(height: 24),

                // Quiz setleri
                Text('Konu Bazlı Quizler', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                ..._quizSets.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CleanCard(
                    onTap: () {},
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: s.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(11)),
                        child: Icon(s.icon, size: 20, color: s.color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        // İlerleme barı
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: s.completed / s.questionCount,
                            backgroundColor: s.color.withValues(alpha: 0.1),
                            color: s.color,
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('${s.completed}/${s.questionCount} tamamlandı', style: TextStyle(
                          fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
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

class _QuizSet {
  const _QuizSet({required this.title, required this.icon, required this.color, required this.questionCount, required this.completed});
  final String title;
  final IconData icon;
  final Color color;
  final int questionCount, completed;
}
