import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Onboarding'e gömülü aydınlatma + açık rıza adımı. Tek ekranda hem KVKK
/// Madde 10 aydınlatma yükümlülüğünü (özet metin + tam metne link) hem de
/// Madde 9 açık rızasını (checkbox, varsayılan işaretsiz — olumlu irade
/// beyanı gerekir) karşılar. İki adımın tek ekranda birleştirilmesi yasal
/// olarak sorunsuz — KVKK sadece aydınlatmanın rızadan ÖNCE gelmesini şart
/// koşuyor, ayrı ekranlarda olmasını değil (bkz. docs/legal-compliance-notes.md).
class ConsentGateStep extends StatelessWidget {
  const ConsentGateStep({
    super.key,
    required this.checked,
    required this.onChanged,
    required this.onOpenPrivacyPolicy,
    required this.onOpenTerms,
    required this.onOpenPrivacyNotice,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpenPrivacyPolicy;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacyNotice;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('KURULUM', style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          )),
          const SizedBox(height: 12),
          Text('Verilerin\nnasıl kullanılıyor?', style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 16),
          Text(
            'Yaşını, döngü bilgilerini ve istersen ruh hali/belirti notlarını, '
            'döngünü takip edebilmen ve yaşına uygun genel bilgi sunabilmemiz '
            'için kullanıyoruz. Bu bilgiler sadece senin kendi cihazlarında '
            'kalır, bize ya da başka kimseyle satılmaz, paylaşılmaz.',
            style: TextStyle(fontSize: 13.5, height: 1.6, color: AppColors.inkOn(context).withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onOpenPrivacyNotice,
            child: Text(
              'Tam KVKK Aydınlatma Metnini Oku',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 28),
          Semantics(
            checked: checked,
            child: GestureDetector(
            onTap: () => onChanged(!checked),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: checked ? Colors.white : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: checked ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24, height: 24,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: checked ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: checked ? AppColors.primary : AppColors.inkOn(context).withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: checked
                        ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Verilerimin yukarıda açıklandığı ve KVKK Aydınlatma '
                      'Metni\'nde detaylandığı şekilde kullanılmasına izin veriyorum.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.inkOn(context), height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(height: 16),
          Wrap(
            spacing: 4,
            children: [
              _LinkText(label: 'Gizlilik Politikası', onTap: onOpenPrivacyPolicy),
              Text('ve', style: TextStyle(fontSize: 13, color: AppColors.inkOn(context).withValues(alpha: 0.5))),
              _LinkText(label: 'Kullanım Şartları', onTap: onOpenTerms),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  const _LinkText({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
