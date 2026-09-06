import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// 13 yaş altı kullanıcılar için gösterilen, yumuşak öneri niteliğindeki
/// ebeveyn/vasi eşliği ekranı. Zorunlu bir engel değildir — kullanıcı
/// isterse kendi başına devam edebilir; seçim onboarding_consent_provider'a
/// kaydedilir. Bkz. docs/legal-compliance-notes.md bölüm 7 (KVKK'da
/// çocuklar için sabit bir rıza yaşı yok, bu bir ürün/risk kararı).
class GuardianAssistGateStep extends StatelessWidget {
  const GuardianAssistGateStep({super.key, required this.choice, required this.onChanged});

  final bool? choice;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.15),
            ),
            child: Icon(Icons.shield_outlined, color: AppColors.secondary, size: 26),
          ),
          const SizedBox(height: 20),
          Text('KURULUM', style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          )),
          const SizedBox(height: 12),
          Text('Bir yetişkinle\nmi devam\nedelim?', style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w800, height: 1.1,
            color: AppColors.inkOn(context),
          )),
          const SizedBox(height: 12),
          Text(
            'Bu yaşta bir ebeveyn ya da vasinin seninle kurulumu tamamlaması '
            'önerilir. İstersen tek başına da devam edebilirsin.',
            style: TextStyle(fontSize: 14, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.4),
          ),
          const SizedBox(height: 40),
          _ChoiceCard(
            label: 'Bir yetişkinle birlikteyim',
            description: 'Ebeveynim/vasim verilerimin işlenmesine onay veriyor.',
            isSelected: choice == true,
            onTap: () => onChanged(true),
          ),
          const SizedBox(height: 12),
          _ChoiceCard(
            label: 'Kendi başıma devam etmek istiyorum',
            description: null,
            isSelected: choice == false,
            onTap: () => onChanged(false),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({required this.label, required this.description, required this.isSelected, required this.onTap});
  final String label;
  final String? description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.inkOn(context),
                  )),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(description!, style: TextStyle(
                      fontSize: 12.5, color: AppColors.inkOn(context).withValues(alpha: 0.5), height: 1.3,
                    )),
                  ],
                ],
              ),
            ),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.inkOn(context).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
