import 'package:flutter/material.dart';
import '../error/failures.dart';
import '../l10n/app_localizations.dart';
import '../widgets/error_dialog.dart';

extension ErrorHandlingExtension on BuildContext {
  void showErrorDialog({
    required Failure failure,
    VoidCallback? onRetry,
  }) {
    String title;
    String message;

    final l10n = AppLocalizations.of(this);

    switch (failure.runtimeType) {
      case ServerFailure:
        title = l10n.serverError;
        message = failure.code != null 
          ? l10n.serverErrorWithCode(failure.code!)
          : l10n.serverError;
        break;
      case NetworkFailure:
        title = l10n.networkError;
        message = l10n.networkError;
        break;
      case CacheFailure:
        title = l10n.cacheError;
        message = l10n.cacheError;
        break;
      default:
        title = l10n.unknownError;
        message = l10n.unknownError;
    }

    showDialog(
      context: this,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
      ),
    );
  }
} 