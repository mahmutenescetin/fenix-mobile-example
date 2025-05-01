import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/search_movies.dart';

class HomeProvider extends ChangeNotifier {
  late GetTopRatedMovies _getTopRatedMovies;
  late SearchMovies _searchMovies;
  Timer? _debounce;

  List<MovieEntity>? _cachedTopRatedMovies;
  DateTime? _lastCacheTime;
  static const cacheDuration = Duration(minutes: 5);

  HomeProvider({
    required GetTopRatedMovies getTopRatedMovies,
    required SearchMovies searchMovies,
  })  : _getTopRatedMovies = getTopRatedMovies,
        _searchMovies = searchMovies;

  List<MovieEntity> _movies = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  List<MovieEntity> get movies => _movies;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void updateUseCases({
    required GetTopRatedMovies getTopRatedMovies,
    required SearchMovies searchMovies,
  }) {
    _getTopRatedMovies = getTopRatedMovies;
    _searchMovies = searchMovies;
  }

  bool _isCacheValid() {
    if (_cachedTopRatedMovies == null || _lastCacheTime == null) return false;
    final now = DateTime.now();
    return now.difference(_lastCacheTime!) < cacheDuration;
  }

  Future<void> loadTopRatedMovies() async {
    if (_isCacheValid()) {
      _movies = _cachedTopRatedMovies!;
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _movies = await _getTopRatedMovies();
      _cachedTopRatedMovies = _movies;
      _lastCacheTime = DateTime.now();
      _error = '';
    } catch (e) {
      _error = 'Error: $e';
      _movies = _cachedTopRatedMovies ?? [];
    }
    _setLoading(false);
  }

  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.isEmpty) {
      loadTopRatedMovies();
      return;
    }
    
    if (query.length < 2) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchMovies(query);
    });
  }

  Future<void> searchMovies(String query) async {
    _setLoading(true);
    try {
      _movies = await _searchMovies(query);
      _error = '';
    } catch (e) {
      _error = 'Search error: $e';
      _movies = [];
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearCache() {
    _cachedTopRatedMovies = null;
    _lastCacheTime = null;
  }
} 