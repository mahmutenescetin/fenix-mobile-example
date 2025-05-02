import 'package:flutter/foundation.dart';
import 'package:fenix_mobile_example/domain/entities/movie_entity.dart';
import 'package:fenix_mobile_example/domain/usecases/get_top_rated_movies.dart';
import 'package:fenix_mobile_example/domain/usecases/search_movies.dart';
import 'package:fenix_mobile_example/core/base/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeViewModel extends BaseViewModel {
  final GetTopRatedMovies _getTopRatedMovies;
  final SearchMovies _searchMovies;
  List<MovieEntity> _movies = [];
  List<MovieEntity> _cachedTopRatedMovies = [];
  Timer? _debounceTimer;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;
  String _lastQuery = '';

  HomeViewModel(this._getTopRatedMovies, this._searchMovies);

  List<MovieEntity> get movies => _movies;
  bool get hasMore => _hasMore;

  @override
  void onBindingCreated() {
    super.onBindingCreated();
    loadMovies(reset: true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> loadMovies({bool reset = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      if (reset) {
        _currentPage = 1;
        _movies = [];
        _hasMore = true;
      }
      setLoading(true);
      final movies = await _getTopRatedMovies(page: _currentPage);
      if (_currentPage == 1) {
        _movies = movies;
        _cachedTopRatedMovies = List.from(_movies);
      } else {
        _movies.addAll(movies);
      }
      _hasMore = movies.isNotEmpty;
      if (_hasMore) _currentPage++;
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
      _isFetching = false;
    }
  }

  Future<List<MovieEntity>> searchMovies(String query, {bool reset = false}) async {
    _debounceTimer?.cancel();
    if (query.length < 2) {
      _lastQuery = '';
      _movies = List.from(_cachedTopRatedMovies);
      notifyListeners();
      return _movies;
    }
    final completer = Completer<List<MovieEntity>>();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      _lastQuery = query;
      if (_isFetching) {
        completer.complete(_movies);
        return;
      }
      _isFetching = true;
      try {
        if (reset) {
          _currentPage = 1;
          _movies = [];
          _hasMore = true;
        }
        setLoading(true);
        final movies = await _searchMovies(query, page: _currentPage);
        if (_currentPage == 1) {
          _movies = movies;
        } else {
          _movies.addAll(movies);
        }
        _hasMore = movies.isNotEmpty;
        if (_hasMore) _currentPage++;
        notifyListeners();
      } catch (e) {
        setError(e.toString());
      } finally {
        setLoading(false);
        _isFetching = false;
        completer.complete(_movies);
      }
    });
    return completer.future;
  }

  Future<void> loadNextPage() async {
    if (_lastQuery.isEmpty || _lastQuery.length < 2) {
      await loadMovies();
    } else {
      await searchMovies(_lastQuery);
    }
  }

  void clearSearch() {
    // Implement clear search functionality
  }

  void scrollStart() {
    debugPrint('scrollStart called');
    // Implement scroll handling if needed
  }

  void navigateToDetail(int movieId) {
    debugPrint('navigateToDetail called with movieId: $movieId');
    // TODO: Implement navigation
  }
} 