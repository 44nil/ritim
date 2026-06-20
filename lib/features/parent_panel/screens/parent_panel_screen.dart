import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/placeholder_screen.dart';

/// Ebeveyn paneli ana ekranı.
/// TODO: Backend entegrasyonu — çocuk profili, rapor verileri ve içerik ayarları buraya gelecek.
class ParentPanelScreen extends StatelessWidget {
  const ParentPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebeveyn Paneli'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              // TODO: Backend entegrasyonu — ebeveyn oturumunu kapat
              context.pop();
            },
          ),
        ],
        backgroundColor: theme.colorScheme.secondaryContainer,
      ),
      body: Column(
        children: [
          // Ebeveyn paneli başlık bandı
          Container(
            width: double.infinity,
            color: theme.colorScheme.secondaryContainer,
            padding: const EdgeInsets.fromLTRB(
              AppConstants.paddingL,
              0,
              AppConstants.paddingL,
              AppConstants.paddingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, Ebeveyn',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  'Çocuğunuzun aktivitesini buradan takip edin',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Panel içerikleri — placeholder
          Expanded(
            child: PlaceholderScreen(
              title: 'Ebeveyn Kontrol Merkezi',
              description:
                  'İlerleme raporları, içerik ayarları ve çocuğunuzla paylaşılan notlar burada görünecek.',
              icon: Icons.family_restroom_rounded,
              iconColor: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
