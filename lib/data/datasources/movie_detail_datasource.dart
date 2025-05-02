import 'dart:developer' as developer;
import 'package:fenix_mobile_example/core/config/app_config.dart';
import 'package:fenix_mobile_example/core/network/http_client.dart';
import 'package:fenix_mobile_example/domain/entities/movie_detail_entity.dart';

class MovieDetailDataSource {
  final HttpClient client;

  MovieDetailDataSource({required this.client});

  Future<MovieDetailEntity> getMovieDetail(int movieId) async {
    try {
      developer.log('Fetching movie detail for id: $movieId');
      final response = await client.get(
        '${AppConfig.movieDetail}/$movieId?api_key=${AppConfig.apiKey}',
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
