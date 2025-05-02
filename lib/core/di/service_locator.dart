import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../network/http_client.dart';
import '../../domain/datasources/movie_remote_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../../domain/usecases/get_movie_detail.dart';
import 'package:get_it/get_it.dart';

class ServiceLocator {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<SingleChildWidget> providers = [
    Provider<HttpClient>(
      create: (_) => DioClient(),
    ),
    Provider<SharedPreferences>(
      create: (_) => _prefs,
    ),
    ProxyProvider<HttpClient, MovieRemoteDataSource>(
      create: (context) => MovieRemoteDataSourceImpl(
        context.read<HttpClient>(),
      ),
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
    ProxyProvider<MovieRepository, GetMovieDetail>(
      update: (_, repository, __) => GetMovieDetail(repository),
    ),
  ];
}

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Network
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Data Sources
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetTopRatedMovies>(
    () => GetTopRatedMovies(getIt()),
  );
  getIt.registerLazySingleton<SearchMovies>(
    () => SearchMovies(getIt()),
  );
  getIt.registerLazySingleton<GetMovieDetail>(
    () => GetMovieDetail(getIt()),
  );
} 