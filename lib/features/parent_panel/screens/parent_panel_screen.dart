import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/clean_card.dart';
import '../../../shared/widgets/screen_gradient_background.dart';
import '../models/parent_summary.dart';

const _included = [
  'Döngü ve regl takibi',
  'Yaşa uygun genel sağlık bilgileri (beslenme, uyku, hareket)',
  'Ruh hali ve günlük not tutma',
  'Kendi ilaç hatırlatıcısı — doz/tıbbi tavsiye içermez, sadece kişisel bir sayım',
];

const _excluded = [
  'Cinsel içerik veya yetişkin materyali',
  'Doğum kontrolü veya gebelik içeriği',
  'Reklam',
  'Verilerin üçüncü taraflarla paylaşılması',
];

/// Ebeveyn paneli — çocuğun QR kodunu tarayarak buraya ulaşılır (bkz.
/// parent_scan_screen.dart). Güven merkezli tasarım: çocuğun kişisel
/// kayıtları (ruh hali/semptom/not) YOK, sadece döngü genel bakışı ve
/// uygulamanın içerik güvencesi gösteriliyor — canlı veri değil, QR
/// tarandığı andaki bir özet (bkz. ParentSummary). Bkz. proje hafızası:
/// mahremiyet çizgisi bilinçli bir ürün kararı, eksiklik değil.
class ParentPanelScreen extends StatelessWidget {
  const ParentPanelScreen({super.key, required this.summary});
  final ParentSummary summary;

  @override
  Widget build(BuildContext context) {
    final ageMinutes = DateTime.now().difference(summary.generatedAt).inMinutes;

    return Scaffold(
      backgroundColor: AppColors.cardOn(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.inkOn(context)),
        title: Text('Ebeveyn Paneli', style: AppTextStyles.heading(fontSize: 20, color: AppColors.inkOn(context))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Geri',
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(fit: StackFit.expand, children: [
        const ScreenGradientBackground(),
        SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Merhaba, Ebeveyn', style: AppTextStyles.heading(fontSize: 26, color: AppColors.inkOn(context))),
          const SizedBox(height: 4),
          Text(
            '${summary.userName} adlı çocuğunuzun döngü takibini ve uygulamanın içerik güvencesini buradan görebilirsiniz.',
            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.6), height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            ageMinutes < 1 ? 'Az önce tarandı' : '$ageMinutes dakika önce tarandı',
            style: TextStyle(fontSize: 11, color: AppColors.inkOn(context).withValues(alpha: 0.55), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),

          CleanCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.water_drop_outlined, color: AppColors.softPink, size: 20),
              const SizedBox(width: 8),
              Text('Döngü Genel Bakış', style: AppTextStyles.heading(fontSize: 16, color: AppColors.inkOn(context))),
            ]),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Son regl başlangıcı',
              value: summary.lastPeriodStart != null
                  ? DateFormat('d MMMM yyyy', 'tr_TR').format(summary.lastPeriodStart!)
                  : 'Henüz kayıt yok',
            ),
            _InfoRow(label: 'Şu an', value: '${summary.currentCycleDay}. gün'),
            _InfoRow(
              label: 'Ortalama döngü uzunluğu',
              value: summary.canPredict ? '${summary.averageCycleLength} gün' : 'Henüz yeterli veri yok',
            ),
            _InfoRow(label: 'Kayıtlı döngü sayısı', value: '${summary.periodCount}'),
          ])),
          const SizedBox(height: 16),

          if (summary.recentPeriods.isNotEmpty) ...[
            CleanCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.calendar_month_outlined, color: AppColors.softPink, size: 20),
                const SizedBox(width: 8),
                Text('Regl Takvimi', style: AppTextStyles.heading(fontSize: 16, color: AppColors.inkOn(context))),
              ]),
              const SizedBox(height: 16),
              _ParentMiniCalendar(summary: summary),
            ])),
            const SizedBox(height: 16),
          ],

          CleanCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.shield_outlined, color: AppColors.warmOrange, size: 20),
              const SizedBox(width: 8),
              Text('Uygulamada Neler Var, Neler Yok', style: AppTextStyles.heading(fontSize: 16, color: AppColors.inkOn(context))),
            ]),
            const SizedBox(height: 14),
            ..._included.map((t) => _CheckRow(text: t, included: true)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: AppColors.inkOn(context).withValues(alpha: 0.08), height: 1),
            ),
            const SizedBox(height: 6),
            ..._excluded.map((t) => _CheckRow(text: t, included: false)),
          ])),
          const SizedBox(height: 16),

          CleanCard(
            color: AppColors.cardOn(context),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.lock_outline_rounded, color: AppColors.inkOn(context).withValues(alpha: 0.5), size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(
                'Çocuğunuzun ruh hali, semptom ve günlük not girişleri kişiye özeldir ve bu panelde gösterilmez. Bu, ona dürüst ve açık kayıt tutabileceği bir alan tanımak için bilinçli bir tercihtir.',
                style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.7), height: 1.5),
              )),
            ]),
          ),
          const SizedBox(height: 16),

          CleanCard(
            color: AppColors.cardOn(context),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.verified_outlined, color: AppColors.inkOn(context).withValues(alpha: 0.5), size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(
                'İçeriklerimiz UNICEF, Dünya Sağlık Örgütü (WHO) ve Amerikan Kadın Doğum ve Jinekologlar Koleji (ACOG) gibi kurumların çocuk/ergen sağlığı rehberleri temel alınarak hazırlanmıştır. Bu uygulama tıbbi tanı, tedavi veya doktor tavsiyesi yerine geçmez — sağlıkla ilgili bir endişeniz varsa lütfen bir doktora danışın.',
                style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.7), height: 1.5),
              )),
            ]),
          ),
        ]),
        )),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.5)))),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.inkOn(context))),
      ]),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.text, required this.included});
  final String text;
  final bool included;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(
          included ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 16,
          color: included ? AppColors.success : AppColors.error,
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.75), height: 1.4))),
      ]),
    );
  }
}

