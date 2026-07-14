import 'package:flutter/material.dart';
import '../../i18n/strings.g.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final current = LocaleSettings.currentLocale;
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: current == AppLocale.tr ? 'English' : 'Türkçe',
      onPressed: () {
        LocaleSettings.setLocale(
          current == AppLocale.tr ? AppLocale.en : AppLocale.tr,
        );
      },
    );
  }
}
