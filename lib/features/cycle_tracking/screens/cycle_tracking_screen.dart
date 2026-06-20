import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/cycle_phase_ring.dart';
import '../../../shared/widgets/arc_mood_selector.dart';
import '../../../shared/widgets/floating_particles.dart';
import '../../../shared/widgets/mesh_gradient_bg.dart';
import '../data/mock_cycle_data.dart';

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
    final delay = (index * 0.12).clamp(0.0, 0.6);
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
          offset: Offset(0, 24 * (1 - curve.value)),
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
          const FloatingParticles(),

          SafeArea(
            child: Column(
              children: [
                // Header + Tab bar (sabit)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _Header(phase: phase),
                      const SizedBox(height: 20),
                      // Tab bar
                      _TabBar(
                        selectedIndex: _tabIndex,
                        onTap: _switchTab,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Tab içeriği (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: labels.asMap().entries.map((e) {
          final isSelected = e.key == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
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

// ─── Bugün Tab ──────────────────────────────────────────────────────────────

class _TodayTab extends StatelessWidget {
  const _TodayTab({super.key, required this.phase, required this.staggered});
  final CyclePhaseInfo phase;
  final Widget Function({required int index, required Widget child}) staggered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        staggered(index: 0, child: _HeroCard(phase: phase)),
        const SizedBox(height: 20),
        staggered(index: 1, child: _QuickActions()),
        const SizedBox(height: 20),
        staggered(index: 2, child: _WeekCalendar()),
        const SizedBox(height: 20),
        staggered(index: 3, child: _InsightCard(phase: phase)),
        const SizedBox(height: 100),
      ],
    );
  }
}

// ─── Haftalık Tab ───────────────────────────────────────────────────────────

class _WeeklyTab extends StatelessWidget {
  const _WeeklyTab({super.key, required this.staggered});
  final Widget Function({required int index, required Widget child}) staggered;

  static const _days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  static const _habits = [
    _HabitRow(label: 'Döngü kaydı', icon: Icons.water_drop_outlined, color: AppColors.phaseMenstruation,
      checks: [true, true, true, false, true, true, false]),
    _HabitRow(label: 'Ruh hali', icon: Icons.mood_outlined, color: AppColors.secondary,
      checks: [true, true, false, true, true, false, false]),
    _HabitRow(label: 'Semptom takibi', icon: Icons.healing_outlined, color: AppColors.primary,
      checks: [true, false, true, true, false, true, false]),
    _HabitRow(label: 'Su içme', icon: Icons.local_drink_outlined, color: AppColors.phaseFollicular,
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
        staggered(
          index: 0,
          child: Text('Bu Hafta', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 4),
        staggered(
          index: 0,
          child: Text(
            'Günlük kayıtların',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(height: 20),

        // Gün başlıkları
        staggered(
          index: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 130),
            child: Row(
              children: _days.map((d) => Expanded(
                child: Text(d, textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w600,
                )),
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Habit rows
        ..._habits.asMap().entries.map((e) => staggered(
          index: e.key + 2,
          child: _HabitTrackCard(habit: e.value),
        )),

        const SizedBox(height: 100),
      ],
    );
  }
}

class _HabitRow {
  const _HabitRow({required this.label, required this.icon, required this.color, required this.checks});
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CleanCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: habit.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(habit.icon, size: 16, color: habit.color),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 76,
              child: Text(
                habit.label,
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...habit.checks.map((done) => Expanded(
              child: Center(
                child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: done
                        ? habit.color.withValues(alpha: 0.15)
                        : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03)),
                    shape: BoxShape.circle,
                  ),
                  child: done
                      ? Icon(Icons.check_rounded, size: 14, color: habit.color)
                      : null,
                ),
              ),
            )),
          ],
        ),
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
        staggered(
          index: 0,
          child: Text('Genel Bakış', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 4),
        staggered(
          index: 0,
          child: Text(
            'Döngü istatistiklerin',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(height: 20),

        // İstatistik kartları 2x2
        staggered(
          index: 1,
          child: Row(
            children: [
              Expanded(child: _StatBox(value: '28', label: 'Ort. döngü', unit: 'gün', color: AppColors.primary)),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: '92', label: 'Kayıt oranı', unit: '%', color: AppColors.phaseOvulation)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        staggered(
          index: 2,
          child: Row(
            children: [
              Expanded(child: _StatBox(value: '12', label: 'Gün serisi', unit: 'gün', color: AppColors.tertiary)),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: '3', label: 'Takip süresi', unit: 'ay', color: AppColors.secondary)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Aylık heatmap
        staggered(
          index: 3,
          child: Text('Haziran Kayıtları', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        staggered(index: 4, child: const _MonthlyHeatmap()),
        const SizedBox(height: 24),

        // Döngü geçmişi
        staggered(
          index: 5,
          child: Text('Döngü Geçmişi', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ),
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          )),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800, color: color,
              )),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit, style: theme.textTheme.labelSmall?.copyWith(
                  color: color.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlyHeatmap extends StatelessWidget {
  const _MonthlyHeatmap();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Mock: 30 gün, bazıları kayıtlı
    final logged = {1, 2, 3, 4, 5, 8, 9, 10, 11, 14, 15, 16, 17, 18, 19, 20};

    return CleanCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Gün başlıkları
          Row(
            children: ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'].map((d) => Expanded(
              child: Text(d, textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontSize: 9,
              )),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Grid — Haziran 2024 Pazar'dan başlıyor, offsetli
          ...List.generate(5, (week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (dayOfWeek) {
                  final dayNum = week * 7 + dayOfWeek - 5; // Haziran offset
                  if (dayNum < 1 || dayNum > 30) {
                    return const Expanded(child: SizedBox(height: 28));
                  }
                  final isLogged = logged.contains(dayNum);
                  final isToday = dayNum == 20;

                  Color cellColor;
                  if (isToday) {
                    cellColor = AppColors.primary;
                  } else if (isLogged) {
                    cellColor = AppColors.primary.withValues(alpha: 0.2);
                  } else {
                    cellColor = isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04);
                  }

                  return Expanded(
                    child: Container(
                      height: 28,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '$dayNum',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday
                                ? Colors.white
                                : (isLogged
                                    ? AppColors.primary
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
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

    return Column(
      children: cycles.map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CleanCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: c.$4.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.calendar_month_outlined, size: 18, color: c.$4),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.$1, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    Text(c.$2, style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c.$4.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(c.$3, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c.$4)),
              ),
            ],
          ),
        ),
      )).toList(),
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
    final dateStr = DateFormat('d MMMM, EEEE', 'tr_TR').format(DateTime.now());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryContainer,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
          ),
          child: const Center(
            child: Text('E', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Merhaba, ${MockCycleData.userName}', style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              )),
              Text(dateStr, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        _CircleButton(
          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          onTap: () {
            ref.read(themeModeProvider.notifier).state = isDark ? ThemeMode.light : ThemeMode.dark;
          },
        ),
        const SizedBox(width: 8),
        _CircleButton(icon: Icons.notifications_none_rounded, onTap: () {}),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
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
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.6),
          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.5)),
        ),
        child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
      ),
    );
  }
}

// ─── Hero Card ──────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.phase});
  final CyclePhaseInfo phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.5)),
          ),
          child: Stack(
            children: [
              Positioned(top: -30, right: -30, child: Container(width: 120, height: 120,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(
                  colors: [phase.color.withValues(alpha: isDark ? 0.15 : 0.2), phase.color.withValues(alpha: 0)],
                )))),
              Positioned(bottom: -40, left: -20, child: Container(width: 100, height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(
                  colors: [phase.color.withValues(alpha: isDark ? 0.1 : 0.12), phase.color.withValues(alpha: 0)],
                )))),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? phase.color.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(phase.icon, size: 14, color: phase.color),
                        const SizedBox(width: 6),
                        Text('${phase.label} Fazı', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: phase.color)),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Döngünün\n${MockCycleData.currentCycleDay}. günü', style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5,
                        )),
                        const SizedBox(height: 12),
                        Text('Sonraki adet ~${MockCycleData.daysUntilNextPeriod} gün sonra', style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        )),
                      ])),
                      CyclePhaseRing(progress: MockCycleData.cycleProgress, phaseColor: phase.color,
                        currentDay: MockCycleData.currentCycleDay, size: 100, strokeWidth: 7),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Quick Actions ──────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionChip(icon: Icons.edit_calendar_outlined, label: 'Kaydet', color: AppColors.primary, onTap: () {}),
        const SizedBox(width: 10),
        _ActionChip(icon: Icons.mood_outlined, label: 'Ruh Hali', color: AppColors.secondary, onTap: () => _showMoodSelector(context)),
        const SizedBox(width: 10),
        _ActionChip(icon: Icons.healing_outlined, label: 'Semptom', color: AppColors.phaseMenstruation, onTap: () {}),
        const SizedBox(width: 10),
        _ActionChip(icon: Icons.sticky_note_2_outlined, label: 'Not', color: AppColors.tertiary, onTap: () {}),
      ],
    );
  }

  static void _showMoodSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2),
          )),
          const SizedBox(height: 20),
          ArcMoodSelector(onMoodSelected: (mood) => Navigator.pop(ctx)),
          const SizedBox(height: 8),
        ]),
      ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.5)),
          ),
          child: Column(children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: color)),
            const SizedBox(height: 6),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

// ─── Week Calendar ──────────────────────────────────────────────────────────

class _WeekCalendar extends StatelessWidget {
  static const _dayLabels = ['Paz', 'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = MockCycleData.last7Days;
    return CleanCard(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Row(children: [
          Text('Bu Hafta', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('Takvim →', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: days.map((day) {
          final weekdayIndex = (day.date.weekday) % 7;
          return Column(children: [
            Text(_dayLabels[weekdayIndex], style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
            const SizedBox(height: 8),
            Container(width: 38, height: 38,
              decoration: BoxDecoration(
                color: day.isToday ? day.phase.color : day.phase.color.withValues(alpha: 0.1),
                shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text('${day.date.day}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: day.isToday ? Colors.white : day.phase.color))),
          ]);
        }).toList()),
      ]),
    );
  }
}

// ─── Insight Card ───────────────────────────────────────────────────────────

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.phase});
  final CyclePhaseInfo phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CleanCard(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: phase.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.lightbulb_outline_rounded, color: phase.color, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${phase.label} Fazı', style: theme.textTheme.labelMedium?.copyWith(color: phase.color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(phase.tip, style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.4)),
        ])),
      ]),
    );
  }
}
