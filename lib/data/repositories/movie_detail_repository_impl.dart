import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/repositories/movie_detail_repository.dart';
import '../datasources/movie_detail_datasource.dart';

class MovieDetailRepositoryImpl implements MovieDetailRepository {
  final MovieDetailDataSource _dataSource;

  MovieDetailRepositoryImpl(this._dataSource);

  @override
  Future<MovieDetailEntity> getMovieDetail(int movieId) async {
    return await _dataSource.getMovieDetail(movieId);
  }
} 