import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MovieEntity>> getTopRatedMovies() async {
    return await remoteDataSource.getTopRatedMovies();
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    return await remoteDataSource.searchMovies(query);
  }
} 