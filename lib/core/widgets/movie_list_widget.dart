import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';
import '../config/app_config.dart';

class MovieList extends StatefulWidget {
  final List<MovieEntity> movies;
  final Function(MovieEntity) onMovieTap;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasMorePages;

  const MovieList({
    Key? key,
    required this.movies,
    required this.onMovieTap,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasMorePages,
  }) : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final ScrollController _scrollController = ScrollController();
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _precacheImages();
      _isFirstLoad = false;
    }
  }

  void _onScroll() {
    if (!widget.isLoadingMore && widget.hasMorePages) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll * 0.9) {
        widget.onLoadMore();
      }
    }
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${AppConfig.imageBaseUrl}/w185$path';
  }

  Future<void> _precacheImages() async {
    for (var movie in widget.movies) {
      final imageUrl = _getImageUrl(movie.posterPath);
      if (imageUrl.isNotEmpty) {
        precacheImage(NetworkImage(imageUrl), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.movies.length + (widget.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.movies.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final movie = widget.movies[index];
        final imageUrl = _getImageUrl(movie.posterPath);
        return ListTile(
          leading: imageUrl.isNotEmpty
              ? Hero(
                  tag: 'movie_${movie.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 50,
                          height: 75,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 75,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            size: 24,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container(
                  width: 50,
                  height: 75,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.movie_outlined,
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
          title: Text(movie.title),
          subtitle: Text(
            movie.overview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => widget.onMovieTap(movie),
        );
      },
    );
  }
} 