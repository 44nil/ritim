import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/route_names.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    _TabItem(label: 'Döngüm', icon: Icons.water_drop_outlined, activeIcon: Icons.water_drop_rounded, routeName: RouteNames.cycleTracking),
    _TabItem(label: 'Sorular', icon: Icons.help_outline_rounded, activeIcon: Icons.help_rounded, routeName: RouteNames.qa),
    _TabItem(label: 'Okuma', icon: Icons.auto_stories_outlined, activeIcon: Icons.auto_stories_rounded, routeName: RouteNames.articles),
    _TabItem(label: 'Quiz', icon: Icons.emoji_events_outlined, activeIcon: Icons.emoji_events_rounded, routeName: RouteNames.quiz),
    _TabItem(label: 'Profil', icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, routeName: RouteNames.profile),
  ];

  void _onTabTap(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _tabs.asMap().entries.map((entry) {
            final i = entry.key;
            final tab = entry.value;
            final isActive = i == currentIndex;

            return GestureDetector(
              onTap: () => _onTabTap(i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isActive ? tab.activeIcon : tab.icon,
                      size: 22,
                      color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.35),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.icon, required this.activeIcon, required this.routeName});
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String routeName;
}
