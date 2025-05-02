import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isError = false;
  String? _errorMessage;
  bool _isDisposed = false;
  bool _isBusy = false;
  int _flowCount = 0;

  bool get isLoading => _isLoading;
  bool get isError => _isError;
  bool get hasError => _error != null;
  String? get error => _error;
  String? get errorMessage => _errorMessage;
  bool get isDisposed => _isDisposed;
  bool get isBusy => _isBusy;

  @protected
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @protected
  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void resetError() {
    _isError = false;
    _errorMessage = null;
    notifyListeners();
  }

  void notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> flow<T extends Object?>(
    final Function callback, {
    final ValueChanged<T>? onSuccess,
    final void Function(StackTrace, DioException)? onError,
    final void Function()? onFinally,
    final bool showLoading = true,
    final bool shouldWaitOtherFlows = false,
  }) async {
    _flowCount++;
    setLoading(showLoading);
    _isBusy = true;
    notify();

    try {
      final T data = await callback();
      onSuccess?.call(data);
    } on DioException catch (dioException, stackTrace) {
      setError(dioException.message);
      onError?.call(stackTrace, dioException);
    } catch (e) {
      setError(e.toString());
    } finally {
      onFinally?.call();

      _flowCount--;
      if (!shouldWaitOtherFlows) {
        setLoading(false);
      } else {
        if (_flowCount == 0) {
          setLoading(false);
        }
      }
      _isBusy = false;
      notify();
    }
  }

  @protected
  @visibleForTesting
  void onBindingCreated() {}

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
