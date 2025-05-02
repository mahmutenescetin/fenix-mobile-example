import 'package:flutter/foundation.dart';
import 'package:fenix_mobile_example/domain/entities/movie_entity.dart';
import 'package:fenix_mobile_example/core/base/base_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesViewModel extends BaseViewModel {
  List<MovieEntity> _movies = [];

  List<MovieEntity> get movies => _movies;

  @override
  void onBindingCreated() {
    super.onBindingCreated();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      setLoading(true);
      _movies = await _getFavorites();
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<List<MovieEntity>> _getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getKeys()
        .where((key) => key.startsWith('favorite_'))
        .map((key) => key.split('_')[1])
        .toSet()
        .toList();
    
    return favoriteIds.map((id) {
      try {
        final movieId = int.parse(id);
        final title = prefs.getString('favorite_${id}_title') ?? '';
        if (title.isEmpty) return null;
        return MovieEntity(
          id: movieId,
          title: title,
          overview: prefs.getString('favorite_${id}_overview') ?? '',
          posterPath: prefs.getString('favorite_${id}_posterPath'),
          voteAverage: prefs.getDouble('favorite_${id}_voteAverage') ?? 0.0,
        );
      } catch (e) {
        debugPrint('Error parsing favorite ID: $id');
        return null;
      }
    }).whereType<MovieEntity>().toList();
  }
} 