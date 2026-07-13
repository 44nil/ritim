import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/arc_mood_selector.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/mood_face.dart';
import '../data/mock_cycle_data.dart';
import '../data/mock_wellness_data.dart';
import '../data/mock_mood_data.dart';

class CycleTrackingScreen extends StatefulWidget {
  const CycleTrackingScreen({super.key});

  @override
  State<CycleTrackingScreen> createState() => _CycleTrackingScreenState();
}

class _CycleTrackingScreenState extends State<CycleTrackingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  final _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _staggered({required int index, required Widget child}) {
    final delay = (index * 0.08).clamp(0.0, 0.5);
    final end = (delay + 0.5).clamp(0.0, 1.0);
    final curve = CurvedAnimation(
      parent: _animController,
      curve: Interval(delay, end, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: curve,
      builder: (context, _) => Opacity(
        opacity: curve.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - curve.value)),
          child: Transform.scale(
            scale: 0.95 + 0.05 * curve.value,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phase = MockCycleData.currentPhase;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cycle = ProviderScope.containerOf(context).read(cycleProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient — scroll'a bağlı, aşağı kaydıkça yukarı kayar
          Positioned(
            top: -_scrollOffset * 0.5,
            left: 0, right: 0,
            child: Opacity(
              opacity: (1 - _scrollOffset / 400).clamp(0.0, 1.0),
              child: Container(
                height: 400,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF9C4D2), Color(0xFFFDD6A8), Color(0xFFFFFFFF)],
                  ),
                ),
              ),
            ),
          ),
          // Alt gradient — navbar üstünde sıcak his
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: IgnorePointer(
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFFF9C4D2), Color(0xFFFDD6A8), Color(0x00FFFFFF)],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Büyük ay başlığı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(children: [
                      Text(
                        DateFormat('MMMM yyyy', 'tr_TR').format(DateTime.now()),
                        style: AppTextStyles.heading(fontSize: 32, color: AppColors.ink),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 28, color: AppColors.ink),
                      const Spacer(),
                      _SmallButton(icon: Icons.settings_outlined, onTap: () {}),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // Gün şeridi
                  _staggered(index: 0, child: _WeekStrip(cycle: cycle)),
                  const SizedBox(height: 24),

                  // Döngü durumu kartı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _staggered(index: 1, child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.softPink.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${cycle.currentCycleDay}. gün', style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.5))),
                        const SizedBox(height: 4),
                        Text(phase.label, style: AppTextStyles.heading(fontSize: 26, color: AppColors.ink)),
                        const SizedBox(height: 8),
                        Text(phase.tip, style: TextStyle(fontSize: 14, color: AppColors.ink.withValues(alpha: 0.6), height: 1.5)),
                        const SizedBox(height: 16),
                        // Adetim başladı/bitti butonu
                        Builder(builder: (ctx) {
                          final isOn = cycle.isOnPeriod;
                          final notifier = ProviderScope.containerOf(ctx).read(cycleProvider.notifier);
                          return GestureDetector(
                            onTap: () {
                              if (isOn) { notifier.endPeriod(); } else { notifier.startPeriod(); }
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                content: Text(isOn ? 'Adet bitiş kaydedildi' : 'Adet başlangıcı kaydedildi'),
                                behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink,
                              ));
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.ink,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(isOn ? Icons.stop_rounded : Icons.water_drop_rounded, size: 20, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(isOn ? 'Adetim Bitti' : 'Adetim Başladı', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                              ]),
                            ),
                          );
                        }),
                      ]),
                    )),
                  ),
                  const SizedBox(height: 28),

                  // Sağlığını kontrol et
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Döngü\nTakibin', style: AppTextStyles.heading(fontSize: 30, color: AppColors.ink)),
                  ),
                  const SizedBox(height: 18),

                  // 2x2 istatistik grid — referanstaki gibi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _staggered(index: 2, child: Column(children: [
                      // Üst sıra — büyük kart
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5ED),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Icon(Icons.mood_outlined, size: 20, color: AppColors.warmOrange),
                            const SizedBox(width: 8),
                            Text('Ruh Hali', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                          ]),
                          const SizedBox(height: 16),
                          Builder(builder: (ctx) {
                            void saveMood(String mood) {
                              ProviderScope.containerOf(ctx).read(cycleProvider.notifier).logMood(mood);
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                content: Text('$mood kaydedildi'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink,
                              ));
                            }
                            return Wrap(spacing: 8, runSpacing: 8, children: [
                              _MoodChip(label: 'Mutlu', color: AppColors.ink, onTap: () => saveMood('Mutlu')),
                              _MoodChip(label: 'Sakin', color: AppColors.ink, onTap: () => saveMood('Sakin')),
                              _MoodChip(label: 'Yorgun', color: AppColors.ink, onTap: () => saveMood('Yorgun')),
                              _MoodChip(label: 'Hassas', color: AppColors.ink, onTap: () => saveMood('Hassas')),
                              _MoodChip(label: 'Sinirli', color: AppColors.ink, onTap: () => saveMood('Sinirli')),
                            ]);
                          }),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      // Alt sıra — 2 kart yan yana
                      Row(children: [
                        Expanded(child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE8EF),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Icon(Icons.water_drop_outlined, size: 18, color: AppColors.softPink),
                              const SizedBox(width: 6),
                              Text('Su', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                            ]),
                            const SizedBox(height: 12),
                            RichText(text: TextSpan(children: [
                              TextSpan(text: '${MockWellnessData.waterDrunk}/${MockWellnessData.current.waterGoal}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.ink)),
                              TextSpan(text: ' bardak', style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.4))),
                            ])),
                          ]),
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE8EF),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Icon(Icons.nightlight_outlined, size: 18, color: AppColors.softPink),
                              const SizedBox(width: 6),
                              Text('Uyku', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                            ]),
                            const SizedBox(height: 12),
                            RichText(text: TextSpan(children: [
                              TextSpan(text: MockWellnessData.current.sleepHours, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.ink)),
                              TextSpan(text: ' saat', style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.4))),
                            ])),
                          ]),
                        )),
                      ]),
                      const SizedBox(height: 12),
                      // Semptom + Not yan yana
                      Row(children: [
                        Expanded(child: GestureDetector(
                          onTap: () => _QuickActions._showSymptoms(context),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5ED),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Icon(Icons.healing_outlined, size: 20, color: AppColors.warmOrange),
                              const SizedBox(height: 10),
                              Text('Semptom', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              const SizedBox(height: 4),
                              Text('Kaydet', style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.4))),
                            ]),
                          ),
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: GestureDetector(
                          onTap: () => _QuickActions._showNote(context),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5ED),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Icon(Icons.sticky_note_2_outlined, size: 20, color: AppColors.warmOrange),
                              const SizedBox(height: 10),
                              Text('Günlük Not', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              const SizedBox(height: 4),
                              Text('Yaz', style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.4))),
                            ]),
                          ),
                        )),
                      ]),
                    ])),
                  ),

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

