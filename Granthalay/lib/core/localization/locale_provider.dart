import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('mr');
  bool _isInitialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;
  bool get isMarathi => _locale.languageCode == 'mr';

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString(AppConstants.keySelectedLanguage);
      if (savedLang != null && (savedLang == 'mr' || savedLang == 'en')) {
        _locale = Locale(savedLang);
      } else {
        _locale = const Locale('mr'); // Default to Marathi
      }
    } catch (_) {
      _locale = const Locale('mr');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (newLocale.languageCode != 'mr' && newLocale.languageCode != 'en') return;
    if (_locale.languageCode == newLocale.languageCode) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keySelectedLanguage, newLocale.languageCode);
    } catch (_) {
      // Preferences write error ignored gracefully
    }
  }

  void toggleLocale() {
    if (_locale.languageCode == 'mr') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('mr'));
    }
  }
}
