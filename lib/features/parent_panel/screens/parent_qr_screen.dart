import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/providers/cycle_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/screen_gradient_background.dart';
import '../models/parent_summary.dart';

const _qrLifetime = Duration(seconds: 60);

// Çocuğun ekranında gösterilen, veliye aktarılacak QR kodu. Süresi
// (60 sn) dolunca kayboluyor — fotoğraflanıp saklanmasın, güncelliğini
// korusun diye. Hiçbir sunucuya gitmiyor, sadece ekranda gösteriliyor.
class ParentQrScreen extends ConsumerStatefulWidget {
  const ParentQrScreen({super.key});

  @override
  ConsumerState<ParentQrScreen> createState() => _ParentQrScreenState();
}

class _ParentQrScreenState extends ConsumerState<ParentQrScreen> {
  String? _payload;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generate() {
    final summary = ParentSummary.fromCycleState(ref.read(cycleProvider));
    _timer?.cancel();
    setState(() {
      _payload = summary.encode();
      _secondsLeft = _qrLifetime.inSeconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        setState(() => _payload = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardCream,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.ink),
        title: Text('Veliye Göster', style: AppTextStyles.heading(fontSize: 20, color: AppColors.ink)),
      ),
      body: Stack(children: [
        const ScreenGradientBackground(),
        SafeArea(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Bu kodu velinle/vasinle paylaş — kendi telefonundaki Ritim '
              'uygulamasında "QR Tara" ile okusun (telefonun normal Kamera '
              'uygulaması bu kodu tanımaz, sadece uygulamanın kendi tarayıcısı '
              'çalışır). Ruh hali, semptom ya da notların bu kodda hiç yer '
              'almaz, sadece döngü genel bakışı paylaşılır.',
              style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.6), height: 1.5),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Center(
                child: _payload != null
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: QrImageView(data: _payload!, size: 220, version: QrVersions.auto),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.warmOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.info_outline_rounded, size: 14, color: AppColors.warmOrange),
                            const SizedBox(width: 6),
                            Text('Kamera değil, uygulamadaki "QR Tara"', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.7))),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        Text('$_secondsLeft saniye sonra kaybolur', style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.4))),
                      ])
                    : Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.timer_off_outlined, size: 40, color: AppColors.ink.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        Text('Kodun süresi doldu', style: AppTextStyles.heading(fontSize: 18, color: AppColors.ink)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _generate,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.ink, foregroundColor: Colors.white),
                          child: const Text('Yeni Kod Oluştur'),
                        ),
                      ]),
              ),
            ),
          ]),
        )),
      ]),
    );
  }
}
