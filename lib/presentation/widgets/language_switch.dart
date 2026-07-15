import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../i18n/strings.g.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({super.key});

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = LocaleSettings.currentLocale;
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: current == AppLocale.tr ? 'English' : 'Türkçe',
      onPressed: () async {
        final newLocale = current == AppLocale.tr ? AppLocale.en : AppLocale.tr;
        await LocaleSettings.setLocale(newLocale);
        _prefs?.setString('app_locale', newLocale.languageCode);
      },
    );
  }
}
