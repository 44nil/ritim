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
  // "Bu telefonu kim kullanacak?" sorusu geçildi mi — eskiden bu seçim
  // altta küçük, kolayca kaçırılan bir metin linkiydi, artık ilk soru bu.
  bool _roleChosen = false;

  static const _pages = [
    _Page(icon: Icons.favorite_rounded, title: 'Ritim\'e\nHoş Geldin', body: 'Bedenini tanımana yardımcı olmak için buradayız.', color: AppColors.primary),
    _Page(icon: Icons.calendar_month_rounded, title: 'Döngünü\nTakip Et', body: 'Adet günlerini kaydet, belirtilerini not al, döngünü anla.', color: AppColors.phaseFollicular),
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
    if (!_roleChosen) {
      return _RoleGateScreen(
        onChild: () => setState(() => _roleChosen = true),
        onParent: () => context.push('/parent/scan'),
      );
    }

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

// İlk soru: "Bu telefonu kim kullanacak?" — eskiden alttaki küçük, kolayca
// kaçırılan bir metin linkiydi. Bir veli bu uygulamayı hiç çocuk kurulumuna
// girmeden, ilk ekrandan net bir seçimle ayırt edebilmeli.
class _RoleGateScreen extends StatelessWidget {
  const _RoleGateScreen({required this.onChild, required this.onParent});
  final VoidCallback onChild;
  final VoidCallback onParent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 88, height: 88,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: Icon(Icons.favorite_rounded, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 28),
              Text(
                'Bu telefonu\nkim kullanacak?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1),
              ),
              const SizedBox(height: 12),
              Text(
                'Ritim, hem gençler hem de veli/vasileri için — sana uygun akışı buradan seç.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 32),
              _RoleCard(
                icon: Icons.favorite_rounded,
                title: 'Ben kullanacağım',
                subtitle: 'Döngünü takip et, kendi güvenli alanını kur',
                color: AppColors.primary,
                onTap: onChild,
              ),
              const SizedBox(height: 14),
              _RoleCard(
                icon: Icons.shield_rounded,
                title: 'Bir veli/vasiyim',
                subtitle: 'QR ile çocuğunun döngü özetini görüntüle',
                color: AppColors.secondary,
                onTap: onParent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6))],
        ),
        child: Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 3),
            Text(subtitle, style: TextStyle(fontSize: 12.5, color: AppColors.ink.withValues(alpha: 0.5), height: 1.3)),
          ])),
          Icon(Icons.chevron_right_rounded, color: AppColors.ink.withValues(alpha: 0.25)),
        ]),
      ),
    );
  }
}
