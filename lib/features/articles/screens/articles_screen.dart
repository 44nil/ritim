import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/placeholder_screen.dart';

/// Makaleler ekranı.
/// TODO: Backend entegrasyonu — makale listesi ve içerikleri CMS'ten gelecek.
class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makaleler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              // TODO: Backend entegrasyonu — içerik filtrele
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Öne çıkan kategoriler
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
              ),
              children: [
                'Öne Çıkanlar',
                'Sağlık',
                'Psikoloji',
                'Beslenme',
                'Egzersiz',
                'İlişkiler',
              ].map((cat) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: cat == 'Öne Çıkanlar',
                      onSelected: (_) {
                        // TODO: Backend entegrasyonu — kategori filtrele
                      },
                    ),
                  )).toList(),
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),

          const Expanded(
            child: PlaceholderScreen(
              title: 'Bilgi Arşivi',
              description:
                  'Uzman yazarlar tarafından hazırlanan, sana özel seçilmiş makaleler burada.',
              icon: Icons.auto_stories_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
