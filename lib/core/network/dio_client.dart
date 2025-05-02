import 'package:dio/dio.dart';
import 'package:fenix_mobile_example/core/config/app_config.dart';
import 'package:fenix_mobile_example/core/error/exceptions.dart';
import 'package:fenix_mobile_example/core/network/http_client.dart';
import 'dart:developer' as developer;

class DioClient implements HttpClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = '';
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> put(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(url, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw NetworkException(
        message: 'Unexpected status code: ${response.statusCode}',
      );
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        return NetworkException(
          message: 'Bad response: ${error.response?.statusCode}',
        );
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'Connection error');
      case DioExceptionType.unknown:
        return NetworkException(message: 'Unknown error: ${error.message}');
      case DioExceptionType.badCertificate:
        return NetworkException(message: 'Bad certificate');
    }
  }
} 
