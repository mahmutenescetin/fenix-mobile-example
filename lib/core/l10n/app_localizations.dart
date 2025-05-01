import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get serverError;
  String serverErrorWithCode(int code);
  String get networkError;
  String get cacheError;
  String get unknownError;
  String get retryButton;
  String get cancelButton;
} 