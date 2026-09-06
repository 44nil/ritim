import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../content/legal_content.dart';

/// Gizlilik Politikası / Kullanım Şartları gibi bağımsız yasal metinleri
/// gösteren genel amaçlı ekran. Profil'den ve onboarding içindeki
/// linklerden erişilir.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariantLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.inkOn(context)),
        title: Text(title, style: AppTextStyles.heading(fontSize: 18, color: AppColors.inkOn(context))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Geri',
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DraftBanner(),
              const SizedBox(height: 20),
              Text(
                body,
                style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.inkOn(context).withValues(alpha: 0.85)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftBanner extends StatelessWidget {
  const _DraftBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: AppColors.inkOn(context).withValues(alpha: 0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              kLegalDraftDisclaimer,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkOn(context).withValues(alpha: 0.75), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
