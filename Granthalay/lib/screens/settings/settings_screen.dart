import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  final LocaleProvider localeProvider;
  final ApiService apiService;
  final VoidCallback? onOpenDrawer;

  const SettingsScreen({
    super.key,
    required this.localeProvider,
    required this.apiService,
    this.onOpenDrawer,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _confirmLogout() {
    final l10n = AppLocalizations.of(context)!;

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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = widget.localeProvider.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: widget.onOpenDrawer != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: widget.onOpenDrawer,
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Language Preference Card (मराठी / English)
            CustomCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        l10n.languagePreference,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  RadioListTile<String>(
                    title: Text(
                      l10n.marathiLanguage,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('मराठी भाषा (मराठीत आकडे व अक्षरे)'),
                    value: 'mr',
                    groupValue: currentLocale.languageCode,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) {
                        widget.localeProvider.setLocale(const Locale('mr'));
                      }
                    },
                  ),
                  const Divider(height: 12),
                  RadioListTile<String>(
                    title: Text(
                      l10n.englishLanguage,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('English language'),
                    value: 'en',
                    groupValue: currentLocale.languageCode,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) {
                        widget.localeProvider.setLocale(const Locale('en'));
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Granthalay Details Card
            CustomCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/granthalay_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.granthalayDetails,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const _InfoItem(label: 'ग्रंथालय', value: 'वसंत दादाश्री जिनवाणी महाग्रंथालय'),
                  const _InfoItem(label: 'स्थापना', value: '18-06-2018'),
                  const _InfoItem(label: 'गाव', value: 'कोथळी'),
                  const _InfoItem(label: 'पत्ता', value: 'ता. शिरोळ जि. कोल्हापूर (महाराष्ट्र)'),
                  const SizedBox(height: 8),
                  const Divider(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'संपर्क',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const _ContactRow(name: 'निलेश', phone: '9011441477'),
                  const _ContactRow(name: 'सचिन', phone: '9075086108'),
                  const Divider(height: 20),
                  _InfoItem(label: l10n.appVersion, value: AppConstants.appVersion),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            OutlinedButton.icon(
              onPressed: _confirmLogout,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error, width: 1.2),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.logout, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
  }
}

class _ContactRow extends StatelessWidget {
  final String name;
  final String phone;

  const _ContactRow({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.phone_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '$name: ',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          Text(
            phone,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
