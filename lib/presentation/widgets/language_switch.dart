import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../i18n/strings.g.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final current = LocaleSettings.currentLocale;
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: current == AppLocale.tr ? 'English' : 'Türkçe',
      onPressed: () async {
        final newLocale = current == AppLocale.tr ? AppLocale.en : AppLocale.tr;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_locale', newLocale.languageCode);
        await LocaleSettings.setLocale(newLocale);
      },
    );
  }
}
