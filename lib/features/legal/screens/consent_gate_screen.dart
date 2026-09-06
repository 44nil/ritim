import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Onboarding'e gömülü açık rıza adımı. Aydınlatma metninden sonra gösterilir;
/// checkbox varsayılan olarak işaretsizdir (KVKK açık rıza — olumlu irade
/// beyanı gerekir, önceden işaretlenmiş kutu kabul edilmez).
class ConsentGateStep extends StatelessWidget {
  const ConsentGateStep({
    super.key,
    required this.checked,
    required this.onChanged,
    required this.onOpenPrivacyPolicy,
    required this.onOpenTerms,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpenPrivacyPolicy;
  final VoidCallback onOpenTerms;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Text('Son bir şey:\nrızan', style: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 12),
          Text(
            'Devam etmeden önce, verilerinin nasıl kullanıldığını onaylaman gerekiyor.',
            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.4),
          ),
          const SizedBox(height: 32),
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
                      'Regl döngüm, ruh halim ve belirtilerimle ilgili bilgilerin '
                      'KVKK Aydınlatma Metni\'nde açıklanan şekilde Ritim tarafından '
                      'işlenmesini kabul ediyorum.',
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
          const Spacer(),
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
