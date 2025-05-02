import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, dynamic> _localizedStrings = {};

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap;
    return true;
  }

  String translate(String key) {
    List<String> keys = key.split('.');
    dynamic value = _localizedStrings;
    
    for (String k in keys) {
      if (value is! Map) return key;
      value = value[k];
      if (value == null) return key;
    }
    
    return value.toString();
  }

  String get serverError => translate('error.server');
  String serverErrorWithCode(int code) => '${translate('error.server')} (Code: $code)';
  String get networkError => translate('error.network');
  String get cacheError => translate('error.cache');
  String get unknownError => translate('error.unknown');
  String get retryButton => translate('error.retry');
  String get cancelButton => translate('error.cancel');
} 