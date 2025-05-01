class MovieDetailEntity {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final int runtime;
  final String tagline;

  MovieDetailEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    required this.runtime,
    required this.tagline,
  });

  factory MovieDetailEntity.fromJson(Map<String, dynamic> json) {
    return MovieDetailEntity(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: json['vote_average'].toDouble(),
      releaseDate: json['release_date'],
      genres: (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList(),
      runtime: json['runtime'] ?? 0,
      tagline: json['tagline'] ?? '',
    );
  }
} 