import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/features/home/viewmodel/home_viewmodel.dart';

class MovieSearchBar extends StatelessWidget {
  const MovieSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search movies...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          context.read<HomeViewModel>().searchMovies(value);
        },
      ),
    );
  }
} 