// ─── Döngü Halkası (Genspark tarzı) ────────────────────────────────────────

class _CycleRing extends StatelessWidget {
  const _CycleRing({required this.cycle, required this.phase, required this.isDark});
  final CycleState cycle;
  final CyclePhaseInfo phase;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final day = cycle.currentCycleDay;
    final total = cycle.averageCycleLength;
    final progress = day / total;
    final prediction = cycle.daysUntilNextPeriod;

    return Center(
      child: SizedBox(
        width: 260, height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Arka halka
            SizedBox(
              width: 240, height: 240,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 14,
                backgroundColor: Colors.transparent,
                color: AppColors.softPink.withValues(alpha: 0.12),
                strokeCap: StrokeCap.round,
              ),
            ),
            // İlerleme halkası
            SizedBox(
              width: 240, height: 240,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (_, val, _) => CircularProgressIndicator(
                  value: val,
                  strokeWidth: 14,
                  backgroundColor: Colors.transparent,
                  color: AppColors.softPink,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
            // Merkez bilgi
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GÜN $day / $total',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: AppColors.ink.withValues(alpha: 0.4)),
                ),
                const SizedBox(height: 4),
                Text(
                  phase.label,
                  style: AppTextStyles.heading(fontSize: 36, color: AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  prediction != null ? '$prediction gün sonra' : 'kayıt bekleniyor',
                  style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.4)),
                ),
              ],
            ),
            // Alt nokta göstergesi
            Positioned(
              bottom: 0,
              child: Container(
                width: 18, height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.gradientPinkOrange,
                  border: Border.all(color: isDark ? AppColors.backgroundDark : const Color(0xFFFAF5F0), width: 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Haftalık Gün Şeridi ───────────────────────────────────────────────────

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.cycle});
  final CycleState cycle;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: 3 - i)));
    final dayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: days.map((date) {
          final isToday = date.day == now.day && date.month == now.month;
          final isPeriod = cycle.isPeriodDay(date);
          final label = dayLabels[(date.weekday - 1) % 7];

          return Expanded(child: Column(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday
                    ? AppColors.ink
                    : isPeriod
                        ? AppColors.softPink.withValues(alpha: 0.15)
                        : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 16, fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                  color: isToday ? Colors.white : AppColors.ink.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.ink.withValues(alpha: 0.35))),
          ]));
        }).toList(),
      ),
    );
  }
}

