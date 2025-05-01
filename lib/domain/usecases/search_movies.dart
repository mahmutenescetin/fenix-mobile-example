import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<List<MovieEntity>> call(String query) async {
    if (query.length < 2) return [];
    return await repository.searchMovies(query);
  }
} 