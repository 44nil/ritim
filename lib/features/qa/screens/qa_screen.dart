import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/clean_card.dart';

class QaScreen extends StatefulWidget {
  const QaScreen({super.key});

  @override
  State<QaScreen> createState() => _QaScreenState();
}

class _QaScreenState extends State<QaScreen> {
  String _selectedCategory = 'Tümü';

  static const _categories = ['Tümü', 'Döngü', 'Beden', 'Duygular', 'Beslenme'];

  static const _questions = [
    _QaItem(
      question: 'Adetim düzensiz geliyor, normal mi?',
      answer: 'İlk birkaç yıl adet düzensizliği çok yaygındır. Vücudun hormonal dengesini oturtuyor. Eğer 2 yıldan fazla sürerse bir doktora danışabilirsin.',
      doctor: 'Dr. Ayşe Kaya',
      specialty: 'Kadın Doğum Uzmanı',
      category: 'Döngü',
      likes: 24,
      isAnswered: true,
    ),
    _QaItem(
      question: 'Adet sırasında spor yapabilir miyim?',
      answer: 'Kesinlikle! Hafif egzersiz aslında kramplara iyi gelir. Yürüyüş, yoga veya yüzme harika seçenekler. Sadece çok ağır egzersizlerden kaçınabilirsin.',
      doctor: 'Dr. Elif Demir',
      specialty: 'Spor Hekimi',
      category: 'Beden',
      likes: 42,
      isAnswered: true,
    ),
    _QaItem(
      question: 'Neden bazen çok duygusal oluyorum?',
      answer: 'Döngü boyunca hormon seviyelerin değişiyor. Özellikle adet öncesi dönemde östrojen ve progesteron düşer — bu duygusal dalgalanmalara neden olabilir. Tamamen normal!',
      doctor: 'Dr. Zeynep Arslan',
      specialty: 'Ergen Psikoloğu',
      category: 'Duygular',
      likes: 38,
      isAnswered: true,
    ),
    _QaItem(
      question: 'Adet döneminde ne yemeliyim?',
      answer: 'Demir açısından zengin yiyecekler (ıspanak, kırmızı et, kuru baklagiller) ve C vitamini (portakal, çilek) iyi gelir. Bol su iç, aşırı tuzlu ve şekerli yiyeceklerden kaçın.',
      doctor: 'Dr. Selin Yıldız',
      specialty: 'Beslenme Uzmanı',
      category: 'Beslenme',
      likes: 31,
      isAnswered: true,
    ),
    _QaItem(
      question: 'Kramplar çok şiddetli, ne yapabilirim?',
      answer: 'Sıcak su torbası, hafif egzersiz ve bol su içmek yardımcı olur. Eğer kramplar günlük hayatını etkiliyorsa mutlaka bir doktora başvur.',
      doctor: 'Dr. Ayşe Kaya',
      specialty: 'Kadın Doğum Uzmanı',
      category: 'Beden',
      likes: 56,
      isAnswered: true,
    ),
    _QaItem(
      question: 'Arkadaşlarım adet oldu ama ben olmadım, sorun mu?',
      answer: 'Hayır, sorun değil! Herkesin vücudu farklı tempoda gelişir. İlk adet 10-16 yaş arasında başlayabilir. Endişelenme, vücudun hazır olduğunda başlayacak.',
      doctor: 'Dr. Zeynep Arslan',
      specialty: 'Ergen Psikoloğu',
      category: 'Duygular',
      likes: 67,
      isAnswered: true,
    ),
    _QaItem(
      question: 'Ped mi tampon mu kullanmalıyım?',
      answer: '',
      doctor: '',
      specialty: '',
      category: 'Beden',
      likes: 12,
      isAnswered: false,
    ),
  ];

  List<_QaItem> get _filteredQuestions {
    if (_selectedCategory == 'Tümü') return _questions;
    return _questions.where((q) => q.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xFFF9C4D2), Color(0xFFFDD6A8), Color(0xFFFFFFFF)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Uzman\nPaneli', style: AppTextStyles.heading(fontSize: 32, color: AppColors.ink)),
                            const SizedBox(height: 4),
                            Text('anonim sor, uzman cevaplasın.', style: AppTextStyles.accent(fontSize: 18, color: AppColors.softPink)),
                          ],
                        ),
                      ),
                      _SmallBtn(icon: Icons.search_rounded, onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

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
                const SizedBox(height: 16),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _filteredQuestions.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _QuestionCard(item: _filteredQuestions[i]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAskSheet(context),
        icon: const Icon(Icons.edit_outlined, size: 20),
        label: const Text('Anonim Sor'),
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAskSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 24),
          Text('Anonim Soru Sor', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Kimliğin gizli kalır, uzmanlar cevaplar', style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 20),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Merak ettiğin soruyu yaz...',
              hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Text('Kategori: ', style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
            ..._categories.where((c) => c != 'Tümü').map((c) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(c, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            )),
          ]),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Gönder'),
          )),
          SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
        ]),
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  const _SmallBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.5),
        ),
        child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
      ),
    );
  }
}

class _QuestionCard extends StatefulWidget {
  const _QuestionCard({required this.item});
  final _QaItem item;

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final q = widget.item;

    return CleanCard(
      onTap: q.isAnswered ? () => setState(() => _expanded = !_expanded) : null,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori + durum
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(q.category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary)),
            ),
            const Spacer(),
            if (q.isAnswered)
              Row(children: [
                Icon(Icons.check_circle_rounded, size: 14, color: AppColors.phaseOvulation),
                const SizedBox(width: 4),
                Text('Cevaplandı', style: TextStyle(fontSize: 10, color: AppColors.phaseOvulation, fontWeight: FontWeight.w600)),
              ])
            else
              Row(children: [
                Icon(Icons.schedule_rounded, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                const SizedBox(width: 4),
                Text('Bekliyor', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
              ]),
          ]),
          const SizedBox(height: 12),

          // Soru
          Text(q.question, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.3)),

          // Beğeni + genişlet
          if (q.isAnswered) ...[
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.favorite_rounded, size: 14, color: AppColors.phaseMenstruation.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text('${q.likes}', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
              const Spacer(),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: AppConstants.animDurationFast,
                child: Icon(Icons.expand_more_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ]),
          ],

          // Cevap
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: q.isAnswered ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard.withValues(alpha: 0.9) : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.phaseOvulation.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.medical_services_outlined, size: 14, color: AppColors.phaseOvulation),
                        ),
                        const SizedBox(width: 8),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(q.doctor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                          Text(q.specialty, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5))),
                        ]),
                      ]),
                      const SizedBox(height: 12),
                      Text(q.answer, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85), height: 1.6)),
                    ],
                  ),
                ),
              ],
            ) : const SizedBox.shrink(),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: AppConstants.animDurationNormal,
          ),
        ],
      ),
    );
  }
}

class _QaItem {
  const _QaItem({
    required this.question, required this.answer, required this.doctor,
    required this.specialty, required this.category, required this.likes,
    required this.isAnswered,
  });
  final String question, answer, doctor, specialty, category;
  final int likes;
  final bool isAnswered;
}