// ─── Semptom Grid (3x2, Genspark tarzı) ────────────────────────────────────

class _SymptomGrid extends StatefulWidget {
  const _SymptomGrid();

  @override
  State<_SymptomGrid> createState() => _SymptomGridState();
}

class _SymptomGridState extends State<_SymptomGrid> {
  final _selected = <String>{};

  static const _symptoms = [
    ('Kramp', Icons.flash_on_rounded),
    ('Baş ağrısı', Icons.psychology_outlined),
    ('Yorgunluk', Icons.battery_2_bar_rounded),
    ('Şişkinlik', Icons.bubble_chart_outlined),
    ('Hassasiyet', Icons.favorite_border_rounded),
    ('Sakinlik', Icons.spa_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: _symptoms.map((s) {
        final isSelected = _selected.contains(s.$1);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) { _selected.remove(s.$1); } else { _selected.add(s.$1); }
            });
            final names = _selected.toList();
            ProviderScope.containerOf(context).read(cycleProvider.notifier).logSymptoms(names);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(names.isEmpty ? 'Semptomlar temizlendi' : '${s.$1} kaydedildi'),
              behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink,
              duration: const Duration(seconds: 1),
            ));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.softPink : AppColors.warmOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(s.$2, size: 26, color: isSelected ? Colors.white : AppColors.ink.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              Text(s.$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.ink)),
            ]),
          ),
        );
      }).toList(),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.softPink.withValues(alpha: 0.15),
        ),
        child: Icon(icon, size: 20, color: AppColors.ink.withValues(alpha: 0.5)),
      ),
    );
  }
}

