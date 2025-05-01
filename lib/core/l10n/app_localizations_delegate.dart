import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'app_localizations_tr.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'tr':
        return AppLocalizationsTr();
      default:
        return AppLocalizationsTr();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 