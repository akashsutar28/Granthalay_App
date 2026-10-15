import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../l10n/generated/app_localizations.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: AppColors.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded, color: AppColors.primary),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_stories_outlined),
            selectedIcon: const Icon(Icons.auto_stories_rounded, color: AppColors.primary),
            label: l10n.navBooks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people_rounded, color: AppColors.primary),
            label: l10n.navMembers,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horizontal_circle_outlined),
            selectedIcon: const Icon(Icons.swap_horizontal_circle_rounded, color: AppColors.primary),
            label: l10n.navTransactions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded, color: AppColors.primary),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
