import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart';
import 'http_client.dart';

class DioClient implements HttpClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= Dio()
      ..options = BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
      )
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );

    return _instance!;
  }

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await instance.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await instance.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await instance.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await instance.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else {
      throw ServerException(
        message: 'Invalid response format',
        statusCode: response.statusCode,
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
        return ServerException(
          message: 'Server error',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled');
      default:
        return NetworkException(message: 'Network error: ${error.message}');
    }
  }
} 