
import 'package:fenix_mobile_example/core/extensions/error_handling_extension.dart';
import 'package:fenix_mobile_example/core/widgets/movie_list_widget.dart';
import 'package:fenix_mobile_example/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/search_bar_widget.dart';
import '../../movie_detail/view/movie_detail_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeViewmodel>().getTopRatedMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
      ),
      body: Column(
        children: [
          const MovieSearchBar(),
          Expanded(
            child: Consumer<HomeViewmodel>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.hasError) {
                  context.showErrorDialog(
                    failure: provider.failure!,
                    onRetry: () => provider.getTopRatedMovies(),
                  );
                  return const SizedBox();
                }

                final movies = provider.movies;
                if (movies.isEmpty) {
                  return const Center(child: Text('No movies found'));
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
                  onLoadMore: () {
                    if (provider.searchQuery.isEmpty) {
                      provider.getTopRatedMovies(loadMore: true);
                    } else {
                      provider.searchMovies(provider.searchQuery, loadMore: true);
                    }
                  },
                  isLoadingMore: provider.isLoadingMore,
                  hasMorePages: provider.hasMorePages,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}