import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

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
      emoji: '💜',
      title: 'Ritim\'e\nHoş Geldin',
      body: 'Bedenini tanımana yardımcı olmak için buradayız.',
      gradient: [Color(0xFFFADDB0), Color(0xFFF5CABB)],
    ),
    _OnboardingPage(
      emoji: '📅',
      title: 'Döngünü\nTakip Et',
      body: 'Adet günlerini kaydet, belirtilerini not al, döngünü anla.',
      gradient: [Color(0xFFF5CABB), Color(0xFFF0C0C8)],
    ),
    _OnboardingPage(
      emoji: '🛡️',
      title: 'Güvenli\nAlan',
      body: 'Merak ettiğin soruları güvenle sor. Uzman onaylı içerikler burada.',
      gradient: [Color(0xFFF0C0C8), Color(0xFFE0C0D8)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
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
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient arka plan
          AnimatedContainer(
            duration: AppConstants.animDurationSlow,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _pages[_currentPage].gradient[0],
                  _pages[_currentPage].gradient[1],
                  const Color(0xFFFFF8F5),
                ],
                stops: const [0.0, 0.35, 0.7],
              ),
            ),
          ),

          SafeArea(
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
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) => _PageContent(page: _pages[i]),
                  ),
                ),

                // İndikatör + buton
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingL,
                    0,
                    AppConstants.paddingL,
                    AppConstants.paddingL,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: AppConstants.animDurationFast,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _currentPage ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == _currentPage
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          child: Text(
                            isLastPage ? 'Başlayalım' : 'İleri',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
          Text(page.emoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
    required this.emoji,
    required this.title,
    required this.body,
    required this.gradient,
  });

  final String emoji;
  final String title;
  final String body;
  final List<Color> gradient;
}
