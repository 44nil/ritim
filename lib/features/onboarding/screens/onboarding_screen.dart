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
    _Page(icon: Icons.favorite_rounded, title: 'Ritim\'e\nHoş Geldin', body: 'Bedenini tanımana yardımcı olmak için buradayız.', color: AppColors.primary),
    _Page(icon: Icons.calendar_month_rounded, title: 'Döngünü\nTakip Et', body: 'Regl günlerini kaydet, belirtilerini not al, döngünü anla.', color: AppColors.phaseFollicular),
    _Page(icon: Icons.shield_rounded, title: 'Güvenli\nAlan', body: 'Kaydettiğin her şey sadece senin telefonunda kalır, kimseyle paylaşılmaz. Burada yargılanmadan, güvenle kendin olabilirsin.', color: AppColors.secondary),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _auraBlobs() {
    final configs = [
      [(-80.0, -80.0, 480.0, const Color(0xFFE8856E)), (150.0, 450.0, 420.0, const Color(0xFFF098B8)), (-100.0, 700.0, 400.0, const Color(0xFFE89870))],
      [(100.0, -100.0, 450.0, const Color(0xFFF07898)), (-80.0, 400.0, 480.0, const Color(0xFFD898B0)), (120.0, 650.0, 380.0, const Color(0xFFE8A890))],
      [(-60.0, 50.0, 500.0, const Color(0xFFD098D0)), (80.0, 350.0, 460.0, const Color(0xFFE88898)), (-40.0, 700.0, 420.0, const Color(0xFFC8A8D8))],
    ];
    final blobs = configs[_currentPage.clamp(0, configs.length - 1)];
    return blobs.map((b) => AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      left: b.$1,
      top: b.$2,
      child: Container(
        width: b.$3,
        height: b.$3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [b.$4.withValues(alpha: 0.65), b.$4.withValues(alpha: 0)],
          ),
        ),
      ),
    )).toList();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: AppConstants.animDurationNormal, curve: Curves.easeInOut);
    } else {
      context.go('/setup');
    }
  }

  void _skip() => context.go('/cycle-tracking');

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFF5EDE8)),
          // Aura blob'ları — sayfa değiştikçe hareket ediyor
          ..._auraBlobs(),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextButton(onPressed: _skip, child: const Text('Atla')),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) {
                      final p = _pages[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: p.color.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(p.icon, size: 52, color: p.color),
                            ),
                            const SizedBox(height: 36),
                            Text(
                              p.title,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              p.body,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (i) => AnimatedContainer(
                          duration: AppConstants.animDurationFast,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _currentPage ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _next,
                          child: Text(isLast ? 'Başlayalım' : 'İleri', style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Ebeveyn/vasi kendi telefonundan bir çocuğun QR'ını okutmak
                      // isterse — sessiz, keşfedilebilir bir link; ilk soru değil.
                      TextButton(
                        onPressed: () => context.push('/parent/scan'),
                        child: Text(
                          'Bir veli/vasi misiniz? QR ile bağlanın',
                          style: TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
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

class _Page {
  const _Page({required this.icon, required this.title, required this.body, required this.color});
  final IconData icon;
  final String title, body;
  final Color color;
}
