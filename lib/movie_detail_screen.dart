import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ApiDetailsManager.dart';
import 'movie_details_cubit.dart';
import 'movie_details_state.dart';


class MovieDetailScreen extends StatelessWidget {
  final int movieId; 

  MovieDetailScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsCubit(MovieApiService())
        ..fetchMovieDetails(movieId), // Fetch movie details when screen loads
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movie Details'),
        ),
        body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieDetailsLoaded) {
              final movie = state.movie;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      movie.releaseDate ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Movie poster image
                    Center(
                      child: Image.network(
                        '${'https://image.tmdb.org/t/p/w500/'}${movie.posterPath}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error, size: 100, color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Movie overview
                    Text(
                      movie.overview ?? 'No description available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            } else if (state is MovieDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
