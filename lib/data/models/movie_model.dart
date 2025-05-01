import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  MovieModel({
    required int id,
    required String title,
    required String posterPath,
    required double voteAverage,
    required String overview,
  }) : super(
          id: id,
          title: title,
          posterPath: posterPath,
          voteAverage: voteAverage,
          overview: overview,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      overview: json['overview'] ?? '',
    );
  }
} 