// ─── Hızlı Aksiyonlar ───────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionChip(icon: Icons.edit_calendar_outlined, label: 'Kaydet', color: AppColors.primary, onTap: () => _showDailyLog(context)),
        const SizedBox(width: 8),
        _ActionChip(icon: Icons.mood_outlined, label: 'Ruh Hali', color: AppColors.secondary, onTap: () => _showMoodSelector(context)),
        const SizedBox(width: 8),
        _ActionChip(icon: Icons.healing_outlined, label: 'Semptom', color: AppColors.phaseMenstruation, onTap: () => _showSymptoms(context)),
        const SizedBox(width: 8),
        _ActionChip(icon: Icons.sticky_note_2_outlined, label: 'Not', color: AppColors.tertiary, onTap: () => _showNote(context)),
      ],
    );
  }

  static void _showMoodSelector(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    _sheet(context, (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
      _sheetHandle(context),
      const SizedBox(height: 20),
      ArcMoodSelector(onMoodSelected: (mood) {
        container.read(cycleProvider.notifier).logMood(mood.label);
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ruh halin kaydedildi'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink),
        );
      }),
      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 8),
    ]));
  }

  static void _showDailyLog(BuildContext context) {
    final theme = Theme.of(context);
    final container = ProviderScope.containerOf(context);
    _sheet(context, (ctx) => StatefulBuilder(builder: (ctx, setSt) {
      String? selectedFlow;
      return Column(mainAxisSize: MainAxisSize.min, children: [
        _sheetHandle(context),
        const SizedBox(height: 24),
        Text('Bugünü Kaydet', style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface)),
        const SizedBox(height: 6),
        Text('Akış yoğunluğunu seç', style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _FlowOption(label: 'Yok', icon: Icons.remove_rounded, color: Colors.grey, isSelected: selectedFlow == 'Yok', onTap: () => setSt(() => selectedFlow = 'Yok')),
          _FlowOption(label: 'Az', icon: Icons.water_drop_outlined, color: AppColors.phaseMenstruation.withValues(alpha: 0.5), isSelected: selectedFlow == 'Az', onTap: () => setSt(() => selectedFlow = 'Az')),
          _FlowOption(label: 'Normal', icon: Icons.water_drop_rounded, color: AppColors.phaseMenstruation.withValues(alpha: 0.75), isSelected: selectedFlow == 'Normal', onTap: () => setSt(() => selectedFlow = 'Normal')),
          _FlowOption(label: 'Yoğun', icon: Icons.opacity_rounded, color: AppColors.phaseMenstruation, isSelected: selectedFlow == 'Yoğun', onTap: () => setSt(() => selectedFlow = 'Yoğun')),
        ]),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
          onPressed: () {
            if (selectedFlow != null) {
              container.read(cycleProvider.notifier).logFlow(selectedFlow!);
            }
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(selectedFlow != null ? 'Akış kaydedildi: $selectedFlow' : 'Kayıt atlandı'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink),
            );
          },
          child: Text(selectedFlow != null ? 'Kaydet' : 'Atla'))),
        SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
      ]);
    }));
  }

  static void _showSymptoms(BuildContext context) {
    final theme = Theme.of(context);
    final container = ProviderScope.containerOf(context);
    _sheet(context, (ctx) => StatefulBuilder(builder: (ctx, setSt) {
      final selected = <int>{};
      final symptoms = [
        ('Kramp', Icons.flash_on_rounded), ('Baş ağrısı', Icons.psychology_outlined),
        ('Yorgunluk', Icons.battery_2_bar_rounded), ('Şişkinlik', Icons.bubble_chart_outlined),
        ('Akne', Icons.face_outlined), ('Hassasiyet', Icons.favorite_border_rounded),
        ('Bulantı', Icons.sick_outlined), ('Uykusuzluk', Icons.nightlight_outlined),
        ('Bel ağrısı', Icons.accessibility_new_rounded), ('İştahsızlık', Icons.no_food_outlined),
      ];
      return Column(mainAxisSize: MainAxisSize.min, children: [
        _sheetHandle(context),
        const SizedBox(height: 24),
        Text('Semptomlar', style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface)),
        const SizedBox(height: 6),
        Text('Bugün yaşadıklarını işaretle', style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        const SizedBox(height: 20),
        Wrap(spacing: 8, runSpacing: 8, children: symptoms.asMap().entries.map((e) {
          final isSelected = selected.contains(e.key);
          return FilterChip(
            avatar: Icon(e.value.$2, size: 16),
            label: Text(e.value.$1, style: TextStyle(
              color: theme.colorScheme.onSurface, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
            selected: isSelected,
            onSelected: (val) => setSt(() {
              if (val) { selected.add(e.key); } else { selected.remove(e.key); }
            }),
          );
        }).toList()),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
          onPressed: () {
            if (selected.isNotEmpty) {
              final names = selected.map((i) => symptoms[i].$1).toList();
              container.read(cycleProvider.notifier).logSymptoms(names);
            }
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(selected.isEmpty ? 'Kayıt atlandı' : '${selected.length} semptom kaydedildi'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink),
            );
          },
          child: Text(selected.isEmpty ? 'Atla' : 'Kaydet (${selected.length})'))),
        SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
      ]);
    }));
  }

  static void _showNote(BuildContext context) {
    final theme = Theme.of(context);
    final container = ProviderScope.containerOf(context);
    final controller = TextEditingController();
    _sheet(context, (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
      _sheetHandle(context),
      const SizedBox(height: 24),
      Text('Günlük Not', style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface)),
      const SizedBox(height: 20),
      TextField(controller: controller, maxLines: 4, decoration: InputDecoration(
        hintText: 'Bugün nasıl hissediyorum...', border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), filled: true)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
        onPressed: () {
          final text = controller.text.trim();
          if (text.isNotEmpty) {
            container.read(cycleProvider.notifier).logNote(text);
          }
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(text.isNotEmpty ? 'Notun kaydedildi' : 'Kayıt atlandı'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink),
          );
        },
        child: const Text('Kaydet'))),
      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
    ]));
  }

  static void _sheet(BuildContext context, Widget Function(BuildContext) builder) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(ctx).viewInsets.bottom),
        child: builder(ctx),
      ),
    );
  }

  static Widget _sheetHandle(BuildContext context) {
    return Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))));
  }
}

class _FlowOption extends StatelessWidget {
  const _FlowOption({required this.label, required this.icon, required this.color, this.isSelected = false, this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Icon(icon, size: 26, color: isSelected ? Colors.white : color)),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      ]),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(children: [
            Container(width: 32, height: 32,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, size: 18, color: color)),
            const SizedBox(height: 5),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 10)),
          ]),
        ),
      ),
    );
  }
}

