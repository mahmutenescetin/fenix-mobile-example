import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/search_movies.dart';
import 'base/error_state_mixin.dart';

class HomeProvider extends ChangeNotifier with ErrorStateMixin {
  final GetTopRatedMovies _getTopRatedMovies;
  final SearchMovies _searchMovies;
  Timer? _debounce;

  List<MovieEntity>? _cachedTopRatedMovies;
  DateTime? _lastCacheTime;
  static const cacheDuration = Duration(minutes: 5);

  List<MovieEntity> _movies = [];
  String? _error;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasMorePages = true;

  List<MovieEntity> get movies => _movies;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get searchQuery => _searchQuery;
  bool get hasMorePages => _hasMorePages;

  HomeProvider(this._getTopRatedMovies, this._searchMovies);

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  bool _isCacheValid() {
    if (_cachedTopRatedMovies == null || _lastCacheTime == null) return false;
    final now = DateTime.now();
    return now.difference(_lastCacheTime!) < cacheDuration;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingMore(bool value) {
    _isLoadingMore = value;
    notifyListeners();
  }

  void _resetPagination() {
    _currentPage = 1;
    _hasMorePages = true;
    _movies = [];
  }

  Future<void> getTopRatedMovies({bool loadMore = false}) async {
    if (loadMore && (!_hasMorePages || _isLoadingMore)) return;

    await handleError(() async {
      if (loadMore) {
        _setLoadingMore(true);
      } else {
        _setLoading(true);
        _resetPagination();
      }

      try {
        if (!loadMore && _isCacheValid()) {
          _movies = _cachedTopRatedMovies!;
        } else {
          final result = await _getTopRatedMovies(page: _currentPage);
          if (result.isEmpty) {
            _hasMorePages = false;
          } else {
            if (loadMore) {
              _movies.addAll(result);
            } else {
              _movies = result;
              _cachedTopRatedMovies = _movies;
              _lastCacheTime = DateTime.now();
            }
            _currentPage++;
          }
        }
      } finally {
        if (loadMore) {
          _setLoadingMore(false);
        } else {
          _setLoading(false);
        }
      }
      notifyListeners();
    }, (failure) {
      if (loadMore) {
        _setLoadingMore(false);
      } else {
        _setLoading(false);
      }
    });
  }

  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.isEmpty || query.length < 2) {
      getTopRatedMovies();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchMovies(query);
    });
  }

  Future<void> searchMovies(String query, {bool loadMore = false}) async {
    if (query.isEmpty) {
      await getTopRatedMovies();
      return;
    }

    if (loadMore && (!_hasMorePages || _isLoadingMore)) return;

    await handleError(() async {
      if (loadMore) {
        _setLoadingMore(true);
      } else {
        _setLoading(true);
        _resetPagination();
      }

      try {
        final result = await _searchMovies(query, page: _currentPage);
        if (result.isEmpty) {
          _hasMorePages = false;
        } else {
          if (loadMore) {
            _movies.addAll(result);
          } else {
            _movies = result;
          }
          _currentPage++;
        }
      } finally {
        if (loadMore) {
          _setLoadingMore(false);
        } else {
          _setLoading(false);
        }
      }
    }, (failure) {
      if (loadMore) {
        _setLoadingMore(false);
      } else {
        _setLoading(false);
      }
    });
  }

  void clearCache() {
    _cachedTopRatedMovies = null;
    _lastCacheTime = null;
  }
} 