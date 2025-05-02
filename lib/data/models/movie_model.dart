import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  MovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.voteAverage,
    required super.overview,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      overview: json['overview'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'vote_average': voteAverage,
      'overview': overview,
    };
  }
} 