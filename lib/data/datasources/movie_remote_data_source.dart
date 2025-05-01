import '../../core/config/app_config.dart';
import '../../core/network/http_client.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final HttpClient _client;

  MovieRemoteDataSourceImpl(this._client);

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final response = await _client.get(AppConfig.topRatedMovies);
      return (response['results'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _client.get(
        AppConfig.searchMovies,
        queryParameters: {'query': query},
      );
      return (response['results'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
} 