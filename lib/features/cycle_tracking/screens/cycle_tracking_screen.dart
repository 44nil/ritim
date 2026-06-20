import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/cycle_phase_ring.dart';
import '../data/mock_cycle_data.dart';

class CycleTrackingScreen extends StatelessWidget {
  const CycleTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = MockCycleData.currentPhase;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.paddingM),
              _GreetingHeader(phase: phase),
              const SizedBox(height: AppConstants.paddingL),
              _MainCycleCard(phase: phase),
              const SizedBox(height: AppConstants.paddingM),
              const _QuickActionsGrid(),
              const SizedBox(height: AppConstants.paddingM),
              const _WeekStrip(),
              const SizedBox(height: AppConstants.paddingM),
              _PhaseInfoCard(phase: phase),
              const SizedBox(height: AppConstants.paddingXL),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 1. Karşılama Başlığı ──────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.phase});
  final CyclePhaseInfo phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateStr = DateFormat('d MMMM, EEEE', 'tr_TR').format(now);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Merhaba, ${MockCycleData.userName} 👋',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        // Bildirim butonu
        IconButton(
          onPressed: () {
            // TODO: Backend entegrasyonu — bildirimler
          },
          icon: const Icon(Icons.notifications_outlined),
          style: IconButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            fixedSize: const Size(44, 44),
          ),
        ),
      ],
    );
  }
}

// ─── 2. Ana Döngü Kartı ────────────────────────────────────────────────────

class _MainCycleCard extends StatelessWidget {
  const _MainCycleCard({required this.phase});
  final CyclePhaseInfo phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      gradient: LinearGradient(
        colors: isDark
            ? [
                phase.color.withValues(alpha: 0.15),
                phase.color.withValues(alpha: 0.05),
              ]
            : [
                phase.color.withValues(alpha: 0.08),
                phase.color.withValues(alpha: 0.03),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: phase.color.withValues(alpha: isDark ? 0.2 : 0.15),
      ),
      child: Row(
        children: [
          // Sol: metin bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Faz etiketi
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: phase.color.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusRound),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(phase.icon, size: 14, color: phase.color),
                      const SizedBox(width: 4),
                      Text(
                        '${phase.label} Fazı',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: phase.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  'Döngünün ${MockCycleData.currentCycleDay}. günü',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  'Sonraki adet: ~${MockCycleData.daysUntilNextPeriod} gün',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Sağ: halka grafik
          CyclePhaseRing(
            progress: MockCycleData.cycleProgress,
            phaseColor: phase.color,
            currentDay: MockCycleData.currentCycleDay,
            size: 100,
            strokeWidth: 7,
          ),
        ],
      ),
    );
  }
}

// ─── 3. Hızlı Aksiyonlar (2x2 Bento Grid) ──────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.edit_calendar_rounded,
                label: 'Bugünü\nKaydet',
                color: AppColors.primary,
                onTap: () => _showRecordSheet(context),
              ),
            ),
            const SizedBox(width: AppConstants.paddingS),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.mood_rounded,
                label: 'Ruh\nHalim',
                color: AppColors.secondary,
                onTap: () => _showMoodSheet(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingS),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.healing_rounded,
                label: 'Semptom-\nlarım',
                color: AppColors.phaseMenstruation,
                onTap: () => _showSymptomsSheet(context),
              ),
            ),
            const SizedBox(width: AppConstants.paddingS),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.sticky_note_2_outlined,
                label: 'Günlük\nNotum',
                color: AppColors.tertiary,
                onTap: () => _showNoteSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showRecordSheet(BuildContext context) {
    _showPlaceholderSheet(
      context,
      title: 'Bugünü Kaydet',
      icon: Icons.edit_calendar_rounded,
      description: 'Akışını, semptomlarını ve ruh halini kaydet.',
    );
  }

  void _showMoodSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            Text(
              'Bugün nasıl hissediyorsun?',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConstants.paddingL),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: MockCycleData.moods.map((mood) {
                return GestureDetector(
                  onTap: () {
                    // TODO: Backend entegrasyonu — ruh hali kaydet
                    Navigator.pop(ctx);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusL),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          mood.$2,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood.$1,
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  void _showSymptomsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final symptoms = [
      ('Kramp', Icons.flash_on_rounded),
      ('Baş ağrısı', Icons.psychology_outlined),
      ('Yorgunluk', Icons.battery_2_bar_rounded),
      ('Şişkinlik', Icons.bubble_chart_outlined),
      ('Akne', Icons.face_outlined),
      ('Hassasiyet', Icons.favorite_border_rounded),
      ('Mide bulantısı', Icons.sick_outlined),
      ('Uykusuzluk', Icons.nightlight_outlined),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final selected = <int>{};
          return Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),
                Text(
                  'Bugün neler hissediyorsun?',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Birden fazla seçebilirsin',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: symptoms.asMap().entries.map((e) {
                    final isSelected = selected.contains(e.key);
                    return FilterChip(
                      avatar: Icon(e.value.$2, size: 16),
                      label: Text(e.value.$1),
                      selected: isSelected,
                      onSelected: (val) {
                        setSheetState(() {
                          if (val) {
                            selected.add(e.key);
                          } else {
                            selected.remove(e.key);
                          }
                        });
                        // TODO: Backend entegrasyonu — semptom kaydet
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppConstants.paddingM),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Kaydet'),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showNoteSheet(BuildContext context) {
    _showPlaceholderSheet(
      context,
      title: 'Günlük Notum',
      icon: Icons.sticky_note_2_outlined,
      description: 'Bugün kendini nasıl hissediyorsun? Düşüncelerini yaz.',
    );
  }

  void _showPlaceholderSheet(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),
            Icon(icon, size: 44, color: theme.colorScheme.primary),
            const SizedBox(height: AppConstants.paddingM),
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingM),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
              ),
              child: Text(
                'Yakında',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      color: isDark
          ? color.withValues(alpha: 0.08)
          : color.withValues(alpha: 0.05),
      border: Border.all(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 4. Mini Haftalık Takvim Şeridi ─────────────────────────────────────────

class _WeekStrip extends StatelessWidget {
  const _WeekStrip();

  static const _dayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = MockCycleData.last7Days;

    return BentoCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Son 7 Gün',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // TODO: Tam takvime navigasyon
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Takvim →',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              final weekdayIndex = (day.date.weekday - 1) % 7;
              return _DayDot(
                dayLabel: _dayLabels[weekdayIndex],
                dayNumber: day.date.day,
                color: day.phase.color,
                isToday: day.isToday,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.dayLabel,
    required this.dayNumber,
    required this.color,
    required this.isToday,
  });

  final String dayLabel;
  final int dayNumber;
  final Color color;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          dayLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isToday ? color : color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: isToday
                ? null
                : Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$dayNumber',
            style: theme.textTheme.labelMedium?.copyWith(
              color: isToday ? Colors.white : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 5. Faz Bilgi Kartı ────────────────────────────────────────────────────

class _PhaseInfoCard extends StatelessWidget {
  const _PhaseInfoCard({required this.phase});
  final CyclePhaseInfo phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      color: isDark
          ? phase.color.withValues(alpha: 0.06)
          : phase.color.withValues(alpha: 0.04),
      border: Border.all(
        color: phase.color.withValues(alpha: isDark ? 0.12 : 0.08),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: phase.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: phase.color,
              size: 22,
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${phase.label} Fazı Hakkında',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: phase.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phase.tip,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
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
