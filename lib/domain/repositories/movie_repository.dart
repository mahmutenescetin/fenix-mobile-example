import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getTopRatedMovies({int page = 1});
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1});
} 