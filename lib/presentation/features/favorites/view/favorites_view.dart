import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../viewmodel/favorites_viewmodel.dart';
import '../../../../core/widgets/movie_list_widget.dart';
import '../../../../core/extensions/error_handling_extension.dart';
import '../../movie_detail/view/movie_detail_view.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesViewmodel>().loadFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('favorites')),
      ),
      body: Consumer<FavoritesViewmodel>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            context.showErrorDialog(
              failure: provider.failure!,
              onRetry: () => provider.loadFavorites(),
            );
            return const SizedBox();
          }

          final movies = provider.favorites;
          if (movies.isEmpty) {
            return Center(
              child: Text(
                  AppLocalizations.of(context).translate('no_movies_found')),
            );
          }

          return MovieList(
            movies: movies,
            onMovieTap: (movie) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailView(movie: movie),
                ),
              );
            },
            onLoadMore: () {},
            isLoadingMore: false,
            hasMorePages: false,
          );
        },
      ),
    );
  }
}
