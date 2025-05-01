import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../widgets/movie_list_widget.dart';
import '../widgets/search_bar_widget.dart';
import 'movie_detail_screen.dart';
import '../../core/extensions/error_handling_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().getTopRatedMovies();
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
            child: Consumer<HomeProvider>(
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
                        builder: (context) => MovieDetailScreen(movie: movie),
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