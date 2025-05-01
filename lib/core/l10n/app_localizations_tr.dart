import 'app_localizations.dart';

class AppLocalizationsTr extends AppLocalizations {
  @override
  String get serverError => 'Sunucu hatası oluştu';

  @override
  String serverErrorWithCode(int code) => 'Sunucu hatası oluştu (Kod: $code)';

  @override
  String get networkError => 'İnternet bağlantınızı kontrol edip tekrar deneyiniz';

  @override
  String get cacheError => 'Veriler yüklenirken bir hata oluştu';

  @override
  String get unknownError => 'Beklenmeyen bir hata oluştu';

  @override
  String get retryButton => 'Tekrar Dene';

  @override
  String get cancelButton => 'İptal';
} 