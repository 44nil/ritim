import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/mock_cycle_data.dart';
import '../data/mock_wellness_data.dart';
import '../data/mood_data.dart';
import '../data/symptom_insights.dart';
import '../../../shared/widgets/screen_gradient_background.dart';
import '../../articles/data/article_data.dart';

class CycleTrackingScreen extends ConsumerStatefulWidget {
  const CycleTrackingScreen({super.key});

  @override
  ConsumerState<CycleTrackingScreen> createState() => _CycleTrackingScreenState();
}

class _CycleTrackingScreenState extends ConsumerState<CycleTrackingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  final _scrollController = ScrollController();
  late DateTime _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  void _changeMonth(int delta) {
    setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + delta));
  }

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
      backgroundColor: AppColors.cardOn(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ScreenGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Sıcak karşılama — eskiden burada sayfanın ilk gördüğü şey
                  // soğuk bir "Eylül 2026" ay başlığıydı; ay/takvim gezinmesi
                  // artık aşağıda takvimin kendi küçük kontrolüne taşındı.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cardOn(context),
                          border: Border.all(color: AppColors.softPink.withValues(alpha: 0.3), width: 2),
                        ),
                        child: Center(child: Text(
                          cycle.userName.isNotEmpty ? cycle.userName[0].toUpperCase() : '?',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.inkOn(context)),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          cycle.userName.isNotEmpty ? 'Merhaba, ${cycle.userName}' : 'Merhaba!',
                          style: AppTextStyles.heading(fontSize: 22, color: AppColors.inkOn(context)),
                        ),
                        Text('Bugün nasıl hissediyorsun?', style: AppTextStyles.accent(fontSize: 16, color: AppColors.softPink)),
                      ])),
                      _SmallButton(icon: Icons.settings_outlined, semanticLabel: 'Ayarlar', onTap: () => context.pushNamed(RouteNames.cycleSettings)),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // Döngü durumu kartı — tek net "bugün nasılım" cevabı + tek ana eylem
                  // (ilk sırada: kullanıcı ekranı açtığında önce buna bakmak istiyor,
                  // takvim referans/detay amaçlı ikinci sırada)
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
                        // Hiç regl kaydı yokken "1. gün / Regl" göstermek yanıltıcı —
                        // regl daha başlamadan sanki başlamış gibi bir izlenim veriyordu.
                        // İlk kayıt oluşana kadar nötr, tatlı bir bekleme mesajı gösterelim.
                        if (cycle.periods.isEmpty) ...[
                          Text('Henüz kayıt yok', style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.5))),
                          const SizedBox(height: 4),
                          Text('Takip Zamanı', style: AppTextStyles.heading(fontSize: 26, color: AppColors.inkOn(context))),
                          const SizedBox(height: 8),
                          Text(
                            'Reglin başladığında aşağıdaki butona dokunarak ilk kaydını oluşturabilirsin. Acele etmene gerek yok.',
                            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.6), height: 1.5),
                          ),
                        ] else ...[
                          Text('${cycle.currentCycleDay}. gün', style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.5))),
                          const SizedBox(height: 4),
                          Text(phase.friendlyLabel ?? phase.label, style: AppTextStyles.heading(fontSize: 26, color: AppColors.inkOn(context))),
                          if (phase.friendlyLabel != null) ...[
                            const SizedBox(height: 2),
                            Text('(${phase.label} faz)', style: TextStyle(fontSize: 11, color: AppColors.inkOn(context).withValues(alpha: 0.4))),
                          ],
                          const SizedBox(height: 8),
                          Text(phase.tip, style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.6), height: 1.5)),
                        ],
                        const SizedBox(height: 12),
                        // Reglin ne zaman başladı / sonraki tahmini ne zaman
                        Builder(builder: (ctx) {
                          final String info;
                          if (cycle.isOnPeriod) {
                            info = '${DateFormat('d MMMM', 'tr_TR').format(cycle.activePeriod!.startDate)} tarihinde başladı';
                          } else if (cycle.daysUntilNextPeriod != null) {
                            info = 'Sonraki regl tahmini: ${cycle.daysUntilNextPeriod} gün sonra · ${DateFormat('d MMMM', 'tr_TR').format(cycle.nextPeriodEstimate!)}';
                          } else {
                            info = 'Kayıt yaptıkça tahminlerin daha isabetli olur';
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(info, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.7))),
                          );
                        }),
                        const SizedBox(height: 16),
                        // Reglim başladı/bitti butonu
                        Builder(builder: (ctx) {
                          final isOn = cycle.isOnPeriod;
                          final notifier = ProviderScope.containerOf(ctx).read(cycleProvider.notifier);
                          return GestureDetector(
                            onTap: () {
                              final previousState = cycle;
                              if (isOn) { notifier.endPeriod(); } else { notifier.startPeriod(); }
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                content: Text(isOn ? 'Regl bitiş kaydedildi' : 'Regl başlangıcı kaydedildi'),
                                behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink,
                                action: SnackBarAction(
                                  label: 'Geri Al',
                                  textColor: Colors.white,
                                  onPressed: () => notifier.restore(previousState),
                                ),
                              ));
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.inkOn(context),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(isOn ? Icons.stop_rounded : Icons.water_drop_rounded, size: 20, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(isOn ? 'Reglim Bitti' : 'Reglim Başladı', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                              ]),
                            ),
                          );
                        }),
                      ]),
                    )),
                  ),
                  const SizedBox(height: 24),

                  // Aylık takvim — geçmiş regl günleri ve tahmini günler.
                  // Ay adı + gezinme okları artık takvimin kendi küçük
                  // kontrolü (eskiden sayfanın en üstündeki büyük başlıktı).
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          DateFormat('MMMM yyyy', 'tr_TR').format(_displayedMonth),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.inkOn(context)),
                        ),
                      ),
                      _CalendarNavButton(icon: Icons.chevron_left_rounded, semanticLabel: 'Önceki ay', onTap: () => _changeMonth(-1)),
                      const SizedBox(width: 8),
                      _CalendarNavButton(icon: Icons.chevron_right_rounded, semanticLabel: 'Sonraki ay', onTap: () => _changeMonth(1)),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _staggered(index: 1, child: _MonthCalendar(
                      cycle: cycle,
                      displayedMonth: _displayedMonth,
                      onDayTap: (date) => _showDayLog(context, date),
                    )),
                  ),
                  const SizedBox(height: 28),

                  // Bugünü kaydet — asıl günlük eylem, kullanıcı her gün
                  // buraya bunun için geliyor; bu yüzden geriye dönük
                  // içgörü/hatırlatıcı kartlarından önce, takvimin hemen
                  // ardından gelir.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Bugünü Kaydet', style: AppTextStyles.heading(fontSize: 24, color: AppColors.inkOn(context))),
                  ),
                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _staggered(index: 2, child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.translucentOn(context),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // Ruh hali
                        Row(children: [
                          Icon(Icons.mood_outlined, size: 18, color: AppColors.inkOn(context).withValues(alpha: 0.5)),
                          const SizedBox(width: 8),
                          Text('Ruh Hali', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.6))),
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
                          Expanded(child: _SleepStepper(phase: phase.phase)),
                        ]),

                        _QuickLogDivider(),

                        // Semptom / Not
                        Row(children: [
                          Expanded(child: _QuickLogAction(
                            icon: Icons.healing_outlined,
                            label: 'Belirti',
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
                  const SizedBox(height: 28),

                  // Belirti örüntün — kullanıcının kendi geçmiş kayıtlarının
                  // özeti, genel bir tıbbi iddia değil (bkz. symptom_insights.dart).
                  // Yeterli veri yoksa hiç gösterilmez. Eylem kartından sonra
                  // gelir — bu daha "keşif amaçlı", ara sıra bakılan bir şey.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _staggered(index: 3, child: _SymptomInsightsCard(cycle: cycle)),
                  ),

                  // Regl günüyse ya da yaklaşıyorsa okul çantası hatırlatıcısı
                  // — okuma köşesindeki kontrol listesi makalesine götürür.
                  // Kalıcı bir bildirim değil, sadece o an anlamlıysa görünen
                  // küçük bir dokunuş.
                  if (cycle.isOnPeriod || (cycle.daysUntilNextPeriod ?? 99) <= 3)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: _staggered(index: 3, child: _SchoolBagReminderCard()),
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
  const _SmallButton({required this.icon, required this.onTap, required this.semanticLabel});
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(button: true, label: semanticLabel, child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.softPink.withValues(alpha: 0.15),
        ),
        child: Icon(icon, size: 20, color: AppColors.inkOn(context).withValues(alpha: 0.5)),
      ),
    ));
  }
}

