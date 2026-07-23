import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/clean_card.dart';

const _included = [
  'Döngü ve adet takibi',
  'Yaşa uygun genel sağlık bilgileri (beslenme, uyku, hareket)',
  'Ruh hali ve günlük not tutma',
  'Kendi ilaç hatırlatıcısı — doz/tıbbi tavsiye içermez, sadece kişisel bir sayım',
  'Uzman onaylı, genel bilgilendirme makaleleri',
];

const _excluded = [
  'Cinsel içerik veya yetişkin materyali',
  'Doğum kontrolü veya gebelik içeriği',
  'Reklam',
  'Verilerin üçüncü taraflarla paylaşılması',
];

/// Ebeveyn paneli — güven merkezli tasarım: çocuğun kişisel kayıtları
/// (ruh hali/semptom/not) YOK, sadece döngü genel bakışı ve uygulamanın
/// içerik güvencesi gösteriliyor. Bkz. proje hafızası: mahremiyet çizgisi
/// bilinçli bir ürün kararı, eksiklik değil.
class ParentPanelScreen extends ConsumerWidget {
  const ParentPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycle = ref.watch(cycleProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceVariantLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.ink),
        title: Text('Ebeveyn Paneli', style: AppTextStyles.heading(fontSize: 20, color: AppColors.ink)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Merhaba, Ebeveyn', style: AppTextStyles.heading(fontSize: 26, color: AppColors.ink)),
          const SizedBox(height: 4),
          Text(
            'Çocuğunuzun döngü takibini ve uygulamanın içerik güvencesini buradan görebilirsiniz.',
            style: TextStyle(fontSize: 14, color: AppColors.ink.withValues(alpha: 0.6), height: 1.4),
          ),
          const SizedBox(height: 24),

          CleanCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.water_drop_outlined, color: AppColors.softPink, size: 20),
              const SizedBox(width: 8),
              Text('Döngü Genel Bakış', style: AppTextStyles.heading(fontSize: 16, color: AppColors.ink)),
            ]),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Son adet başlangıcı',
              value: cycle.periods.isNotEmpty
                  ? DateFormat('d MMMM yyyy', 'tr_TR').format(cycle.periods.last.startDate)
                  : 'Henüz kayıt yok',
            ),
            _InfoRow(label: 'Şu an', value: '${cycle.currentCycleDay}. gün'),
            _InfoRow(
              label: 'Ortalama döngü uzunluğu',
              value: cycle.canPredict ? '${cycle.averageCycleLength} gün' : 'Henüz yeterli veri yok',
            ),
            _InfoRow(label: 'Kayıtlı döngü sayısı', value: '${cycle.periods.length}'),
          ])),
          const SizedBox(height: 16),

          CleanCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.shield_outlined, color: AppColors.warmOrange, size: 20),
              const SizedBox(width: 8),
              Text('Uygulamada Neler Var, Neler Yok', style: AppTextStyles.heading(fontSize: 16, color: AppColors.ink)),
            ]),
            const SizedBox(height: 14),
            ..._included.map((t) => _CheckRow(text: t, included: true)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: AppColors.ink.withValues(alpha: 0.08), height: 1),
            ),
            const SizedBox(height: 6),
            ..._excluded.map((t) => _CheckRow(text: t, included: false)),
          ])),
          const SizedBox(height: 16),

          CleanCard(
            color: AppColors.cardCream,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.lock_outline_rounded, color: AppColors.ink.withValues(alpha: 0.5), size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(
                'Çocuğunuzun ruh hali, semptom ve günlük not girişleri kişiye özeldir ve bu panelde gösterilmez. Bu, ona dürüst ve açık kayıt tutabileceği bir alan tanımak için bilinçli bir tercihtir.',
                style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.7), height: 1.5),
              )),
            ]),
          ),
        ]),
      ),
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
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.5)))),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
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
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.75), height: 1.4))),
      ]),
    );
  }
}
