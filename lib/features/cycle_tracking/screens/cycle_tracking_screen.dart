import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_cycle_data.dart';
import '../data/mock_wellness_data.dart';

class CycleTrackingScreen extends ConsumerStatefulWidget {
  const CycleTrackingScreen({super.key});

  @override
  ConsumerState<CycleTrackingScreen> createState() => _CycleTrackingScreenState();
}

class _CycleTrackingScreenState extends ConsumerState<CycleTrackingScreen>
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
    final cycle = ref.watch(cycleProvider);
    final phase = MockCycleData.phaseForDay(cycle.currentCycleDay, cycleLength: cycle.averageCycleLength);

    return Scaffold(
      backgroundColor: AppColors.surfaceVariantLight,
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
                  // gradientHeroSoft biter beyaza — bu ekranın arkaplanı ise
                  // hafif tonlu (surfaceVariantLight), o yüzden burada kendi
                  // arkaplanımıza biten bir versiyon kullanıyoruz (dikişsiz geçiş).
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [AppColors.heroPink, AppColors.heroPeach, AppColors.surfaceVariantLight],
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
                    colors: [AppColors.heroPink, AppColors.heroPeach, Color(0x00FFFFFF)],
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
                      const Spacer(),
                      _SmallButton(icon: Icons.settings_outlined, onTap: () {}),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  // Döngü durumu kartı — tek net "bugün nasılım" cevabı + tek ana eylem
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _staggered(index: 0, child: Container(
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
                        const SizedBox(height: 12),
                        // Adetin ne zaman başladı / sonraki tahmini ne zaman
                        Builder(builder: (ctx) {
                          final String info;
                          if (cycle.isOnPeriod) {
                            info = '${DateFormat('d MMMM', 'tr_TR').format(cycle.activePeriod!.startDate)} tarihinde başladı';
                          } else if (cycle.daysUntilNextPeriod != null) {
                            info = 'Sonraki adet tahmini: ${cycle.daysUntilNextPeriod} gün sonra · ${DateFormat('d MMMM', 'tr_TR').format(cycle.nextPeriodEstimate!)}';
                          } else {
                            info = 'Kayıt yaptıkça tahminlerin daha isabetli olur';
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(info, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.7))),
                          );
                        }),
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

                  // Bugünü kaydet — tek nötr panel, renk sadece hero'da
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Bugünü Kaydet', style: AppTextStyles.heading(fontSize: 24, color: AppColors.ink)),
                  ),
                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _staggered(index: 1, child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // Ruh hali
                        Row(children: [
                          Icon(Icons.mood_outlined, size: 18, color: AppColors.warmOrange),
                          const SizedBox(width: 8),
                          Text('Ruh Hali', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.6))),
                        ]),
                        const SizedBox(height: 12),
                        Builder(builder: (ctx) {
                          return _MoodPicker(
                            initialMood: cycle.todayLog?.mood,
                            onSelected: (mood) => ProviderScope.containerOf(ctx).read(cycleProvider.notifier).logMood(mood),
                          );
                        }),

                        _QuickLogDivider(),

                        // Su / Uyku
                        Row(children: [
                          Expanded(child: _WaterGauge(phase: phase.phase)),
                          const SizedBox(width: 16),
                          Expanded(child: _QuickStat(
                            icon: Icons.nightlight_outlined,
                            label: 'Uyku',
                            value: MockWellnessData.forPhase(phase.phase).sleepHours,
                          )),
                        ]),

                        _QuickLogDivider(),

                        // Semptom / Not
                        Row(children: [
                          Expanded(child: _QuickLogAction(
                            icon: Icons.healing_outlined,
                            label: 'Semptom',
                            caption: 'Kaydet',
                            onTap: () => _showSymptoms(context),
                          )),
                          const SizedBox(width: 16),
                          Expanded(child: _QuickLogAction(
                            icon: Icons.sticky_note_2_outlined,
                            label: 'Günlük Not',
                            caption: 'Yaz',
                            onTap: () => _showNote(context),
                          )),
                        ]),
                        const SizedBox(height: 16),
                        // İlaç
                        _QuickLogAction(
                          icon: Icons.medication_outlined,
                          label: 'İlaçlarım',
                          caption: 'Bugün aldıklarını işaretle',
                          onTap: () => _showMedications(context),
                        ),
                      ]),
                    )),
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

// İlaçlarım — kullanıcının kendi yazdığı isim + bugün kaç kez alındığı sayacı.
// Kasıtlı olarak doz/mg gibi hiçbir tıbbi bilgi/öneri içermiyor, sadece kişisel bir sayım.
void _showMedications(BuildContext context) {
  final theme = Theme.of(context);
  final container = ProviderScope.containerOf(context);
  final controller = TextEditingController();
  _sheet(context, (ctx) => StatefulBuilder(builder: (ctx, setSt) {
    final cycle = container.read(cycleProvider);
    final names = cycle.medicationNames;
    final counts = cycle.todayLog?.medications ?? const {};

    void adjust(String name, int delta) {
      final newCount = ((counts[name] ?? 0) + delta).clamp(0, 20);
      container.read(cycleProvider.notifier).logMedicationCount(name, newCount);
      setSt(() {});
    }

    void addNew() {
      final name = controller.text.trim();
      if (name.isEmpty) return;
      container.read(cycleProvider.notifier).addMedication(name);
      controller.clear();
      setSt(() {});
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      _sheetHandle(context),
      const SizedBox(height: 24),
      Text('İlaçlarım', style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface)),
      const SizedBox(height: 6),
      Text('Kendi ilacını ekle, bugün kaç kez aldığını işaretle', style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
      const SizedBox(height: 20),
      if (names.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('Henüz ilaç eklemedin', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
        ),
      ...names.map((name) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: AppColors.cardCream, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink))),
            Text('${counts[name] ?? 0}x', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink.withValues(alpha: 0.5))),
            const SizedBox(width: 10),
            _StepperBtn(icon: Icons.remove_rounded, onTap: () => adjust(name, -1)),
            const SizedBox(width: 6),
            _StepperBtn(icon: Icons.add_rounded, onTap: () => adjust(name, 1)),
          ]),
        ),
      )),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'İlaç adı ekle...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
          ),
        )),
        const SizedBox(width: 8),
        SizedBox(height: 48, child: ElevatedButton(onPressed: addNew, child: const Text('Ekle'))),
      ]),
      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
    ]);
  }));
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