// Okul çantası hatırlatıcısı — Okuma köşesindeki kontrol listesi makalesine
// kısayol. Sadece regl günü ya da yakınsa gösteriliyor (bkz. çağrı yeri).
class _SchoolBagReminderCard extends StatelessWidget {
  const _SchoolBagReminderCard();

  @override
  Widget build(BuildContext context) {
    final article = ArticleData.articles.firstWhere((a) => a.isChecklist);
    return GestureDetector(
      onTap: () => context.pushNamed(RouteNames.articleDetail, extra: article),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.translucentOn(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.warmOrange.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(article.icon, size: 20, color: AppColors.inkOn(context).withValues(alpha: 0.7)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Okul çantan hazır mı?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.inkOn(context))),
            Text('Kontrol listesine bak', style: TextStyle(fontSize: 11.5, color: AppColors.inkOn(context).withValues(alpha: 0.55))),
          ])),
          Icon(Icons.chevron_right_rounded, color: AppColors.inkOn(context).withValues(alpha: 0.3)),
        ]),
      ),
    );
  }
}

// ─── Hızlı Aksiyonlar ───────────────────────────────────────────────────────

void _showSymptoms(BuildContext context, {DateTime? date}) {
  final day = date ?? DateTime.now();
  final isToday = _isSameDay(day, DateTime.now());
  final theme = Theme.of(context);
  final container = ProviderScope.containerOf(context);
  // selected, StatefulBuilder'ın DIŞINDA tanımlanmalı — içeride tanımlanırsa
  // her setSt() çağrısı builder'ı yeniden çalıştırıp seti sıfırlıyordu,
  // bu yüzden hiçbir belirti seçili görünmüyordu (gerçek bir hataydı).
  final symptoms = [
    ('Kramp', Icons.flash_on_rounded), ('Baş ağrısı', Icons.psychology_outlined),
    ('Yorgunluk', Icons.battery_2_bar_rounded), ('Şişkinlik', Icons.bubble_chart_outlined),
    ('Akne', Icons.face_outlined), ('Hassasiyet', Icons.favorite_border_rounded),
    ('Bulantı', Icons.sick_outlined), ('Uykusuzluk', Icons.nightlight_outlined),
    ('Bel ağrısı', Icons.accessibility_new_rounded), ('İştahsızlık', Icons.no_food_outlined),
  ];
  // O gün zaten kayıtlı belirtiler varsa sheet açılınca önceden seçili görünsün.
  final existingSymptoms = container.read(cycleProvider).logForDate(day)?.symptoms ?? const [];
  final selected = <int>{
    for (var i = 0; i < symptoms.length; i++)
      if (existingSymptoms.contains(symptoms[i].$1)) i,
  };
  _sheet(context, (ctx) => StatefulBuilder(builder: (ctx, setSt) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _sheetHandle(context),
      const SizedBox(height: 24),
      Text('Belirtiler', style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface)),
      const SizedBox(height: 6),
      Text(isToday ? 'Bugün yaşadıklarını işaretle' : '${DateFormat('d MMMM', 'tr_TR').format(day)} için işaretle', style: theme.textTheme.bodySmall?.copyWith(
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
            container.read(cycleProvider.notifier).logSymptoms(names, date: day);
          }
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(selected.isEmpty ? 'Kayıt atlandı' : '${selected.length} belirti kaydedildi'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.softPink),
          );
        },
        child: Text(selected.isEmpty ? 'Atla' : 'Kaydet (${selected.length})'))),
      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
    ]);
  }));
}

