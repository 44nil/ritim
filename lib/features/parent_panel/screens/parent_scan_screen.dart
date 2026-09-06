import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/screen_gradient_background.dart';
import '../models/parent_summary.dart';

// Veli tarafı: çocuğun ekranındaki QR kodunu kamerayla okur. Hesap/şifre
// yok — sadece anlık bir özet (bkz. ParentSummary) çözülüp gösteriliyor,
// hiçbir yerde saklanmıyor. Kamerayı hemen açmak yerine önce neden
// gerektiğini anlatan bir ara ekran gösteriyoruz — izin isteği kullanıcıyı
// hazırlıksız yakalamasın diye.
class ParentScanScreen extends StatefulWidget {
  const ParentScanScreen({super.key});

  @override
  State<ParentScanScreen> createState() => _ParentScanScreenState();
}

class _ParentScanScreenState extends State<ParentScanScreen> {
  bool _started = false;
  bool _handled = false;
  String? _error;

  void _onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null) return;
    try {
      final summary = ParentSummary.decode(raw);
      _handled = true;
      context.pushReplacementNamed(RouteNames.parentPanel, extra: summary);
    } catch (_) {
      setState(() => _error = 'Bu bir Ritim QR kodu değil gibi görünüyor. Tekrar dene.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return _ScanIntroScreen(onStart: () => setState(() => _started = true));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('QR Tara', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(fit: StackFit.expand, children: [
        MobileScanner(onDetect: _onDetect),
        Positioned(
          left: 0, right: 0, bottom: 40,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(16)),
            child: Text(
              _error ?? 'Çocuğunun ekranındaki QR kodunu kareye getir',
              textAlign: TextAlign.center,
              style: TextStyle(color: _error != null ? Colors.orangeAccent : Colors.white, fontSize: 13),
            ),
          ),
        ),
      ]),
    );
  }
}

class _ScanIntroScreen extends StatelessWidget {
  const _ScanIntroScreen({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardOn(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.inkOn(context)),
      ),
      body: Stack(fit: StackFit.expand, children: [
        const ScreenGradientBackground(),
        SafeArea(child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 88, height: 88,
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: Icon(Icons.qr_code_scanner_rounded, size: 40, color: AppColors.secondary),
              ),
              const SizedBox(height: 28),
              Text(
                'QR Kodunu\nOkut',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1),
              ),
              const SizedBox(height: 12),
              Text(
                'Çocuğunun ekranında gösterdiği QR kodu okumak için kamerana '
                'ihtiyacımız var. Hiçbir görüntü kaydedilmez ya da saklanmaz — '
                'sadece kod anlık olarak çözülür.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.inkOn(context), foregroundColor: Colors.white),
                  child: const Text('Taramaya Başla', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        )),
      ]),
    );
  }
}
