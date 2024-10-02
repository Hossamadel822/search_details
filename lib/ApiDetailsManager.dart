import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Movie_model.dart';

class MovieApiService {
  final String apiKey = '34e003d4b9d026a15d3cc1a2ce2c3fd2';
  final String baseUrl = 'api.themoviedb.org';

  // Fetch movie details by movie ID
  Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> movieData = jsonDecode(response.body);
      return Movie.fromJson(movieData);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  // Search for movies by query
  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((movieData) => Movie.fromJson(movieData)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
