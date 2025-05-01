import '../entities/movie_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository _repository;

  GetFavorites(this._repository);

  Future<List<MovieEntity>> call() {
    return _repository.getFavorites();
  }
} 