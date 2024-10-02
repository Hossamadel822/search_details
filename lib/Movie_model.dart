class Movie {
  final int id; // Add movieId
  final String? title;
  final String? posterPath;
  final String? releaseDate;
  final String? overview;

  Movie({
    required this.id, // Initialize id
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'], // Assign movieId
      title: json['title'] as String?,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      overview: json['overview'] as String?,
    );
  }
}
