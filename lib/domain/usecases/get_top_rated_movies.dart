import 'package:fenix_mobile_example/domain/entities/movie_entity.dart';
import 'package:fenix_mobile_example/domain/repositories/movie_repository.dart';
import 'dart:developer' as developer;

class GetTopRatedMovies {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  Future<List<MovieEntity>> call({int page = 1}) async {
    developer.log('Calling getTopRatedMovies with page: $page');
    final movies = await repository.getTopRatedMovies(page: page);
    developer.log('Movies received: ${movies.length} items');
    return movies;
  }
} 
