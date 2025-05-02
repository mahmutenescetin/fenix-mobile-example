class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
  });

  factory MovieEntity.fromJson(Map<String, dynamic> json) {
    return MovieEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
} 