// ─── Aylık Takvim ───────────────────────────────────────────────────────────

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy', 'tr_TR').format(now);
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = (firstDay.weekday - 1) % 7; // 0=Pzt

    // Mock: adet günleri 1-5, ovülasyon 13-16
    final periodDays = {1, 2, 3, 4, 5};
    final ovulationDays = {13, 14, 15, 16};

    return CleanCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(children: [
            Text(monthName[0].toUpperCase() + monthName.substring(1),
              style: AppTextStyles.heading(fontSize: 16, color: AppColors.ink)),
            const Spacer(),
            Icon(Icons.chevron_left_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ]),
          const SizedBox(height: 18),
          // Gün başlıkları
          Row(children: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'].map((d) => Expanded(
            child: Text(d, textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontSize: 10)),
          )).toList()),
          const SizedBox(height: 8),
          // Takvim grid
          ...List.generate(6, (week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(children: List.generate(7, (dow) {
                final dayNum = week * 7 + dow - startWeekday + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 36));
                }

                final isToday = dayNum == now.day;
                final isPeriod = periodDays.contains(dayNum);
                final isOvulation = ovulationDays.contains(dayNum);

                Color bg;
                Color textColor;
                if (isToday) {
                  bg = AppColors.darkCard;
                  textColor = Colors.white;
                } else if (isPeriod) {
                  bg = AppColors.phaseMenstruation.withValues(alpha: 0.2);
                  textColor = AppColors.phaseMenstruation;
                } else if (isOvulation) {
                  bg = AppColors.phaseOvulation.withValues(alpha: 0.15);
                  textColor = AppColors.phaseOvulation;
                } else {
                  bg = Colors.transparent;
                  textColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
                }

                return Expanded(
                  child: Container(
                    height: 36,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('$dayNum', style: TextStyle(
                      fontSize: 12, fontWeight: isToday || isPeriod ? FontWeight.w700 : FontWeight.w500, color: textColor)),
                  ),
                );
              })),
            );
          }),
          const SizedBox(height: 12),
          // Filtre pill'leri
          Row(children: [
            _FilterPill(label: 'Adet', color: AppColors.phaseMenstruation, isActive: true),
            const SizedBox(width: 6),
            _FilterPill(label: 'Ovülasyon', color: AppColors.phaseOvulation, isActive: true),
            const SizedBox(width: 6),
            _FilterPill(label: 'Luteal', color: AppColors.phaseLuteal, isActive: false),
            const SizedBox(width: 6),
            _FilterPill(label: 'Tümü', color: Colors.grey, isActive: false),
          ]),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.color, required this.isActive});
  final String label;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? color.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
          color: isActive ? color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
      ]),
    );
  }
}

// ─── Yardımcı Widgetlar ────────────────────────────────────────────────────

class _CycleCalendarHero extends StatelessWidget {
  const _CycleCalendarHero({required this.phase, required this.isDark});
  final CyclePhaseInfo phase;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final cycleState = ProviderScope.containerOf(context).read(cycleProvider);

    final monthName = DateFormat('MMMM yyyy', 'tr_TR').format(now);
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = (firstDay.weekday - 1) % 7;

    return Column(children: [
      Row(children: [
        _IconBadge(icon: Icons.calendar_month_outlined, color: phase.color),
        const SizedBox(width: 10),
        Text(
          monthName[0].toUpperCase() + monthName.substring(1),
          style: AppTextStyles.heading(fontSize: 16, color: AppColors.ink),
        ),
        const Spacer(),
        Icon(Icons.chevron_left_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
      ]),
      const SizedBox(height: 14),
      Row(children: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'].map((d) => Expanded(
        child: Text(d, textAlign: TextAlign.center, style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.35))),
      )).toList()),
      const SizedBox(height: 6),
      ...List.generate(6, (week) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(children: List.generate(7, (dow) {
            final dayNum = week * 7 + dow - startWeekday + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const Expanded(child: SizedBox(height: 38));
            }

            final isToday = dayNum == now.day;
            final date = DateTime(now.year, now.month, dayNum);
            final isPeriod = cycleState.isPeriodDay(date);
            final isPredicted = !isPeriod && cycleState.isPredictedPeriodDay(date);
            final hasLog = cycleState.logForDate(date) != null;

            Color bg;
            Color textColor;
            FontWeight weight;
            if (isToday) {
              bg = AppColors.softPink;
              textColor = Colors.white;
              weight = FontWeight.w800;
            } else if (isPeriod) {
              bg = AppColors.softPink.withValues(alpha: 0.25);
              textColor = AppColors.softPink;
              weight = FontWeight.w700;
            } else if (isPredicted) {
              bg = AppColors.warmOrange.withValues(alpha: 0.12);
              textColor = AppColors.warmOrange;
              weight = FontWeight.w600;
            } else {
              bg = Colors.transparent;
              textColor = theme.colorScheme.onSurface.withValues(alpha: 0.35);
              weight = FontWeight.w400;
            }

            return Expanded(
              child: SizedBox(
                height: 42,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: bg,
                        shape: BoxShape.circle,
                        border: isPredicted ? Border.all(color: AppColors.warmOrange.withValues(alpha: 0.3), width: 1.5, strokeAlign: BorderSide.strokeAlignInside) : null,
                      ),
                      alignment: Alignment.center,
                      child: Text('$dayNum', style: TextStyle(fontSize: 12, fontWeight: weight, color: textColor)),
                    ),
                    if (hasLog) Container(
                      width: 4, height: 4, margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(color: AppColors.warmOrange, shape: BoxShape.circle),
                    ),
                  ],
                ),
              ),
            );
          })),
        );
      }),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _PhaseDot(label: 'Adet', color: AppColors.softPink),
        const SizedBox(width: 14),
        _PhaseDot(label: 'Tahmini', color: AppColors.warmOrange),
        const SizedBox(width: 14),
        _PhaseDot(label: 'Kayıt', color: AppColors.warmOrange),
      ]),
    ]);
  }
}

