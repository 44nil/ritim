import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_cycle_data.dart';
import '../data/mock_wellness_data.dart';

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
                          onTap: () => _showSymptoms(context),
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
                          onTap: () => _showNote(context),
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

void _showSymptoms(BuildContext context) {
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

void _showNote(BuildContext context) {
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

void _sheet(BuildContext context, Widget Function(BuildContext) builder) {
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

Widget _sheetHandle(BuildContext context) {
  return Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))));
}

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
