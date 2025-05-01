import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../network/dio_client.dart';
import '../network/http_client.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../../presentation/providers/home_provider.dart';

class ServiceLocator {
  static List<SingleChildWidget> providers = [
    Provider<HttpClient>(
      create: (_) => DioClient(),
    ),
    ProxyProvider<HttpClient, MovieRemoteDataSource>(
      update: (_, client, __) => MovieRemoteDataSourceImpl(client),
    ),
    ProxyProvider<MovieRemoteDataSource, MovieRepository>(
      update: (_, dataSource, __) => MovieRepositoryImpl(dataSource),
    ),
    ProxyProvider<MovieRepository, GetTopRatedMovies>(
      update: (_, repository, __) => GetTopRatedMovies(repository),
    ),
    ProxyProvider<MovieRepository, SearchMovies>(
      update: (_, repository, __) => SearchMovies(repository),
    ),
    ChangeNotifierProxyProvider2<GetTopRatedMovies, SearchMovies, HomeProvider>(
      create: (context) => HomeProvider(
        getTopRatedMovies: context.read<GetTopRatedMovies>(),
        searchMovies: context.read<SearchMovies>(),
      ),
      update: (_, getTopRatedMovies, searchMovies, homeProvider) {
        homeProvider?.updateUseCases(
          getTopRatedMovies: getTopRatedMovies,
          searchMovies: searchMovies,
        );
        return homeProvider!;
      },
    ),
  ];
} 