class _PhaseDot extends StatelessWidget {
  const _PhaseDot({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color)),
    ]);
  }
}

// ─── Bedeninde Ne Oluyor? ────────────────────────────────────────────────────

class _BodyInfoCard extends StatelessWidget {
  const _BodyInfoCard({required this.phase});
  final CyclePhaseInfo phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard.withValues(alpha: 0.9) : AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.auto_awesome_rounded, size: 16, color: phase.color),
            const SizedBox(width: 8),
            Text('Bedeninde Ne Oluyor?', style: AppTextStyles.heading(fontSize: 16, color: phase.color)),
          ]),
          const SizedBox(height: 12),
          Text(phase.bodyInfo, style: TextStyle(
            fontSize: 13, color: Colors.white.withValues(alpha: 0.8), height: 1.6)),
        ],
      ),
    );
  }
}





// ─── Haftalık Tab ───────────────────────────────────────────────────────────

class _WeeklyTab extends StatelessWidget {
  const _WeeklyTab({super.key, required this.staggered});
  final Widget Function({required int index, required Widget child}) staggered;

  static const _days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  static final _habits = [
    _HabitRow(label: 'Döngü', icon: Icons.water_drop_outlined, color: AppColors.phaseMenstruation,
      checks: [true, true, true, false, true, true, false]),
    _HabitRow(label: 'Ruh hali', icon: Icons.mood_outlined, color: AppColors.secondary,
      checks: [true, true, false, true, true, false, false]),
    _HabitRow(label: 'Semptom', icon: Icons.healing_outlined, color: AppColors.primary,
      checks: [true, false, true, true, false, true, false]),
    _HabitRow(label: 'Su', icon: Icons.local_drink_outlined, color: AppColors.phaseFollicular,
      checks: [true, true, true, true, true, false, false]),
    _HabitRow(label: 'Egzersiz', icon: Icons.directions_run_rounded, color: AppColors.phaseOvulation,
      checks: [false, true, false, true, false, true, false]),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        staggered(index: 0, child: Text('Bu Hafta', style: AppTextStyles.heading(fontSize: 22, color: AppColors.ink))),
        const SizedBox(height: 4),
        staggered(index: 0, child: Text('Bugün sekmesinden kayıt ekle',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)))),
        const SizedBox(height: 18),
        staggered(index: 1, child: Padding(
          padding: const EdgeInsets.only(left: 115),
          child: Row(children: _days.map((d) => Expanded(
            child: Text(d, textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35), fontWeight: FontWeight.w600, fontSize: 10)),
          )).toList()),
        )),
        const SizedBox(height: 8),
        ..._habits.asMap().entries.map((e) => staggered(index: e.key + 2, child: _HabitTrackCard(habit: e.value))),
        const SizedBox(height: 20),
        staggered(index: 8, child: const _MonthCalendar()),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _HabitRow {
  _HabitRow({required this.label, required this.icon, required this.color, required this.checks});
  final String label;
  final IconData icon;
  final Color color;
  final List<bool> checks;
}

