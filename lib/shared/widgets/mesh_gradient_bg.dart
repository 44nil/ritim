import 'package:flutter/material.dart';

class MeshGradientBg extends StatelessWidget {
  const MeshGradientBg({super.key, this.isDark = false});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (isDark) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF201820), Color(0xFF151015)],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Base — açık pembe
        Container(color: const Color(0xFFFDE8E8)),

        // Blob 1 — sağ üst: coral/turuncu
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 350,
            height: 350,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFF0A08A), Color(0x00F0A08A)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Blob 2 — sol orta: sıcak pembe
        Positioned(
          top: 200,
          left: -100,
          child: Container(
            width: 450,
            height: 450,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFF5A0B8), Color(0x00F5A0B8)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Blob 3 — alt orta: canlı pembe/magenta
        Positioned(
          bottom: 100,
          right: -50,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFE880A0), Color(0x00E880A0)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Blob 4 — sol alt: peach/salmon
        Positioned(
          bottom: -50,
          left: -30,
          child: Container(
            width: 350,
            height: 350,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFF0B898), Color(0x00F0B898)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Blob 5 — üst orta: açık lavanta
        Positioned(
          top: 50,
          left: 50,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFF8D0D8), Color(0x00F8D0D8)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
