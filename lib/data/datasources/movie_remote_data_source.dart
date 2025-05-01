import 'dart:developer' as developer;
import '../../core/config/app_config.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/http_client.dart';
import '../../domain/entities/movie_entity.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieEntity>> getTopRatedMovies({int page = 1});
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final HttpClient client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieEntity>> getTopRatedMovies({int page = 1}) async {
    try {
      developer.log('Fetching top rated movies');
      final response = await client.get(
        AppConfig.topRatedMovies,
        queryParameters: {
          'api_key': AppConfig.apiKey,
          'page': page,
        },
      );

      final List<dynamic> results = response['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error fetching top rated movies: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1}) async {
    try {
      developer.log('Searching movies with query: $query');
      final response = await client.get(
        AppConfig.searchMovies,
        queryParameters: {
          'api_key': AppConfig.apiKey,
          'query': query,
          'page': page,
        },
      );

      final List<dynamic> results = response['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error searching movies: $e');
      throw ServerException(message: e.toString());
    }
  }
} 