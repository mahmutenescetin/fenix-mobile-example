import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMovies {
  final MovieRepository _repository;

  GetTopRatedMovies(this._repository);

  Future<List<MovieEntity>> call({int page = 1}) async {
    return await _repository.getTopRatedMovies(page: page);
  }
} 