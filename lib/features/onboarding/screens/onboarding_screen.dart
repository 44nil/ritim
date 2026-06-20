import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.favorite_rounded,
      title: 'Merhaba!',
      subtitle: 'Ritim\'e hoş geldin',
      body: 'Bedenini tanımana yardımcı olmak için buradayız. '
          'Döngünü takip et, sorularını sor, kendini keşfet.',
    ),
    _OnboardingPage(
      icon: Icons.calendar_month_rounded,
      title: 'Döngünü Takip Et',
      subtitle: 'Her ay ne yaşandığını anla',
      body: 'Adet günlerini kaydet, belirtileri not al. '
          'Ritim, döngünün hangi aşamasında olduğunu sana söyler.',
    ),
    _OnboardingPage(
      icon: Icons.shield_rounded,
      title: 'Güvenli Alan',
      subtitle: 'Merak etmek cesaret ister',
      body: 'Sormaktan çekindiğin soruları güvenle sorabilirsin. '
          'Uzman onaylı, yaşına uygun içerikler burada.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < AppConstants.onboardingPageCount - 1) {
      _pageController.nextPage(
        duration: AppConstants.animDurationNormal,
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    // TODO: Backend entegrasyonu — onboarding tamamlandı flag'ini kaydet
    context.go('/cycle-tracking');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == AppConstants.onboardingPageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Atla butonu
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM,
                  vertical: AppConstants.paddingS,
                ),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('Atla'),
                ),
              ),
            ),

            // Sayfalar
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _PageContent(page: _pages[index]),
              ),
            ),

            // İndikatör + buton
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Column(
                children: [
                  // Nokta indikatörler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: AppConstants.animDurationFast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // İleri / Başla butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(isLastPage ? 'Başlayalım' : 'İleri'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.page});
  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // İllüstrasyon alanı — gerçek asset buraya gelecek
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 72,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),

          Text(
            page.subtitle,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            page.title,
            style: theme.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Text(
            page.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String body;
}