// Ana uygulamadaki takvimin salt-okunur, sadeleştirilmiş hali — ruh hali
// rengi/tıklama/gün-içi özet yok, sadece regl günü ve tahmini gün gösterir
// (bkz. ParentSummary.recentPeriods — sadece son ~90 gün, paylaşılması
// zaten onaylı veri).
class _ParentMiniCalendar extends StatefulWidget {
  const _ParentMiniCalendar({required this.summary});
  final ParentSummary summary;

  @override
  State<_ParentMiniCalendar> createState() => _ParentMiniCalendarState();
}

class _ParentMiniCalendarState extends State<_ParentMiniCalendar> {
  late DateTime _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool _isPeriodDay(DateTime date) {
    for (final p in widget.summary.recentPeriods) {
      final end = p.endDate ?? DateTime.now();
      if (!date.isBefore(p.startDate) && !date.isAfter(end)) return true;
    }
    return false;
  }

  bool _isPredictedDay(DateTime date) {
    final next = widget.summary.nextPeriodEstimate;
    if (next == null) return false;
    final diff = date.difference(next).inDays;
    return diff >= 0 && diff < widget.summary.averagePeriodLength;
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final leadingEmpty = firstDay.weekday - 1;

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
          onPressed: () => setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1)),
          icon: const Icon(Icons.chevron_left_rounded),
          tooltip: 'Önceki ay',
        ),
        Text(DateFormat('MMMM y', 'tr_TR').format(_displayedMonth), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.inkOn(context))),
        IconButton(
          onPressed: () => setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1)),
          icon: const Icon(Icons.chevron_right_rounded),
          tooltip: 'Sonraki ay',
        ),
      ]),
      const SizedBox(height: 4),
      Row(
        children: const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
            .map((d) => Expanded(child: Center(child: Text(d, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.35))))))
            .toList(),
      ),
      const SizedBox(height: 4),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: leadingEmpty + daysInMonth,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemBuilder: (context, index) {
          if (index < leadingEmpty) return const SizedBox.shrink();
          final day = index - leadingEmpty + 1;
          final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
          final isPeriod = _isPeriodDay(date);
          final isPredicted = !isPeriod && _isPredictedDay(date);

          Color? background;
          Color textColor = AppColors.inkOn(context).withValues(alpha: 0.7);
          Border? border;
          if (isPeriod) {
            background = AppColors.phaseMenstruation;
            textColor = Colors.white;
          } else if (isPredicted) {
            border = Border.all(color: AppColors.phaseMenstruation.withValues(alpha: 0.5), width: 1.5);
            textColor = AppColors.phaseMenstruation;
          }

          return Padding(
            padding: const EdgeInsets.all(2),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(color: background, shape: BoxShape.circle, border: border),
                alignment: Alignment.center,
                child: Text('$day', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textColor)),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      Wrap(spacing: 16, runSpacing: 6, children: [
        _LegendDot(color: AppColors.phaseMenstruation, filled: true, label: 'Regl günü'),
        _LegendDot(color: AppColors.phaseMenstruation, filled: false, label: 'Tahmini'),
      ]),
    ]);
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
