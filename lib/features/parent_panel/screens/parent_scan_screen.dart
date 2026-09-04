import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/router/route_names.dart';
import '../models/parent_summary.dart';

// Veli tarafı: çocuğun ekranındaki QR kodunu kamerayla okur. Hesap/şifre
// yok — sadece anlık bir özet (bkz. ParentSummary) çözülüp gösteriliyor,
// hiçbir yerde saklanmıyor.
class ParentScanScreen extends StatefulWidget {
  const ParentScanScreen({super.key});

  @override
  State<ParentScanScreen> createState() => _ParentScanScreenState();
}

class _ParentScanScreenState extends State<ParentScanScreen> {
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('QR Tara', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(children: [
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
