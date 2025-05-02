import 'package:flutter/material.dart';
import 'package:fenix_mobile_example/core/base/view_model_builder.dart';
import 'package:fenix_mobile_example/core/base/stateless_widget.dart';
import 'package:fenix_mobile_example/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:fenix_mobile_example/presentation/features/movie_detail/view/movie_detail_view.dart';
import 'package:fenix_mobile_example/domain/entities/movie_entity.dart';
import 'package:provider/provider.dart';
import 'package:fenix_mobile_example/domain/usecases/get_top_rated_movies.dart';
import 'package:fenix_mobile_example/domain/usecases/search_movies.dart';
import 'package:fenix_mobile_example/core/extensions/context_localization_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends BaseStatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>(
      initViewModel: () => HomeViewModel(
        context.read<GetTopRatedMovies>(),
        context.read<SearchMovies>(),
      ),
      builder: (context, viewModel) {
        final ScrollController scrollController = ScrollController();

        scrollController.addListener(() {
          if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
            if (viewModel.hasMore && !viewModel.isLoading) {
              viewModel.loadNextPage();
            }
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(context.str.moviesTitle),
            centerTitle: true,
            elevation: 0,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: context.str.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        viewModel.searchMovies('');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (query) {
                    viewModel.searchMovies(query, reset: true);
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: viewModel.loadMovies,
                  child: viewModel.isLoading && viewModel.movies.isEmpty
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
                                    onPressed: viewModel.loadMovies,
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
                                      const Icon(Icons.movie, size: 64, color: Colors.grey),
                                      const SizedBox(height: 16),
                                      Text(
                                        context.str.noMoviesFound,
                                        style: Theme.of(context).textTheme.titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        context.str.pleaseTryADifferentSearch,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: viewModel.movies.length + (viewModel.hasMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == viewModel.movies.length && viewModel.hasMore) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    final movie = viewModel.movies[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MovieDetailView(movieId: movie.id),
                                          ),
                                        ),
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
            ],
          ),
        );
      },
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  final HomeViewModel viewModel;

  MovieSearchDelegate(this.viewModel);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(context.str.searchHint),
      );
    }

    return FutureBuilder<List<MovieEntity>>(
      future: viewModel.searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  context.str.searchErrorMessage,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.searchMovies(query),
                  child: Text(context.str.tryAgain),
                ),
              ],
            ),
          );
        }

        final movies = snapshot.data ?? [];
        if (movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  context.str.noResultsFound,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  context.str.noResultsForQuery(query),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailView(movieId: movie.id),
                  ),
                ),
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
        );
      },
    );
  }
}