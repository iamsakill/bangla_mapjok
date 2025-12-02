import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  Locale _locale = const Locale('en');

  LocaleProvider(this.prefs) {
    final String? code = prefs.getString('app_locale');
    if (code != null) _locale = Locale(code);
  }

  Locale get locale => _locale;

  bool get isBangla => _locale.languageCode == 'bn';

  bool get hasChosen => prefs.getBool('locale_chosen') ?? false;

  Future<void> setLocale(String code) async {
    _locale = Locale(code);
    await prefs.setString('app_locale', code);
    await prefs.setBool('locale_chosen', true);
    notifyListeners();
  }
}