class _HabitTrackCard extends StatelessWidget {
  const _HabitTrackCard({required this.habit});
  final _HabitRow habit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CleanCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(color: habit.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(habit.icon, size: 18, color: habit.color)),
          const SizedBox(width: 10),
          SizedBox(width: 55, child: Text(habit.label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ...habit.checks.map((done) => Expanded(child: Center(child: Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: done ? habit.color.withValues(alpha: 0.15) : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
              shape: BoxShape.circle,
              border: done ? null : Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06))),
            child: done ? Icon(Icons.check_rounded, size: 15, color: habit.color) : null,
          )))),
        ]),
      ),
    );
  }
}

// ─── Genel Tab ──────────────────────────────────────────────────────────────

class _OverallTab extends StatelessWidget {
  const _OverallTab({super.key, required this.staggered});
  final Widget Function({required int index, required Widget child}) staggered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        staggered(index: 0, child: Text('Genel Bakış', style: AppTextStyles.heading(fontSize: 22, color: AppColors.ink))),
        const SizedBox(height: 18),
        // İstatistik kartları
        staggered(index: 1, child: Row(children: [
          Expanded(child: _StatBox(value: '28', label: 'Ort. döngü', unit: 'gün', color: AppColors.primary)),
          const SizedBox(width: 8),
          Expanded(child: _StatBox(value: '92', label: 'Kayıt oranı', unit: '%', color: AppColors.phaseOvulation)),
        ])),
        const SizedBox(height: 8),
        staggered(index: 2, child: Row(children: [
          Expanded(child: _StatBox(value: '12', label: 'Gün serisi', unit: 'gün', color: AppColors.tertiary)),
          const SizedBox(width: 8),
          Expanded(child: _StatBox(value: '3', label: 'Takip süresi', unit: 'ay', color: AppColors.secondary)),
        ])),
        const SizedBox(height: 20),
        staggered(index: 3, child: _MoodSummaryCard(isDark: theme.brightness == Brightness.dark)),
        const SizedBox(height: 18),
        staggered(index: 4, child: const _MoodCalendar()),
        const SizedBox(height: 20),
        staggered(index: 5, child: Text('Döngü Geçmişi', style: AppTextStyles.heading(fontSize: 18, color: AppColors.ink))),
        const SizedBox(height: 12),
        staggered(index: 6, child: const _CycleHistory()),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label, required this.unit, required this.color});
  final String value, label, unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CleanCard(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(width: 4),
          Padding(padding: const EdgeInsets.only(bottom: 5),
            child: Text(unit, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.6)))),
        ]),
      ]),
    );
  }
}

class _CycleHistory extends StatelessWidget {
  const _CycleHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cycles = [
      ('Mayıs', '24 May — 20 Haz', '28 gün', AppColors.phaseMenstruation),
      ('Nisan', '26 Nis — 23 May', '27 gün', AppColors.phaseFollicular),
      ('Mart', '28 Mar — 25 Nis', '29 gün', AppColors.phaseLuteal),
    ];
    return Column(children: cycles.map((c) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CleanCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(children: [
          Container(width: 42, height: 42,
            decoration: BoxDecoration(color: c.$4.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.calendar_month_outlined, size: 20, color: c.$4)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.$1, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            Text(c.$2, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: c.$4.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(c.$3, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.$4))),
        ]),
      ),
    )).toList());
  }
}








// ─── Mood Takvimi (Genel tab için) ──────────────────────────────────────────

class _MoodCalendar extends StatelessWidget {
  const _MoodCalendar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    final monthName = DateFormat('MMMM', 'tr_TR').format(now);
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = (firstDay.weekday - 1) % 7;

    return CleanCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Mood Takvimi', style: AppTextStyles.heading(fontSize: 16, color: AppColors.ink)),
            const Spacer(),
            Text(monthName[0].toUpperCase() + monthName.substring(1),
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
          ]),
          const SizedBox(height: 18),
          // Gün başlıkları
          Row(children: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'].map((d) => Expanded(
            child: Text(d, textAlign: TextAlign.center, style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
          )).toList()),
          const SizedBox(height: 8),
          // Takvim grid — mood yüzleriyle
          ...List.generate(5, (week) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(children: List.generate(7, (dow) {
              final dayNum = week * 7 + dow - startWeekday + 1;
              if (dayNum < 1 || dayNum > daysInMonth) {
                return const Expanded(child: SizedBox(height: 36));
              }

              final mood = MockMoodData.getMoodForDay(dayNum);
              final isToday = dayNum == now.day;

              return Expanded(
                child: Container(
                  height: 36,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: mood != null
                        ? mood.color.withValues(alpha: isToday ? 0.35 : 0.15)
                        : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
                    borderRadius: BorderRadius.circular(10),
                    border: isToday ? Border.all(color: AppColors.darkCard, width: 2) : null,
                  ),
                  child: Center(
                    child: mood != null
                        ? MoodFace(type: mood.face, color: mood.color, size: 30)
                        : Text('$dayNum', style: TextStyle(fontSize: 10,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.25))),
                  ),
                ),
              );
            })),
          )),
        ],
      ),
    );
  }
}

