import '../entities/movie_detail_entity.dart';
import '../repositories/movie_detail_repository.dart';

class GetMovieDetail {
  final MovieDetailRepository repository;

  GetMovieDetail(this.repository);

  Future<MovieDetailEntity> call(int movieId) async {
    return await repository.getMovieDetail(movieId);
  }
} 