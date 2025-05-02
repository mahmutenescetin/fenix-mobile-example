import 'dart:developer' as developer;
import '../../core/config/app_config.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/http_client.dart';
import '../entities/movie_entity.dart';
import '../entities/movie_detail_entity.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieEntity>> getTopRatedMovies({int page = 1});
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1});
  Future<MovieDetailEntity> getMovieDetail(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final HttpClient _httpClient;

  MovieRemoteDataSourceImpl(this._httpClient);

  @override
  Future<List<MovieEntity>> getTopRatedMovies({int page = 1}) async {
    developer.log('Getting top rated movies from remote data source');
    final response = await _httpClient.get(
      '${AppConfig.topRatedMovies}?api_key=${AppConfig.apiKey}&page=$page',
    );
    final results = response['results'] as List;
    developer.log('Movies received from remote data source: ${results.length} items');
    return results.map((json) => MovieEntity.fromJson(json)).toList();
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1}) async {
    developer.log('Searching movies with query: $query');
    final response = await _httpClient.get(
      '${AppConfig.searchMovies}?api_key=${AppConfig.apiKey}&query=$query&page=$page',
    );
    final results = response['results'] as List;
    developer.log('Search results received: ${results.length} items');
    return results.map((json) => MovieEntity.fromJson(json)).toList();
  }

  @override
  Future<MovieDetailEntity> getMovieDetail(int movieId) async {
    developer.log('Getting movie detail for id: $movieId');
    final response = await _httpClient.get(
      '${AppConfig.movieDetail}/$movieId?api_key=${AppConfig.apiKey}',
    );
    developer.log('Movie detail received');
    return MovieDetailEntity.fromJson(response);
  }
} 