import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/locale_provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/routing/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final LocaleProvider localeProvider;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    required this.localeProvider,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/granthalay_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.libraryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            l10n.demoModeNotice,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.dashboard_outlined,
                    title: l10n.navHome,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.dashboard);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.auto_stories_outlined,
                    title: l10n.navBooks,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.booksList);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.people_outline,
                    title: l10n.navMembers,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.membersList);
                    },
                  ),
                  const Divider(height: 16),
                  _DrawerItem(
                    icon: Icons.person_search_outlined,
                    title: l10n.quickSearchPerson,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.searchPerson);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.outbox_rounded,
                    title: l10n.quickIssueBook,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.issueBook);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.move_to_inbox_rounded,
                    title: l10n.quickReturnBook,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.returnBook);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.alarm_rounded,
                    title: l10n.overdueBooks,
                    iconColor: AppColors.error,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.overdueBooks);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.library_books_outlined,
                    title: l10n.currentlyIssuedTitle,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.currentlyIssued);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.insights_rounded,
                    title: l10n.reportsTitle,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.reports);
                    },
                  ),
                  const Divider(height: 16),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    title: l10n.navSettings,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                  ),
                ],
              ),
            ),

            // Footer Language Switch & Logout
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      localeProvider.toggleLocale();
                    },
                    icon: const Icon(Icons.language_rounded, size: 16),
                    label: Text(localeProvider.isMarathi ? 'EN' : 'मराठी'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.logout),
                          content: Text(l10n.logoutConfirm),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(l10n.cancel),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.login,
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                              child: Text(l10n.logout),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, size: 16, color: AppColors.error),
                    label: Text(l10n.logout, style: const TextStyle(color: AppColors.error)),
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      onTap: onTap,
    );
  }
}
