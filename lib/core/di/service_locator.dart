import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../network/http_client.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/movie_detail_datasource.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/movie_detail_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/movie_detail_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/search_movies.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_to_favorites.dart';
import '../../domain/usecases/remove_from_favorites.dart';
import '../../domain/usecases/is_favorite.dart';
import '../../presentation/providers/home_provider.dart';
import '../../presentation/providers/movie_detail_provider.dart';
import '../../presentation/providers/favorites_provider.dart';

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
    ProxyProvider<SharedPreferences, FavoritesLocalDataSource>(
      create: (context) => FavoritesLocalDataSourceImpl(
        context.read<SharedPreferences>(),
      ),
      update: (_, prefs, __) => FavoritesLocalDataSourceImpl(prefs),
    ),
    ProxyProvider<MovieRemoteDataSource, MovieRepository>(
      update: (_, dataSource, __) => MovieRepositoryImpl(dataSource),
    ),
    ProxyProvider<MovieDetailDataSource, MovieDetailRepository>(
      update: (_, dataSource, __) => MovieDetailRepositoryImpl(dataSource),
    ),
    ProxyProvider<FavoritesLocalDataSource, FavoritesRepository>(
      update: (_, dataSource, __) => FavoritesRepositoryImpl(dataSource),
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
    ProxyProvider<FavoritesRepository, GetFavorites>(
      update: (_, repository, __) => GetFavorites(repository),
    ),
    ProxyProvider<FavoritesRepository, AddToFavorites>(
      update: (_, repository, __) => AddToFavorites(repository),
    ),
    ProxyProvider<FavoritesRepository, RemoveFromFavorites>(
      update: (_, repository, __) => RemoveFromFavorites(repository),
    ),
    ProxyProvider<FavoritesRepository, IsFavorite>(
      update: (_, repository, __) => IsFavorite(repository),
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
    ChangeNotifierProxyProvider4<GetFavorites, AddToFavorites,
        RemoveFromFavorites, IsFavorite, FavoritesProvider>(
      create: (context) => FavoritesProvider(
        context.read<GetFavorites>(),
        context.read<AddToFavorites>(),
        context.read<RemoveFromFavorites>(),
        context.read<IsFavorite>(),
      ),
      update: (_, getFavorites, addToFavorites, removeFromFavorites, isFavorite,
              __) =>
          FavoritesProvider(
        getFavorites,
        addToFavorites,
        removeFromFavorites,
        isFavorite,
      ),
    ),
  ];
} 