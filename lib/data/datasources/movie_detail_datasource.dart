import 'dart:developer' as developer;
import '../../core/config/app_config.dart';
import '../../core/network/http_client.dart';
import '../../domain/entities/movie_detail_entity.dart';

class MovieDetailDataSource {
  final HttpClient client;

  MovieDetailDataSource({required this.client});

  Future<MovieDetailEntity> getMovieDetail(int movieId) async {
    try {
      developer.log('Fetching movie detail for id: $movieId');
      final response = await client.get(
        '/movie/$movieId',
        queryParameters: {'api_key': AppConfig.apiKey},
      );
      developer.log('Response received: $response');
      return MovieDetailEntity.fromJson(response);
    } catch (e, stackTrace) {
      developer.log(
        'Error in getMovieDetail',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load movie detail: $e');
    }
  }
} 