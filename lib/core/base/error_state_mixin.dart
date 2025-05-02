import 'package:flutter/foundation.dart';
import '../error/failures.dart';

mixin ErrorStateMixin on ChangeNotifier {
  Failure? _failure;
  bool _hasError = false;

  Failure? get failure => _failure;
  bool get hasError => _hasError;

  void setError(Failure failure) {
    _failure = failure;
    _hasError = true;
    notifyListeners();
  }

  void clearError() {
    _failure = null;
    _hasError = false;
    notifyListeners();
  }

  Future<void> handleError(
    Future<void> Function() operation,
    Function(Failure) onError,
  ) async {
    try {
      clearError();
      await operation();
    } on Failure catch (e) {
      setError(e);
      onError(e);
    }
  }
} 