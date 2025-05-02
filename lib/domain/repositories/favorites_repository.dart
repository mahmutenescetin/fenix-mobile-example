import '../entities/movie_entity.dart';

abstract class FavoritesRepository {
  Future<List<MovieEntity>> getFavorites();
  Future<void> addToFavorites(MovieEntity movie);
  Future<void> removeFromFavorites(int movieId);
  Future<bool> isFavorite(int movieId);
} 