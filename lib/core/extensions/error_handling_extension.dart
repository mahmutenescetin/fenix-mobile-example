import 'package:flutter/material.dart';
import '../error/failures.dart';
import '../../presentation/widgets/error_dialog.dart';

extension ErrorHandlingExtension on BuildContext {
  void showErrorDialog({
    required Failure failure,
    VoidCallback? onRetry,
  }) {
    String title;
    String message;

    switch (failure.runtimeType) {
      case ServerFailure:
        title = 'Sunucu Hatası';
        message = failure.code != null 
          ? 'Sunucu hatası oluştu (${failure.code}): ${failure.message}'
          : 'Sunucu hatası oluştu: ${failure.message}';
        break;
      case NetworkFailure:
        title = 'Bağlantı Hatası';
        message = 'İnternet bağlantınızı kontrol edip tekrar deneyiniz: ${failure.message}';
        break;
      case CacheFailure:
        title = 'Önbellek Hatası';
        message = 'Veriler yüklenirken bir hata oluştu: ${failure.message}';
        break;
      default:
        title = 'Hata';
        message = 'Beklenmeyen bir hata oluştu: ${failure.message}';
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