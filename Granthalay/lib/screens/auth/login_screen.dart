import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final LocaleProvider localeProvider;

  const LoginScreen({
    super.key,
    required this.localeProvider,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'librarian');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulated short authentication delay for realistic UX
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMarathi = widget.localeProvider.isMarathi;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Language Switcher Bar
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      onPressed: () {
                        widget.localeProvider.toggleLocale();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      icon: const Icon(Icons.language, size: 18, color: AppColors.primary),
                      label: Text(
                        isMarathi ? 'English' : 'मराठी',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Library Brand Card
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/granthalay_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.libraryName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            l10n.demoModeNotice,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.loginTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.loginSubtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Username field
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: l10n.username,
                              prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return l10n.usernameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: l10n.password,
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return l10n.passwordRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Login button
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      l10n.loginButton,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Demo hint
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: AppColors.info),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.demoLoginHint,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    l10n.apiReadyNotice,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
