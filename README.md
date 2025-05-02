# Fenix Mobile Example

## Used Packages

### Core Packages
- **flutter**: Flutter framework
- **flutter_localizations**: Flutter's localization support
- **cupertino_icons**: iOS style icons

### State Management
- **provider**: State management in widget tree
- **get_it**: Dependency injection

### Network & Storage
- **dio**: Advanced HTTP client for network requests
- **shared_preferences**: Local data storage

### Development Tools
- **flutter_test**: Flutter test framework
- **flutter_lints**: Code quality and style checks

## Project Structure

```
lib/
├── core/
│   ├── base/           # Base widget and view model classes
│   ├── di/             # Dependency injection configuration
│   ├── extensions/     # Context and other extensions
│   └── localization/   # Localization files
├── data/
│   ├── datasources/    # Data sources
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Entity classes
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Use case classes
└── presentation/
    └── features/       # Feature-based views and view models
```

## Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/yourusername/fenix_mobile_example.git
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## Özellikler

- Film listesi görüntüleme
- Film detayları
- Favori filmleri kaydetme
- Film arama
- Çoklu dil desteği (İngilizce)

## Katkıda Bulunma

1. Fork'layın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun
