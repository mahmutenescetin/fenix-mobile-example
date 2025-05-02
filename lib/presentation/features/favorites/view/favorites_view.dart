import 'package:flutter/material.dart';
import 'package:fenix_mobile_example/core/base/view_model_builder.dart';
import 'package:fenix_mobile_example/core/base/stateless_widget.dart';
import 'package:fenix_mobile_example/presentation/features/favorites/viewmodel/favorites_viewmodel.dart';
import 'package:fenix_mobile_example/presentation/features/movie_detail/view/movie_detail_view.dart';
import 'package:fenix_mobile_example/core/extensions/context_localization_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesView extends BaseStatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavoritesViewModel>(
      initViewModel: () => FavoritesViewModel(),
      // ignore: deprecated_member_use
      builder: (context, viewModel) => WillPopScope(
        onWillPop: () async {
          await viewModel.loadFavorites();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.str.favorites),
            centerTitle: true,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: viewModel.loadFavorites,
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              viewModel.error ?? context.str.anErrorOccurred,
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: viewModel.loadFavorites,
                              child: Text(context.str.tryAgain),
                            ),
                          ],
                        ),
                      )
                    : viewModel.movies.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  context.str.noFavoriteMovies,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  context.str.addFavoritesHint,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: viewModel.movies.length,
                            itemBuilder: (context, index) {
                              final movie = viewModel.movies[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailView(movieId: movie.id),
                                      ),
                                    );
                                    if (context.mounted) {
                                      await viewModel.loadFavorites();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: movie.posterPath != null
                                              ? CachedNetworkImage(
                                                  imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                  width: 80,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    width: 80,
                                                    height: 120,
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    width: 80,
                                                    height: 120,
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.error, size: 40, color: Colors.red),
                                                  ),
                                                )
                                              : Container(
                                                  width: 80,
                                                  height: 120,
                                                  color: Colors.grey[300],
                                                  child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                                                ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                movie.title,
                                                style: Theme.of(context).textTheme.titleMedium,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                movie.overview,
                                                style: Theme.of(context).textTheme.bodyMedium,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  const Icon(Icons.star, size: 16, color: Colors.amber),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    movie.voteAverage.toStringAsFixed(1),
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ),
      ),
    );
  }
}