void _showNote(BuildContext context, {DateTime? date}) {
  final day = date ?? DateTime.now();
  final isToday = _isSameDay(day, DateTime.now());
  final theme = Theme.of(context);
  final container = ProviderScope.containerOf(context);
  final controller = TextEditingController(text: container.read(cycleProvider).logForDate(day)?.note);
  _sheet(context, (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
    _sheetHandle(context),
    const SizedBox(height: 24),
    Text('Günlük Not', style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface)),
    const SizedBox(height: 6),
    Text(isToday ? 'Bugün için' : DateFormat('d MMMM', 'tr_TR').format(day), style: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
    const SizedBox(height: 14),
    TextField(controller: controller, maxLines: 4, decoration: InputDecoration(
      hintText: 'Nasıl hissediyorum...', border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), filled: true)),
    const SizedBox(height: 20),
    SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
      onPressed: () {
        final text = controller.text.trim();
        if (text.isNotEmpty) {
          container.read(cycleProvider.notifier).logNote(text, date: day);
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

// İlaçlarım — kullanıcının kendi yazdığı isim + o gün kaç kez alındığı sayacı.
// Kasıtlı olarak doz/mg gibi hiçbir tıbbi bilgi/öneri içermiyor, sadece kişisel bir sayım.
void _showMedications(BuildContext context, {DateTime? date}) {
  final day = date ?? DateTime.now();
  final isToday = _isSameDay(day, DateTime.now());
  final theme = Theme.of(context);
  final container = ProviderScope.containerOf(context);
  final controller = TextEditingController();
  _sheet(context, (ctx) => StatefulBuilder(builder: (ctx, setSt) {
    final cycle = container.read(cycleProvider);
    final names = cycle.medicationNames;
    final counts = cycle.logForDate(day)?.medications ?? const {};

    void adjust(String name, int delta) {
      final newCount = ((counts[name] ?? 0) + delta).clamp(0, 20);
      container.read(cycleProvider.notifier).logMedicationCount(name, newCount, date: day);
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
      Text(
        isToday ? 'Kendi ilacını ekle, bugün kaç kez aldığını işaretle' : 'Kendi ilacını ekle, ${DateFormat('d MMMM', 'tr_TR').format(day)} için kaç kez aldığını işaretle',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
      ),
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
          decoration: BoxDecoration(color: AppColors.cardOn(context), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.inkOn(context)))),
            Text('${counts[name] ?? 0}x', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.inkOn(context).withValues(alpha: 0.5))),
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
  // Önceki bir aksiyondan (ör. "Reglim Başladı") kalan bir SnackBar hâlâ
  // ekrandaysa, floating SnackBar'ın kapladığı alan yeni sheet'in alt
  // kısmındaki bir butonla çakışıp dokunuşu yutabiliyor — gerçek bir hataydı,
  // hızlı art arda işlemde buton hiç tetiklenmeden kayıt sessizce kayboluyordu.
  ScaffoldMessenger.of(context).clearSnackBars();
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

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

// Takvimde bugüne ya da geçmiş bir güne dokununca açılır — o günün ruh
// hali/uyku/belirti/not/ilaç kaydını gösterir ve düzenlemeye izin verir.
// Su göstergesi kasıtlı olarak burada yok: su, güne özel kalıcı bir veri
// değil (bkz. MockWellnessData.waterDrunk), sadece "bugün" için anlamlı.
void _showDayLog(BuildContext context, DateTime date) {
  final theme = Theme.of(context);
  final container = ProviderScope.containerOf(context);
  final isToday = _isSameDay(date, DateTime.now());
  final dateLabel = isToday ? 'Bugün' : DateFormat('d MMMM', 'tr_TR').format(date);
  final hasExistingData = container.read(cycleProvider).logForDate(date)?.hasAnyData ?? false;

  // Veri zaten varsa önce net bir ÖZET gösteriyoruz ("o gün ne olmuş"),
  // düzenleme formu bir dokunuş ötede. Boş bir günse (özellikle bugün, ilk
  // kayıt) direkt düzenleme formuyla başlıyoruz — eskiden ikisi hep aynı
  // (düzenleme) ekranıydı, geçmiş bir günü açsan bile bir form görürdün.
  var editing = !hasExistingData;

  _sheet(context, (ctx) => StatefulBuilder(builder: (ctx, setSt) {
    final log = container.read(cycleProvider).logForDate(date);
    final sleepHours = log?.sleepHours;

    void adjustSleep(double delta) {
      final hours = (sleepHours ?? 7.5) + delta;
      container.read(cycleProvider.notifier).logSleepHours(hours.clamp(0, 24), date: date);
      setSt(() {});
    }

    if (!editing) {
      return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sheetHandle(context),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: Text(
            isToday ? 'Bugün ne oldu?' : '$dateLabel günü ne oldu?',
            style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface),
          )),
          TextButton.icon(
            onPressed: () => setSt(() => editing = true),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Düzenle'),
          ),
        ]),
        const SizedBox(height: 12),
        if (log?.mood != null)
          _DaySummaryRow(icon: Icons.mood_outlined, label: 'Ruh Hali', child: Text(log!.mood!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface))),
        if (log?.sleepHours != null)
          _DaySummaryRow(icon: Icons.nightlight_outlined, label: 'Uyku', child: Text('${_SleepStepper._format(log!.sleepHours!)} saat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface))),
        if (log?.symptoms.isNotEmpty ?? false)
          _DaySummaryRow(icon: Icons.healing_outlined, label: 'Belirtiler', child: Wrap(spacing: 6, runSpacing: 6, children: log!.symptoms.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: AppColors.softPink.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: Text(s, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
          )).toList())),
        if (log?.note?.isNotEmpty ?? false)
          _DaySummaryRow(icon: Icons.sticky_note_2_outlined, label: 'Not', child: Text(log!.note!, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.8), height: 1.4))),
        if (log?.medications.isNotEmpty ?? false)
          _DaySummaryRow(icon: Icons.medication_outlined, label: 'İlaçlar', child: Text(
            log!.medications.entries.map((e) => '${e.key} (${e.value})').join(', '),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
          )),
        SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
      ]);
    }

    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sheetHandle(context),
      const SizedBox(height: 24),
      Center(child: Text(
        isToday ? 'Bugünü Kaydet' : '$dateLabel Günü Düzenle',
        style: AppTextStyles.heading(fontSize: 20, color: theme.colorScheme.onSurface),
      )),
      const SizedBox(height: 20),

      Text('Ruh Hali', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
      const SizedBox(height: 10),
      _MoodPicker(
        initialMood: log?.mood,
        onSelected: (mood) {
          container.read(cycleProvider.notifier).logMood(mood, date: date);
          setSt(() {});
        },
      ),

      _QuickLogDivider(),

      Row(children: [
        Icon(Icons.nightlight_outlined, size: 16, color: AppColors.softPink),
        const SizedBox(width: 8),
        Text('Uyku', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        const Spacer(),
        Text(sleepHours != null ? '${_SleepStepper._format(sleepHours)} saat' : '—', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
        const SizedBox(width: 10),
        _StepperBtn(icon: Icons.remove_rounded, onTap: () => adjustSleep(-0.5)),
        const SizedBox(width: 6),
        _StepperBtn(icon: Icons.add_rounded, onTap: () => adjustSleep(0.5)),
      ]),

      _QuickLogDivider(),

      Row(children: [
        Expanded(child: _QuickLogAction(
          icon: Icons.healing_outlined,
          label: 'Belirti',
          caption: (log?.symptoms.isNotEmpty ?? false) ? '${log!.symptoms.length} kayıtlı' : 'Kaydet',
          onTap: () { Navigator.pop(ctx); _showSymptoms(context, date: date); },
        )),
        const SizedBox(width: 16),
        Expanded(child: _QuickLogAction(
          icon: Icons.sticky_note_2_outlined,
          label: 'Günlük Not',
          caption: (log?.note?.isNotEmpty ?? false) ? 'Yazıldı' : 'Yaz',
          onTap: () { Navigator.pop(ctx); _showNote(context, date: date); },
        )),
      ]),
      const SizedBox(height: 16),
      _QuickLogAction(
        icon: Icons.medication_outlined,
        label: 'İlaçlarım',
        caption: (log?.medications.isNotEmpty ?? false) ? 'İşaretlendi' : 'İşaretle',
        onTap: () { Navigator.pop(ctx); _showMedications(context, date: date); },
      ),
      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
    ]);
  }));
}

