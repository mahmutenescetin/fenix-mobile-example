import 'package:flutter/foundation.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/usecases/get_movie_detail.dart';

class MovieDetailProvider with ChangeNotifier {
  final GetMovieDetail _getMovieDetail;
  MovieDetailEntity? _movieDetail;
  String? _error;
  bool _isLoading = false;

  MovieDetailProvider(this._getMovieDetail);

  MovieDetailEntity? get movieDetail => _movieDetail;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> loadMovieDetail(int movieId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _movieDetail = await _getMovieDetail(movieId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 