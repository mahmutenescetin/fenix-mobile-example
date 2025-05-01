import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMovies {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getTopRatedMovies();
  }
} 