// Özet görünümündeki her satır — solda kategori ikonu+etiketi, sağda/altta
// gerçek değer. Sadece dolu kategoriler gösterilir (bkz. çağrı yerindeki
// if'ler) — boş bir "Uyku: —" satırı özet görünümünde anlamsız.
class _DaySummaryRow extends StatelessWidget {
  const _DaySummaryRow({required this.icon, required this.label, required this.child});
  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 15, color: AppColors.softPink),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.55))),
        ]),
        const SizedBox(height: 6),
        child,
      ]),
    );
  }
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

    // Her ruh hali kendi rengiyle gösteriliyor (bkz. mood_data.dart) — bu
    // renkler takvimde o günün hücresini boyamak için de kullanılıyor,
    // böylece kullanıcı burada seçtiği rengi takvimde tanıyor, ayrı bir
    // açıklamaya (legend) gerek kalmıyor.
    final selectedColor = MoodData.colorFor(selected?.$1) ?? AppColors.softPink;
    return Column(children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: Container(
          key: ValueKey(_mood),
          width: 72, height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selectedColor.withValues(alpha: selected == null ? 0.15 : 0.4),
          ),
          child: Icon(selected?.$2 ?? Icons.mood_outlined, size: 34, color: selected == null ? AppColors.softPink : AppColors.inkOn(context)),
        ),
      ),
      const SizedBox(height: 6),
      Text(_mood ?? 'Nasıl hissediyorsun?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.65))),
      const SizedBox(height: 14),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _moods.map((m) {
        final isSelected = _mood == m.$1;
        final color = MoodData.colorFor(m.$1)!;
        return GestureDetector(
          onTap: () => _select(m.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color : Colors.white.withValues(alpha: 0.7),
              border: Border.all(color: isSelected ? color : color.withValues(alpha: 0.5), width: isSelected ? 0 : 1.5),
              boxShadow: isSelected ? null : [
                BoxShadow(color: AppColors.softPink.withValues(alpha: 0.12), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(m.$2, size: 20, color: isSelected ? AppColors.inkOn(context) : color),
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
        Text('Su', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.6))),
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
            TextSpan(text: '$drunk/$goal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.inkOn(context))),
            TextSpan(text: ' bardak', style: TextStyle(fontSize: 12, color: AppColors.inkOn(context).withValues(alpha: 0.55))),
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
      child: Container(height: 1, color: AppColors.inkOn(context).withValues(alpha: 0.06)),
    );
  }
}

// Bugün kaç saat uyuduğunu gerçekten kaydeden giriş — eskiden burada
// sadece o fazın önerilen uyku süresi gösteriliyordu, tıklanabilir
// değildi (bkz. su göstergesiyle tutarsızlık).
class _SleepStepper extends ConsumerWidget {
  const _SleepStepper({required this.phase});
  final CyclePhase phase;

  static String _format(double h) => h == h.roundToDouble() ? '${h.toInt()}' : '$h';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hours = ref.watch(cycleProvider).todayLog?.sleepHours;

    void adjust(double delta) {
      ref.read(cycleProvider.notifier).logSleepHours((hours ?? 7.5) + delta);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.nightlight_outlined, size: 16, color: AppColors.softPink),
        const SizedBox(width: 6),
        Text('Uyku', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.6))),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(MockWellnessData.forPhase(phase).sleepTip),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.softPink,
          )),
          child: Icon(Icons.info_outline_rounded, size: 13, color: AppColors.inkOn(context).withValues(alpha: 0.3)),
        ),
      ]),
      const SizedBox(height: 10),
      RichText(text: TextSpan(children: [
        TextSpan(text: hours != null ? _format(hours) : '—', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.inkOn(context))),
        if (hours != null) TextSpan(text: ' saat', style: TextStyle(fontSize: 12, color: AppColors.inkOn(context).withValues(alpha: 0.55))),
      ])),
      const SizedBox(height: 8),
      Row(children: [
        _StepperBtn(icon: Icons.remove_rounded, onTap: () => adjust(-0.5)),
        const SizedBox(width: 8),
        _StepperBtn(icon: Icons.add_rounded, onTap: () => adjust(0.5)),
      ]),
      const SizedBox(height: 6),
      // 13-18 yaş için AASM/AAP önerisi — bkz. docs/content-sources.md.
      Text('Önerilen: 8-10 saat', style: TextStyle(fontSize: 10, color: AppColors.inkOn(context).withValues(alpha: 0.5))),
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
        Icon(icon, size: 18, color: AppColors.inkOn(context).withValues(alpha: 0.5)),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkOn(context))),
          Text(caption, style: TextStyle(fontSize: 11, color: AppColors.inkOn(context).withValues(alpha: 0.55))),
        ])),
      ]),
    );
  }
}