// ─── Ruh hali seçici — büyük animasyonlu gösterge + küçük seçim ikonları ───

class _MoodPicker extends StatefulWidget {
  const _MoodPicker({required this.initialMood, required this.onSelected});
  final String? initialMood;
  final ValueChanged<String> onSelected;

  @override
  State<_MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<_MoodPicker> {
  late String? _mood = widget.initialMood;

  static const _moods = [
    ('Mutlu', Icons.sentiment_satisfied_rounded),
    ('Sakin', Icons.self_improvement_rounded),
    ('Yorgun', Icons.bedtime_rounded),
    ('Hassas', Icons.favorite_rounded),
    ('Sinirli', Icons.sentiment_very_dissatisfied_rounded),
  ];

  void _select(String mood) {
    setState(() => _mood = mood);
    widget.onSelected(mood);
  }

  @override
  Widget build(BuildContext context) {
    (String, IconData)? selected;
    for (final m in _moods) {
      if (m.$1 == _mood) { selected = m; break; }
    }

    return Column(children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: Container(
          key: ValueKey(_mood),
          width: 72, height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.softPink.withValues(alpha: selected == null ? 0.1 : 0.2),
          ),
          child: Icon(selected?.$2 ?? Icons.mood_outlined, size: 34, color: AppColors.softPink),
        ),
      ),
      const SizedBox(height: 6),
      Text(_mood ?? 'Nasıl hissediyorsun?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.5))),
      const SizedBox(height: 14),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _moods.map((m) {
        final isSelected = _mood == m.$1;
        return GestureDetector(
          onTap: () => _select(m.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.ink : Colors.white,
              border: Border.all(color: isSelected ? AppColors.ink : AppColors.softPink.withValues(alpha: 0.3)),
              boxShadow: isSelected ? null : [
                BoxShadow(color: AppColors.softPink.withValues(alpha: 0.12), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(m.$2, size: 20, color: isSelected ? Colors.white : AppColors.ink.withValues(alpha: 0.4)),
          ),
        );
      }).toList()),
    ]);
  }
}

// ─── Su göstergesi — dolan kapsül + artı/eksi ──────────────────────────────

class _WaterGauge extends StatefulWidget {
  const _WaterGauge({required this.phase});
  final CyclePhase phase;

  @override
  State<_WaterGauge> createState() => _WaterGaugeState();
}

class _WaterGaugeState extends State<_WaterGauge> {
  void _adjust(int delta) {
    setState(() {
      MockWellnessData.waterDrunk = (MockWellnessData.waterDrunk + delta).clamp(0, MockWellnessData.forPhase(widget.phase).waterGoal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final goal = MockWellnessData.forPhase(widget.phase).waterGoal;
    final drunk = MockWellnessData.waterDrunk;
    final ratio = goal == 0 ? 0.0 : (drunk / goal).clamp(0.0, 1.0);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.water_drop_outlined, size: 16, color: AppColors.softPink),
        const SizedBox(width: 6),
        Text('Su', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.6))),
      ]),
      const SizedBox(height: 10),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 30, height: 60,
            color: AppColors.softPink.withValues(alpha: 0.12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (_, val, _) => FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: val,
                  child: Container(color: AppColors.softPink),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(text: TextSpan(children: [
            TextSpan(text: '$drunk/$goal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink)),
            TextSpan(text: ' bardak', style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.4))),
          ])),
          const SizedBox(height: 8),
          Row(children: [
            _StepperBtn(icon: Icons.remove_rounded, onTap: () => _adjust(-1)),
            const SizedBox(width: 8),
            _StepperBtn(icon: Icons.add_rounded, onTap: () => _adjust(1)),
          ]),
        ])),
      ]),
    ]);
  }
}

class _StepperBtn extends StatelessWidget {
  const _StepperBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.softPink.withValues(alpha: 0.15),
        ),
        child: Icon(icon, size: 16, color: AppColors.softPink),
      ),
    );
  }
}

class _QuickLogDivider extends StatelessWidget {
  const _QuickLogDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Container(height: 1, color: AppColors.ink.withValues(alpha: 0.06)),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 16, color: AppColors.softPink),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.6))),
      ]),
      const SizedBox(height: 10),
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink)),
    ]);
  }
}

class _QuickLogAction extends StatelessWidget {
  const _QuickLogAction({required this.icon, required this.label, required this.caption, required this.onTap});
  final IconData icon;
  final String label;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.warmOrange),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
          Text(caption, style: TextStyle(fontSize: 11, color: AppColors.ink.withValues(alpha: 0.4))),
        ])),
      ]),
    );
  }
}
