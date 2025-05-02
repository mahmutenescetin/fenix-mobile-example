import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(bool value, {String? message}) {
    _isError = value;
    _errorMessage = message;
    notifyListeners();
  }

  void resetError() {
    _isError = false;
    _errorMessage = null;
    notifyListeners();
  }

}