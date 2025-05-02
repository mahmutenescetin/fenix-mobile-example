class MovieDetailEntity {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? releaseDate;
  final double voteAverage;
  final List<String> genres;
  final int runtime;
  final String tagline;

  MovieDetailEntity({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.releaseDate,
    required this.voteAverage,
    required this.genres,
    required this.runtime,
    required this.tagline,
  });

  factory MovieDetailEntity.fromJson(Map<String, dynamic> json) {
    return MovieDetailEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      genres: (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList(),
      runtime: json['runtime'] ?? 0,
      tagline: json['tagline'] ?? '',
    );
  }
} 