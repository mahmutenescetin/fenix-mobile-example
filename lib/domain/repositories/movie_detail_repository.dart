import '../entities/movie_detail_entity.dart';

abstract class MovieDetailRepository {
  Future<MovieDetailEntity> getMovieDetail(int movieId);
} 