import 'package:fenix_mobile_example/presentation/features/favorites/view/favorites_view.dart';
import 'package:fenix_mobile_example/presentation/features/home/view/home_view.dart';
import 'package:fenix_mobile_example/presentation/features/main/view/main_view.dart';
import 'package:fenix_mobile_example/presentation/features/movie_detail/view/movie_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:fenix_mobile_example/core/routes/app_routes.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainView());
      case AppRoutes.movieDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MovieDetailView(movieId: args['movieId']),
        );
      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
} 