// ─── Aylık Mood Özeti ───────────────────────────────────────────────────────

class _MoodSummaryCard extends StatelessWidget {
  const _MoodSummaryCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = MockMoodData.monthlySummary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            summary.color.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bu Ay', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                const SizedBox(height: 6),
                Text(summary.label, style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800, color: summary.color)),
                const SizedBox(height: 4),
                Text('${MockMoodData.loggedDays}/${MockMoodData.totalDays} gün kayıt yaptın',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
              ],
            ),
          ),
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: summary.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: MoodFace(type: summary.face, color: summary.color, size: 50),
          ),
        ],
      ),
    );
  }
}


// ─── Büyük Tam Genişlik Kart ────────────────────────────────────────────────


class _MoodChip extends StatelessWidget {
  const _MoodChip({required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.softPink.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(color: AppColors.softPink.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
      ),
    );
  }
}


class _QuickActionBtn extends StatelessWidget {
  const _QuickActionBtn({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.softPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 24, color: AppColors.ink.withValues(alpha: 0.6)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.5))),
          ]),
        ),
      ),
    );
  }
}


// ─── Soft Card — pastel arka planlı, gölgeli, yuvarlak köşeli ──────────────

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}

// ─── Sparkle dekoratif yıldız ──────────────────────────────────────────────

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome, size: size, color: color);
  }
}

// ─── Hero Day Card — büyük gün göstergesi + yıldızlar ──────────────────────

class _HeroDayCard extends StatelessWidget {
  const _HeroDayCard({required this.phase, required this.isDark, required this.cycleState});
  final CyclePhaseInfo phase;
  final bool isDark;
  final CycleState cycleState;

  @override
  Widget build(BuildContext context) {
    final cycleDay = cycleState.currentCycleDay;
    final isOn = cycleState.isOnPeriod;
    final prediction = cycleState.daysUntilNextPeriod;

    String subtitle;
    if (isOn) {
      subtitle = 'adet günlerinde kendine nazik ol.';
    } else if (prediction != null && prediction <= 5) {
      subtitle = 'adetin yaklaşıyor, hazırlıklı ol.';
    } else {
      subtitle = 'kendine iyi bak.';
    }

    String info;
    if (isOn) {
      info = 'Adet · ${cycleState.activePeriod!.lengthDays}. gün';
    } else if (prediction != null) {
      info = 'Tahmini $prediction gün sonra';
    } else {
      info = '${phase.label} fazı · $cycleDay. gün';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 26),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.gradientDeepPurple : AppColors.gradientWarmSunset,
        borderRadius: BorderRadius.circular(32),
        boxShadow: isDark ? null : [
          BoxShadow(color: AppColors.warmOrange.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(top: -4, right: 0, child: _Sparkle(size: 24, color: Colors.white.withValues(alpha: 0.5))),
          Positioned(top: 24, right: 36, child: _Sparkle(size: 14, color: Colors.white.withValues(alpha: 0.35))),
          Positioned(bottom: 0, right: 16, child: _Sparkle(size: 18, color: Colors.white.withValues(alpha: 0.4))),
          Positioned(top: 14, left: 12, child: _Sparkle(size: 10, color: Colors.white.withValues(alpha: 0.3))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$cycleDay. gün',
                style: TextStyle(
                  fontSize: 52, fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic, letterSpacing: -2,
                  height: 1.0, color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: AppTextStyles.accent(fontSize: 22, color: Colors.white.withValues(alpha: 0.8))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(info, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
              ),
              if (!cycleState.canPredict) ...[
                const SizedBox(height: 8),
                Text(
                  'Kayıt yaptıkça seni daha iyi tanıyacağız',
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.45)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Icon Badge — yuvarlak kare ikon kutusu ────────────────────────────────

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }
}

// ─── Circle Arrow — yuvarlak ok butonu ─────────────────────────────────────

class _CircleArrow extends StatelessWidget {
  const _CircleArrow({this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.gradientPinkOrange,
      ),
      child: Icon(Icons.arrow_forward_rounded, size: size * 0.45, color: Colors.white),
    );
  }
}
