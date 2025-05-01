import '../entities/movie_entity.dart';
import '../repositories/favorites_repository.dart';

class AddToFavorites {
  final FavoritesRepository _repository;

  AddToFavorites(this._repository);

  Future<void> call(MovieEntity movie) {
    return _repository.addToFavorites(movie);
  }
} 