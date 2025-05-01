import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../../core/extensions/error_handling_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final provider = context.read<HomeProvider>();
    await provider.getTopRatedMovies();
    
    if (provider.hasError && mounted) {
      context.showErrorDialog(
        failure: provider.failure!,
        onRetry: _loadMovies,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmler'),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: provider.movies.length,
            itemBuilder: (context, index) {
              final movie = provider.movies[index];
              return ListTile(
                title: Text(movie.title),
                subtitle: Text(movie.overview),
              );
            },
          );
        },
      ),
    );
  }
} 