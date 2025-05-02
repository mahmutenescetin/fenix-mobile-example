import 'package:fenix_mobile_example/core/base/error_state_mixin.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/entities/movie_detail_entity.dart';
import '../../../../domain/usecases/get_movie_detail.dart';


class MovieDetailViewmodel with ChangeNotifier, ErrorStateMixin {
  final GetMovieDetail _getMovieDetail;
  MovieDetailEntity? _movieDetail;
  bool _isLoading = false;

  MovieDetailViewmodel(this._getMovieDetail);

  MovieDetailEntity? get movieDetail => _movieDetail;
  bool get isLoading => _isLoading;

  Future<void> loadMovieDetail(int movieId) async {
    _isLoading = true;
    notifyListeners();

    await handleError(
      () async {
        _movieDetail = await _getMovieDetail(movieId);
      },
      (failure) {
        _movieDetail = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
} 