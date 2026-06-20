import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/placeholder_screen.dart';

/// Soru-Cevap ekranı.
/// TODO: Backend entegrasyonu — soru listesi API'den gelecek, cevaplar uzman onaylı olacak.
class QaScreen extends StatelessWidget {
  const QaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru & Cevap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // TODO: Backend entegrasyonu — soru arama
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Kategori filtreleri
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
              ),
              children: [
                'Tümü',
                'Döngü',
                'Beden',
                'Psikoloji',
                'Beslenme',
              ].map((cat) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: cat == 'Tümü',
                      onSelected: (_) {
                        // TODO: Backend entegrasyonu — kategori filtrele
                      },
                    ),
                  )).toList(),
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),

          // İçerik alanı
          const Expanded(
            child: PlaceholderScreen(
              title: 'Merak Ettiğin Her Şey',
              description:
                  'Uzman ekibimizin hazırladığı, yaşına uygun soru ve cevaplar burada olacak.',
              icon: Icons.quiz_rounded,
            ),
          ),
        ],
      ),

      // Soru sor butonu
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Backend entegrasyonu — yeni soru gönder
        },
        icon: const Icon(Icons.help_outline_rounded),
        label: const Text('Soru Sor'),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
    );
  }
}
