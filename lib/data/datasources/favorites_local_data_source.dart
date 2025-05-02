import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/movie_entity.dart';
import '../models/movie_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<MovieEntity>> getFavorites();
  Future<void> addToFavorites(MovieEntity movie);
  Future<void> removeFromFavorites(int movieId);
  Future<bool> isFavorite(int movieId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'favorites';

  FavoritesLocalDataSourceImpl(this._prefs);

  @override
  Future<List<MovieEntity>> getFavorites() async {
    final jsonString = _prefs.getString(_favoritesKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => MovieModel.fromJson(json)).toList();
  }

  @override
  Future<void> addToFavorites(MovieEntity movie) async {
    final favorites = await getFavorites();
    if (!favorites.any((m) => m.id == movie.id)) {
      favorites.add(movie);
      final jsonList = favorites.map((m) => (m as MovieModel).toJson()).toList();
      await _prefs.setString(_favoritesKey, json.encode(jsonList));
    }
  }

  @override
  Future<void> removeFromFavorites(int movieId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((m) => m.id == movieId);
    final jsonList = favorites.map((m) => (m as MovieModel).toJson()).toList();
    await _prefs.setString(_favoritesKey, json.encode(jsonList));
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((m) => m.id == movieId);
  }
} 