// ─── Aylık takvim ───────────────────────────────────────────────────────────

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({required this.cycle, required this.displayedMonth, required this.onDayTap});
  final CycleState cycle;
  final DateTime displayedMonth;
  // Sadece bugün ve geçmiş günler için çağrılır — henüz yaşanmamış bir
  // günün kaydını tutmak anlamsız, bu yüzden gelecek günler tıklanamaz.
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final daysInMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
    // Pazartesi başlangıçlı hafta: weekday 1=Pzt..7=Paz, öncesine boş hücre.
    final leadingEmpty = firstDay.weekday - 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.translucentOn(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.35))),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingEmpty + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemBuilder: (context, index) {
              if (index < leadingEmpty) return const SizedBox.shrink();
              final day = index - leadingEmpty + 1;
              final date = DateTime(displayedMonth.year, displayedMonth.month, day);
              final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
              final isPeriod = cycle.isPeriodDay(date);
              final isPredicted = !isPeriod && cycle.isPredictedPeriodDay(date);
              final isTappable = !date.isAfter(today);
              final log = cycle.logForDate(date);
              final hasLog = log?.hasAnyData ?? false;
              final moodColor = MoodData.colorFor(log?.mood);
              return GestureDetector(
                onTap: isTappable ? () => onDayTap(date) : null,
                child: _DayCell(day: day, isToday: isToday, isPeriod: isPeriod, isPredicted: isPredicted, hasLog: hasLog, moodColor: moodColor),
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 18, runSpacing: 6, children: [
            _LegendDot(color: AppColors.phaseMenstruation, filled: true, label: 'Regl günü'),
            _LegendDot(color: AppColors.phaseMenstruation, filled: false, label: 'Tahmini'),
            _LegendDot(color: AppColors.softPink.withValues(alpha: 0.4), filled: true, label: 'Bugün'),
            _LegendDot(color: AppColors.inkOn(context).withValues(alpha: 0.55), filled: true, label: 'Kayıt var'),
          ]),
        ],
      ),
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  const _CalendarNavButton({required this.icon, required this.onTap, required this.semanticLabel});
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(button: true, label: semanticLabel, child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.softPink.withValues(alpha: 0.12)),
        child: Icon(icon, size: 18, color: AppColors.inkOn(context).withValues(alpha: 0.6)),
      ),
    ));
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.isToday, required this.isPeriod, required this.isPredicted, required this.hasLog, this.moodColor});
  final int day;
  final bool isToday;
  final bool isPeriod;
  final bool isPredicted;
  // Ruh hali/uyku/belirti/not — herhangi biri girilmişse takvimde küçük bir
  // nokta gösteriyoruz, ki hangi günlerin "dolu" olduğu bir bakışta görülsün
  // — eskiden buna dokunmadan anlamanın hiçbir yolu yoktu.
  final bool hasLog;
  // O gün bir ruh hali kaydedilmişse (bkz. mood_data.dart), aya bakınca genel
  // bir "ruh hali deseni" görülsün diye günü o rengin yumuşak bir tonuyla
  // boyuyoruz. Regl günü rengi (sağlık bilgisi) her zaman önceliklidir.
  final Color? moodColor;

  @override
  Widget build(BuildContext context) {
    Color? background;
    Color textColor = AppColors.inkOn(context).withValues(alpha: 0.7);
    Border? border;

    if (isPeriod) {
      background = AppColors.phaseMenstruation;
      textColor = Colors.white;
    } else if (isPredicted) {
      border = Border.all(color: AppColors.phaseMenstruation.withValues(alpha: 0.5), width: 1.5);
      textColor = AppColors.phaseMenstruation;
    } else if (moodColor != null) {
      background = moodColor!.withValues(alpha: 0.55);
      textColor = AppColors.inkOn(context);
    } else if (isToday) {
      background = AppColors.softPink.withValues(alpha: 0.25);
      textColor = AppColors.inkOn(context);
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(alignment: Alignment.center, children: [
          Container(
            decoration: BoxDecoration(color: background, shape: BoxShape.circle, border: border),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(fontSize: 12.5, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500, color: textColor),
            ),
          ),
          if (hasLog)
            Positioned(
              bottom: 2,
              child: Container(
                width: 4, height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPeriod ? Colors.white : AppColors.inkOn(context).withValues(alpha: 0.55),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.filled, required this.label});
  final Color color;
  final bool filled;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? color : Colors.transparent,
          border: filled ? null : Border.all(color: color, width: 1.5),
        ),
      ),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(fontSize: 11, color: AppColors.inkOn(context).withValues(alpha: 0.5))),
    ]);
  }
}

