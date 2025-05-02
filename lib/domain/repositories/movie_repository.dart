import 'package:fenix_mobile_example/domain/entities/movie_entity.dart';
import 'package:fenix_mobile_example/domain/entities/movie_detail_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getTopRatedMovies({int page = 1});
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1});
  Future<MovieDetailEntity> getMovieDetail(int movieId);
} 