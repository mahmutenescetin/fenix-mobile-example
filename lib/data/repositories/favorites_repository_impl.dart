import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<List<MovieEntity>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  @override
  Future<void> addToFavorites(MovieEntity movie) {
    return _localDataSource.addToFavorites(movie);
  }

  @override
  Future<void> removeFromFavorites(int movieId) {
    return _localDataSource.removeFromFavorites(movieId);
  }

  @override
  Future<bool> isFavorite(int movieId) {
    return _localDataSource.isFavorite(movieId);
  }
} 