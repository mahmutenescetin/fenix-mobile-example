import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fenix_mobile_example/core/base/view_model_builder.dart';
import 'package:fenix_mobile_example/core/base/stateless_widget.dart';
import 'package:fenix_mobile_example/presentation/features/movie_detail/viewmodel/movie_detail_viewmodel.dart';
import 'package:fenix_mobile_example/domain/usecases/get_movie_detail.dart';
import 'package:fenix_mobile_example/core/extensions/context_localization_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetailView extends BaseStatelessWidget {
  final int movieId;

  const MovieDetailView({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MovieDetailViewModel>(
      initViewModel: () => MovieDetailViewModel(
        context.read<GetMovieDetail>(),
        movieId: movieId,
      ),
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text(context.str.movieDetailTitle),
          actions: [
            IconButton(
              icon: Icon(
                viewModel.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: viewModel.isFavorite ? Colors.red : null,
              ),
              onPressed: viewModel.toggleFavorite,
            ),
          ],
        ),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewModel.hasError
                ? Center(
                    child: Text(viewModel.error ?? context.str.anErrorOccurred))
                : viewModel.movie == null
                    ? Center(child: Text(context.str.movieNotFound))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (viewModel.movie?.posterPath?.isNotEmpty == true)
                              CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w500${viewModel.movie?.posterPath}',
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: double.infinity,
                                  height: 300,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.movie, size: 64, color: Colors.grey),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: double.infinity,
                                  height: 300,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error, size: 64, color: Colors.red),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.movie?.title ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    context.str.releaseDate(
                                        viewModel.movie?.releaseDate ?? ''),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    context.str.rating(viewModel
                                            .movie?.voteAverage
                                            ?.toString() ??
                                        '0'),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    viewModel.movie?.overview ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