// ─── Kendi Ritmin ────────────────────────────────────────────────────────
// Kullanıcının kendi geçmiş kayıtlarına bakarak her belirtinin en çok hangi
// döngü fazında yaşandığını gösterir. Kart her zaman görünür — koşula bağlı
// gizlemek kullanıcıda "neden hiç görünmüyor, bir şey mi bozuk" hissi
// yaratıyordu (gerçek bir geri bildirimdi). Bunun yerine üç durumu var:
// (1) yeterli veri varsa gerçek örüntü, (2) belirti var ama regl kaydı
// yoksa bunu açıklayan bir ipucu, (3) hiçbiri yoksa neyin biriktiğini
// açıklayan sakin bir bekleme metni.
class _SymptomInsightsCard extends StatelessWidget {
  const _SymptomInsightsCard({required this.cycle});
  final CycleState cycle;

  static const _maxShown = 4;

  @override
  Widget build(BuildContext context) {
    final insights = symptomPhaseInsights(cycle).take(_maxShown).toList();
    final hasAnySymptomLogged = cycle.logs.values.any((log) => log.symptoms.isNotEmpty);
    final needsPeriodHint = insights.isEmpty && cycle.periods.isEmpty && hasAnySymptomLogged;

    final String caption;
    if (insights.isNotEmpty) {
      caption = 'Kendi geçmiş kayıtlarına göre — bilimsel bir iddia değil, sadece senin verin.';
    } else if (needsPeriodHint) {
      caption = 'Belirtilerini bir döngü fazına bağlayabilmemiz için önce "Reglim Başladı" ile bir kayıt oluşturman gerekiyor.';
    } else {
      caption = 'Reglini başlatıp aynı belirtiyi birkaç kez kaydettikçe, burada hangi dönemde yoğunlaştığını göreceksin.';
    }

    return Column(children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.translucentOn(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.insights_rounded, size: 18, color: AppColors.inkOn(context).withValues(alpha: 0.5)),
            const SizedBox(width: 8),
            Text('Kendi Ritmin', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.inkOn(context))),
          ]),
          const SizedBox(height: 4),
          Text(caption, style: TextStyle(fontSize: 11.5, color: AppColors.inkOn(context).withValues(alpha: 0.55), height: 1.3)),
          if (insights.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SymptomInsightRow(insight: insight),
            )),
          ],
        ]),
      ),
      const SizedBox(height: 28),
    ]);
  }
}

class _SymptomInsightRow extends StatelessWidget {
  const _SymptomInsightRow({required this.insight});
  final SymptomPhaseInsight insight;

  @override
  Widget build(BuildContext context) {
    final phaseInfo = MockCycleData.phases.firstWhere((p) => p.phase == insight.dominantPhase);
    return Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: phaseInfo.color)),
      const SizedBox(width: 10),
      Expanded(child: Text(insight.symptom, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.inkOn(context)))),
      Text(
        '${insight.dominantCount}/${insight.totalCount} kez ${phaseInfo.friendlyLabel ?? phaseInfo.label}',
        style: TextStyle(fontSize: 11.5, color: AppColors.inkOn(context).withValues(alpha: 0.6)),
      ),
    ]);
  }
}
