import 'package:flutter/foundation.dart';
import 'package:fenix_mobile_example/domain/entities/movie_detail_entity.dart';
import 'package:fenix_mobile_example/domain/usecases/get_movie_detail.dart';
import 'package:fenix_mobile_example/core/base/base_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailViewModel extends BaseViewModel {
  final GetMovieDetail _getMovieDetail;
  final int movieId;
  MovieDetailEntity? _movie;
  bool _isFavorite = false;

  MovieDetailViewModel(this._getMovieDetail, {required this.movieId});

  MovieDetailEntity? get movie => _movie;
  bool get isFavorite => _isFavorite;

  @override
  void onBindingCreated() {
    super.onBindingCreated();
    _loadMovieDetail();
    _checkFavoriteStatus();
  }

  Future<void> _loadMovieDetail() async {
    try {
      setLoading(true);
      _movie = await _getMovieDetail(movieId);
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isFavorite = prefs.getBool('favorite_$movieId') ?? false;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    _isFavorite = !_isFavorite;
    await prefs.setBool('favorite_$movieId', _isFavorite);
    
    if (_isFavorite && _movie != null) {
      await prefs.setString('favorite_${movieId}_title', _movie!.title);
      await prefs.setString('favorite_${movieId}_overview', _movie!.overview);
      await prefs.setString('favorite_${movieId}_posterPath', _movie!.posterPath ?? '');
      await prefs.setDouble('favorite_${movieId}_voteAverage', _movie!.voteAverage);
    } else {
      await prefs.remove('favorite_${movieId}_title');
      await prefs.remove('favorite_${movieId}_overview');
      await prefs.remove('favorite_${movieId}_posterPath');
      await prefs.remove('favorite_${movieId}_voteAverage');
    }
    
    notifyListeners();
  }

  Future<void> removeFromFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorite_${movieId}');
    await prefs.remove('favorite_${movieId}_title');
    await prefs.remove('favorite_${movieId}_overview');
    await prefs.remove('favorite_${movieId}_posterPath');
    await prefs.remove('favorite_${movieId}_voteAverage');
  }
} 