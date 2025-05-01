import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../network/dio_client.dart';
import '../network/http_client.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/movie_detail_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/movie_detail_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/movie_detail_repository.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../presentation/providers/home_provider.dart';
import '../../presentation/providers/movie_detail_provider.dart';

class ServiceLocator {
  static List<SingleChildWidget> providers = [
    Provider<HttpClient>(
      create: (_) => DioClient(),
    ),
    ProxyProvider<HttpClient, MovieRemoteDataSource>(
      create: (context) => MovieRemoteDataSourceImpl(
        client: context.read<HttpClient>(),
      ),
      update: (_, client, __) => MovieRemoteDataSourceImpl(client: client),
    ),
    ProxyProvider<HttpClient, MovieDetailDataSource>(
      create: (context) => MovieDetailDataSource(
        client: context.read<HttpClient>(),
      ),
      update: (_, client, __) => MovieDetailDataSource(client: client),
    ),
    ProxyProvider<MovieRemoteDataSource, MovieRepository>(
      update: (_, dataSource, __) => MovieRepositoryImpl(dataSource),
    ),
    ProxyProvider<MovieDetailDataSource, MovieDetailRepository>(
      update: (_, dataSource, __) => MovieDetailRepositoryImpl(dataSource),
    ),
    ProxyProvider<MovieRepository, GetTopRatedMovies>(
      update: (_, repository, __) => GetTopRatedMovies(repository),
    ),
    ProxyProvider<MovieRepository, SearchMovies>(
      update: (_, repository, __) => SearchMovies(repository),
    ),
    ProxyProvider<MovieDetailRepository, GetMovieDetail>(
      update: (_, repository, __) => GetMovieDetail(repository),
    ),
    ChangeNotifierProxyProvider2<GetTopRatedMovies, SearchMovies, HomeProvider>(
      create: (context) => HomeProvider(
        context.read<GetTopRatedMovies>(),
        context.read<SearchMovies>(),
      ),
      update: (_, __, ___, homeProvider) => homeProvider!,
    ),
    ChangeNotifierProxyProvider<GetMovieDetail, MovieDetailProvider>(
      create: (context) => MovieDetailProvider(
        context.read<GetMovieDetail>(),
      ),
      update: (_, getMovieDetail, __) => MovieDetailProvider(getMovieDetail),
    ),
  ];
} 