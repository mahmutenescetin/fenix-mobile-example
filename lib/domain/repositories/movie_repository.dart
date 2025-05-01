import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getTopRatedMovies();
  Future<List<MovieEntity>> searchMovies(String query);
} 