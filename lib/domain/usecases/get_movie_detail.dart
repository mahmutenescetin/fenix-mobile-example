import 'package:fenix_mobile_example/domain/entities/movie_detail_entity.dart';
import 'package:fenix_mobile_example/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<MovieDetailEntity> call(int movieId) async {
    return await repository.getMovieDetail(movieId);
  }
} 