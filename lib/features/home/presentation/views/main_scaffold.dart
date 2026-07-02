import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNavBar(navigationShell),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _BottomNavBar(this.navigationShell);

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [_shadow()],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: List.generate(
              items.length,
              (index) => Expanded(
                child: _NavItem(
                  items[index],
                  navigationShell.currentIndex == index,
                  () => _onTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<_NavItemData> get _items => const [
        _NavItemData(Icons.home_outlined, Icons.home_rounded, AppStrings.tabHome),
        _NavItemData(Icons.search_outlined, Icons.search_rounded, AppStrings.tabSearch),
        _NavItemData(
          Icons.bookmark_outline_rounded,
          Icons.bookmark_rounded,
          AppStrings.tabBookings,
        ),
        _NavItemData(
          Icons.person_outline_rounded,
          Icons.person_rounded,
          AppStrings.tabProfile,
        ),
      ];

  BoxShadow _shadow() {
    return BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, -6),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItemData(this.icon, this.activeIcon, this.label);
}

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem(this.data, this.isActive, this.onTap);

  @override
  Widget build(BuildContext context) {
    final activeColor = isActive ? AppColors.primary : AppColors.textDisabled;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryLight.withValues(alpha: 0.34)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? data.activeIcon : data.icon, color: activeColor, size: 24),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: TextStyle(
                color: activeColor,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
