import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/arc_mood_selector.dart';
import '../../../shared/widgets/cycle_wheel.dart';
import '../../../shared/widgets/mesh_gradient_bg.dart';
import '../../../shared/widgets/mood_face.dart';
import '../data/mock_cycle_data.dart';
import '../data/mock_mood_data.dart';

class CycleTrackingScreen extends StatefulWidget {
  const CycleTrackingScreen({super.key});

  @override
  State<CycleTrackingScreen> createState() => _CycleTrackingScreenState();
}

class _CycleTrackingScreenState extends State<CycleTrackingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _staggered({required int index, required Widget child}) {
    final delay = (index * 0.1).clamp(0.0, 0.5);
    final end = (delay + 0.5).clamp(0.0, 1.0);
    final curve = CurvedAnimation(
      parent: _animController,
      curve: Interval(delay, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curve,
      builder: (context, _) => Opacity(
        opacity: curve.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - curve.value)),
          child: child,
        ),
      ),
    );
  }

  void _switchTab(int index) {
    if (index == _tabIndex) return;
    setState(() => _tabIndex = index);
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final phase = MockCycleData.currentPhase;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          MeshGradientBg(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _Header(phase: phase),
                      const SizedBox(height: 18),
                      _TabBar(selectedIndex: _tabIndex, onTap: _switchTab, isDark: isDark),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _tabIndex == 0
                          ? _TodayTab(key: const ValueKey(0), phase: phase, staggered: _staggered)
                          : _tabIndex == 1
                              ? _WeeklyTab(key: const ValueKey(1), staggered: _staggered)
                              : _OverallTab(key: const ValueKey(2), staggered: _staggered),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab Bar ────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selectedIndex, required this.onTap, required this.isDark});
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labels = ['Bugün', 'Haftalık', 'Genel'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: labels.asMap().entries.map((e) {
          final isSelected = e.key == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Header ─────────────────────────────────────────────────────────────────

class _Header extends ConsumerWidget {
  const _Header({required this.phase});
  final CyclePhaseInfo phase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryContainer,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
          ),
          child: const Center(
            child: Text('E', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Merhaba, ${MockCycleData.userName}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text(
                DateFormat('d MMMM, EEEE', 'tr_TR').format(DateTime.now()),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
        _SmallButton(
          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          onTap: () => ref.read(themeModeProvider.notifier).state = isDark ? ThemeMode.light : ThemeMode.dark,
        ),
        const SizedBox(width: 6),
        _SmallButton(icon: Icons.notifications_none_rounded, onTap: () {}),
      ],
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

// ─── Bugün Tab ──────────────────────────────────────────────────────────────

class _TodayTab extends StatelessWidget {
  const _TodayTab({super.key, required this.phase, required this.staggered});
  final CyclePhaseInfo phase;
  final Widget Function({required int index, required Widget child}) staggered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Dairesel döngü çarkı
        staggered(index: 0, child: Center(
          child: CycleWheel(
            data: CycleWheelData(
              currentDay: MockCycleData.currentCycleDay,
              cycleLength: MockCycleData.cycleLengthDays,
              periodDays: MockCycleData.periodLengthDays,
              ovulationDays: const [14, 15, 16],
              phases: [
                CycleWheelPhase(label: 'Adet', startDay: 1, endDay: 5, color: AppColors.phaseMenstruation),
                CycleWheelPhase(label: 'Foliküler', startDay: 6, endDay: 13, color: AppColors.phaseFollicular),
                CycleWheelPhase(label: 'Ovülasyon', startDay: 14, endDay: 16, color: AppColors.phaseOvulation),
                CycleWheelPhase(label: 'Luteal', startDay: 17, endDay: 28, color: AppColors.phaseLuteal),
              ],
            ),
            onAddTap: () => _QuickActions._showDailyLog(context),
          ),
        )),
        const SizedBox(height: 16),

        // 2. Tahmin bilgileri
        staggered(index: 1, child: Center(
          child: Column(children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.phaseMenstruation, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('Sonraki adet: ~${MockCycleData.daysUntilNextPeriod} gün',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.phaseOvulation, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('${phase.label} fazındasın',
                style: TextStyle(fontSize: 14, color: phase.color, fontWeight: FontWeight.w700)),
            ]),
          ]),
        )),
        const SizedBox(height: 20),

        // 3. Günlük tahmin metni
        staggered(index: 2, child: _BentoCard(
          isDark: isDark,
          shape: _CardShape.pill,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: phase.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.auto_awesome_rounded, size: 16, color: phase.color),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(
                phase.tip,
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7), height: 1.4),
              )),
            ],
          ),
        )),
        const SizedBox(height: 14),

        // 4. Hızlı aksiyonlar
        staggered(index: 1, child: Row(children: [
          Expanded(child: _BentoMiniAction(icon: Icons.mood_outlined, label: 'Ruh Hali', color: AppColors.primary, isDark: isDark,
            onTap: () => _QuickActions._showMoodSelector(context))),
          const SizedBox(width: 10),
          Expanded(child: _BentoMiniAction(icon: Icons.edit_calendar_outlined, label: 'Kaydet', color: AppColors.tertiary, isDark: isDark,
            onTap: () => _QuickActions._showDailyLog(context))),
          const SizedBox(width: 10),
          Expanded(child: _BentoMiniAction(icon: Icons.healing_outlined, label: 'Semptom', color: AppColors.phaseMenstruation, isDark: isDark,
            onTap: () => _QuickActions._showSymptoms(context))),
          const SizedBox(width: 10),
          Expanded(child: _BentoMiniAction(icon: Icons.sticky_note_2_outlined, label: 'Not', color: AppColors.phaseFollicular, isDark: isDark,
            onTap: () => _QuickActions._showNote(context))),
        ])),
        const SizedBox(height: 14),

        // 4. Takvim
        staggered(index: 3, child: const _MonthCalendar()),
        const SizedBox(height: 14),

        // 5. Bedeninde ne oluyor
        staggered(index: 4, child: _BodyInfoCard(phase: phase)),
        const SizedBox(height: 14),

        // 6. Kendine iyi bak + Döngü istatistikleri
        staggered(index: 5, child: SizedBox(
          height: 170,
          child: Row(children: [
            // Kendine iyi bak — büyük
            Expanded(
              flex: 3,
              child: _BentoCard(
                isDark: isDark,
                shape: _CardShape.softSquare,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.favorite_outline_rounded, size: 16, color: phase.color),
                      const SizedBox(width: 8),
                      Text('Kendine İyi Bak', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: phase.color)),
                    ]),
                    const SizedBox(height: 12),
                    ...phase.selfCare.take(3).map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(color: phase.color.withValues(alpha: 0.5), shape: BoxShape.circle)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(tip, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.35))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Döngü bilgisi — küçük
            Expanded(
              flex: 2,
              child: Column(children: [
                Expanded(child: _BentoStatCard(value: '28', unit: 'gün', label: 'Döngü', color: AppColors.primary, isDark: isDark)),
                const SizedBox(height: 10),
                Expanded(child: _BentoStatCard(value: '5', unit: 'gün', label: 'Adet', color: AppColors.phaseMenstruation, isDark: isDark)),
              ]),
            ),
          ]),
        )),
        const SizedBox(height: 14),

        // 7. Bunu biliyor muydun
        staggered(index: 7, child: SizedBox(
          height: 120,
          child: Row(children: [
            Expanded(child: _BentoCard(
              onTap: () => _QuickActions._showNote(context),
              isDark: isDark,
              shape: _CardShape.pill,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sticky_note_2_outlined, size: 22, color: AppColors.tertiary),
                  ),
                  const SizedBox(height: 10),
                  Text('Günlük Not', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  Text('Düşüncelerini yaz', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                ],
              ),
            )),
            const SizedBox(width: 12),
            Expanded(child: _BentoCard(
              isDark: isDark,
              shape: _CardShape.archBottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 22, color: AppColors.phaseOvulation),
                  const SizedBox(height: 8),
                  Text(
                    MockCycleData.didYouKnow[DateTime.now().day % MockCycleData.didYouKnow.length],
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.35),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )),
          ]),
        )),
        const SizedBox(height: 14),

        // 8. Timeline
        staggered(index: 8, child: const _CycleTimeline()),
        const SizedBox(height: 100),
      ],
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
    _sheet(context, (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
      _sheetHandle(context),
      const SizedBox(height: 20),
      ArcMoodSelector(onMoodSelected: (mood) => Navigator.pop(ctx)),
      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 8),
    ]));
  }

  static void _showDailyLog(BuildContext context) {
    final theme = Theme.of(context);
    _sheet(context, (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
      _sheetHandle(context),
      const SizedBox(height: 24),
      Text('Bugünü Kaydet', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text('Akış yoğunluğunu seç', style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
      const SizedBox(height: 24),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _FlowOption(label: 'Yok', icon: Icons.remove_rounded, color: Colors.grey),
        _FlowOption(label: 'Az', icon: Icons.water_drop_outlined, color: AppColors.phaseMenstruation.withValues(alpha: 0.5)),
        _FlowOption(label: 'Normal', icon: Icons.water_drop_rounded, color: AppColors.phaseMenstruation.withValues(alpha: 0.75)),
        _FlowOption(label: 'Yoğun', icon: Icons.opacity_rounded, color: AppColors.phaseMenstruation),
      ]),
      const SizedBox(height: 24),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
        onPressed: () => Navigator.pop(ctx), child: const Text('Kaydet'))),
      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
    ]));
  }

  static void _showSymptoms(BuildContext context) {
    final theme = Theme.of(context);
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
        Text('Semptomlar', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
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
          onPressed: () => Navigator.pop(ctx),
          child: Text(selected.isEmpty ? 'Atla' : 'Kaydet (${selected.length})'))),
        SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
      ]);
    }));
  }

  static void _showNote(BuildContext context) {
    final theme = Theme.of(context);
    _sheet(context, (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
      _sheetHandle(context),
      const SizedBox(height: 24),
      Text('Günlük Not', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 20),
      TextField(maxLines: 4, decoration: InputDecoration(
        hintText: 'Bugün nasıl hissediyorum...', border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), filled: true)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
        onPressed: () => Navigator.pop(ctx), child: const Text('Kaydet'))),
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
  const _FlowOption({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(width: 52, height: 52,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, size: 26, color: color)),
      const SizedBox(height: 5),
      Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
    ]);
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
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.45),
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
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Icon(Icons.chevron_left_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ]),
          const SizedBox(height: 14),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.auto_awesome_rounded, size: 16, color: phase.color),
            const SizedBox(width: 8),
            Text('Bedeninde Ne Oluyor?', style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: phase.color)),
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
        staggered(index: 0, child: Text('Bu Hafta', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800))),
        const SizedBox(height: 4),
        staggered(index: 0, child: Text('Bugün sekmesinden kayıt ekle',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)))),
        const SizedBox(height: 18),
        staggered(index: 1, child: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Row(children: _days.map((d) => Expanded(
            child: Text(d, textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35), fontWeight: FontWeight.w600, fontSize: 10)),
          )).toList()),
        )),
        const SizedBox(height: 8),
        ..._habits.asMap().entries.map((e) => staggered(index: e.key + 2, child: _HabitTrackCard(habit: e.value))),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: CleanCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(children: [
          Container(width: 28, height: 28,
            decoration: BoxDecoration(color: habit.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(7)),
            child: Icon(habit.icon, size: 14, color: habit.color)),
          const SizedBox(width: 8),
          SizedBox(width: 50, child: Text(habit.label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ...habit.checks.map((done) => Expanded(child: Center(child: Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: done ? habit.color.withValues(alpha: 0.15) : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
              shape: BoxShape.circle,
              border: done ? null : Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06))),
            child: done ? Icon(Icons.check_rounded, size: 12, color: habit.color) : null,
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
        staggered(index: 0, child: Text('Genel Bakış', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800))),
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
        const SizedBox(height: 14),
        staggered(index: 4, child: const _MoodCalendar()),
        const SizedBox(height: 20),
        staggered(index: 5, child: Text('Döngü Geçmişi', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
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
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(width: 3),
          Padding(padding: const EdgeInsets.only(bottom: 4),
            child: Text(unit, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.6)))),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: CleanCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          Container(width: 34, height: 34,
            decoration: BoxDecoration(color: c.$4.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(9)),
            child: Icon(Icons.calendar_month_outlined, size: 16, color: c.$4)),
          const SizedBox(width: 12),
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

// ─── Döngü Zaman Çizelgesi ──────────────────────────────────────────────────

class _CycleTimeline extends StatelessWidget {
  const _CycleTimeline();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final events = [
      _TimelineEvent(dateRange: '7 — 11 Haz', label: 'Adet Dönemi', subtitle: 'Rahim iç tabakası döküldü', color: AppColors.phaseMenstruation, icon: Icons.water_drop_rounded, isPast: true),
      _TimelineEvent(dateRange: '12 — 18 Haz', label: 'Foliküler Faz', subtitle: 'Yeni yumurta hazırlandı', color: AppColors.phaseFollicular, icon: Icons.eco_rounded, isPast: true),
      _TimelineEvent(dateRange: '19 — 21 Haz', label: 'Ovülasyon', subtitle: 'Yumurta serbest bırakıldı', color: AppColors.phaseOvulation, icon: Icons.brightness_high_rounded, isPast: false),
      _TimelineEvent(dateRange: '22 Haz — 5 Tem', label: 'Luteal Faz', subtitle: 'Vücut dinlenmeye geçiyor', color: AppColors.phaseLuteal, icon: Icons.nights_stay_rounded, isPast: false),
      _TimelineEvent(dateRange: '6 Tem', label: 'Sonraki Adet', subtitle: 'Döngü yeniden başlıyor', color: AppColors.phaseMenstruation, icon: Icons.event_rounded, isPast: false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Zaman Çizelgesi', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        ...events.asMap().entries.map((e) {
          final event = e.value;
          final isLast = e.key == events.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol: tarih
                SizedBox(
                  width: 58,
                  child: Text(event.dateRange, style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: event.isPast
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.35)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  )),
                ),
                // Orta: çizgi + nokta
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(
                          color: event.isPast ? event.color.withValues(alpha: 0.3) : event.color,
                          shape: BoxShape.circle,
                          border: event.isPast ? null : Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      if (!isLast) Expanded(
                        child: Container(
                          width: 2,
                          color: event.color.withValues(alpha: event.isPast ? 0.15 : 0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                // Sağ: içerik kartı
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: event.isPast
                            ? (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.35))
                            : (isDark ? AppColors.darkCard.withValues(alpha: 0.9) : AppColors.darkCard),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: event.color.withValues(alpha: event.isPast ? 0.1 : 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(event.icon, size: 16, color: event.isPast ? event.color.withValues(alpha: 0.5) : event.color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.label, style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700,
                                color: event.isPast
                                    ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                                    : (isDark ? Colors.white : Colors.white),
                              )),
                              Text(event.subtitle, style: TextStyle(
                                fontSize: 10,
                                color: event.isPast
                                    ? theme.colorScheme.onSurface.withValues(alpha: 0.35)
                                    : Colors.white.withValues(alpha: 0.5),
                              )),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _TimelineEvent {
  const _TimelineEvent({
    required this.dateRange, required this.label, required this.subtitle,
    required this.color, required this.icon, required this.isPast,
  });
  final String dateRange, label, subtitle;
  final Color color;
  final IconData icon;
  final bool isPast;
}




// ─── Bento Kart Bileşenleri ─────────────────────────────────────────────────

class _BentoCard extends StatelessWidget {
  const _BentoCard({required this.child, required this.isDark, this.onTap, this.shape});
  final Widget child;
  final bool isDark;
  final VoidCallback? onTap;
  final _CardShape? shape;

  @override
  Widget build(BuildContext context) {
    final radius = switch (shape) {
      _CardShape.archTop => const BorderRadius.only(
        topLeft: Radius.circular(32), topRight: Radius.circular(32),
        bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      _CardShape.archBottom => const BorderRadius.only(
        topLeft: Radius.circular(16), topRight: Radius.circular(16),
        bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      _CardShape.pill => BorderRadius.circular(28),
      _CardShape.softSquare => BorderRadius.circular(22),
      _ => BorderRadius.circular(20),
    };

    final content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.white.withValues(alpha: 0.55),
        borderRadius: radius,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.4),
        ),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}

enum _CardShape { archTop, archBottom, pill, softSquare }

class _BentoMiniAction extends StatelessWidget {
  const _BentoMiniAction({required this.icon, required this.label, required this.color, required this.isDark, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

class _BentoStatCard extends StatelessWidget {
  const _BentoStatCard({required this.value, required this.unit, required this.label, required this.color, required this.isDark});
  final String value, unit, label;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(text: TextSpan(children: [
            TextSpan(text: value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
            TextSpan(text: ' $unit', style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.6))),
          ])),
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
        ],
      ),
    );
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
            Text('Mood Takvimi', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(monthName[0].toUpperCase() + monthName.substring(1),
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
          ]),
          const SizedBox(height: 14),
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
