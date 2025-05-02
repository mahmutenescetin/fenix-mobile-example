import 'package:fenix_mobile_example/core/base/error_state_mixin.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/entities/movie_entity.dart';
import '../../../../domain/usecases/get_favorites.dart';
import '../../../../domain/usecases/add_to_favorites.dart';
import '../../../../domain/usecases/remove_from_favorites.dart';
import '../../../../domain/usecases/is_favorite.dart';

class FavoritesViewmodel extends ChangeNotifier with ErrorStateMixin {
  final GetFavorites _getFavorites;
  final AddToFavorites _addToFavorites;
  final RemoveFromFavorites _removeFromFavorites;
  final IsFavorite _isFavorite;

  List<MovieEntity> _favorites = [];
  bool _isLoading = false;

  FavoritesViewmodel(
    this._getFavorites,
    this._addToFavorites,
    this._removeFromFavorites,
    this._isFavorite,
  );

  List<MovieEntity> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    await handleError(
      () async {
        _favorites = await _getFavorites();
      },
      (failure) {
        _favorites = [];
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToFavorites(MovieEntity movie) async {
    await handleError(
      () async {
        await _addToFavorites(movie);
        _favorites.add(movie);
        notifyListeners();
      },
      (failure) {},
    );
  }

  Future<void> removeFromFavorites(int movieId) async {
    await handleError(
      () async {
        await _removeFromFavorites(movieId);
        _favorites.removeWhere((movie) => movie.id == movieId);
        notifyListeners();
      },
      (failure) {},
    );
  }

  Future<bool> isFavorite(int movieId) async {
    try {
      return await _isFavorite(movieId);
    } catch (e) {
      return false;
    }
  }
} 