import '../repositories/favorites_repository.dart';

class RemoveFromFavorites {
  final FavoritesRepository _repository;

  RemoveFromFavorites(this._repository);

  Future<void> call(int movieId) {
    return _repository.removeFromFavorites(movieId);
  }
} 