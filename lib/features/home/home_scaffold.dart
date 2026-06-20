import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_names.dart';

/// Ana scaffold — bottom navigation bar ve 5 sekmeyi barındırır.
/// go_router'ın ShellRoute'u ile entegre çalışır.
class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    _TabItem(
      label: 'Döngüm',
      icon: Icons.water_drop_outlined,
      activeIcon: Icons.water_drop_rounded,
      routeName: RouteNames.cycleTracking,
    ),
    _TabItem(
      label: 'Soru-Cevap',
      icon: Icons.help_outline_rounded,
      activeIcon: Icons.help_rounded,
      routeName: RouteNames.qa,
    ),
    _TabItem(
      label: 'Makaleler',
      icon: Icons.auto_stories_outlined,
      activeIcon: Icons.auto_stories_rounded,
      routeName: RouteNames.articles,
    ),
    _TabItem(
      label: 'Quiz',
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events_rounded,
      routeName: RouteNames.quiz,
    ),
    _TabItem(
      label: 'Profil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      routeName: RouteNames.profile,
    ),
  ];

  void _onTabTap(int index) {
    navigationShell.goBranch(
      index,
      // Sekmeye tekrar tıklanınca kökü göster
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTabTap,
          items: _tabs
              .map(
                (tab) => BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  activeIcon: Icon(tab.activeIcon),
                  label: tab.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.routeName,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String routeName;
}
