import 'package:fenix_mobile_example/domain/entities/movie_entity.dart';
import 'package:fenix_mobile_example/domain/entities/movie_detail_entity.dart';
import 'package:fenix_mobile_example/domain/repositories/movie_repository.dart';
import 'package:fenix_mobile_example/domain/datasources/movie_remote_data_source.dart';
import 'dart:developer' as developer;

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getTopRatedMovies({int page = 1}) async {
    developer.log('Getting top rated movies from repository');
    final movies = await remoteDataSource.getTopRatedMovies(page: page);
    developer.log('Movies received from repository: ${movies.length} items');
    return movies;
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query, {int page = 1}) async {
    return await remoteDataSource.searchMovies(query, page: page);
  }

  @override
  Future<MovieDetailEntity> getMovieDetail(int movieId) async {
    return await remoteDataSource.getMovieDetail(movieId);
  }
} 