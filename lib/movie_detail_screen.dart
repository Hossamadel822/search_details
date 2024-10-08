import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:search/movie_details_cubit.dart';

import 'movie_details_state.dart';

class MovieDetailScreen extends StatefulWidget {
  static const String routeName = 'movie_details';
  final int movieId;
  MovieDetailScreen({required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailScreen> {
  MovieDetailsViewModel cubit = MovieDetailsViewModel();
  bool isExpanded = false;
  bool isFavorite = false;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return cubit
          ..getAllDetails(widget.movieId)
          ..getAllSimilarDetails(widget.movieId);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black54,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: BlocBuilder<MovieDetailsViewModel, MovieDetailsStates>(
              builder: (context, state) {
                if (state is MovieDetailsLoadingState ||
                    state is MovieDetailsSuccessState) {
                  final movieTitle = state is MovieDetailsSuccessState
                      ? state.details.title
                      : "Loading...";
                  return Row(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          movieTitle ?? "No Title Available",
                          style:
                          TextStyle(color: Colors.white, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(); // Empty container if title is not available
                }
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<MovieDetailsViewModel, MovieDetailsStates>(
                  builder: (context, state) {
                    if (state is MovieDetailsLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is MovieDetailsSuccessState) {
                      final movie = state.details;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Image.network(
                                  movie.posterPath != null
                                      ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                      : 'https://via.placeholder.com/500x250?text=No+Image',
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                        child: Text('Image failed to load'));
                                  },
                                ),
                                Positioned(
                                  left: 176,
                                  bottom: 78,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: Icon(Icons.play_arrow, size: 30),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title ?? "No Title Available",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${movie.releaseDate ?? "No release date"}, ${movie.runtime != null ? "${movie.runtime} mins" : "No runtime"}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          movie.posterPath != null
                                              ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                              : 'https://via.placeholder.com/100x150?text=No+Image',
                                          width: 129,
                                          height: 220,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Text(
                                                    'Image failed to load'));
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 4),
                                            Wrap(
                                              spacing: 6,
                                              runSpacing: 6,
                                              children:
                                              movie.genres!.map((genre) {
                                                return Chip(
                                                  label: Text(genre.name!),
                                                  backgroundColor:
                                                  Colors.grey.shade400,
                                                );
                                              }).toList(),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              movie.overview ??
                                                  "No description available",
                                              maxLines: isExpanded ? null : 2,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  color: Colors.grey.shade300,
                                                  fontSize: 14),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isExpanded = !isExpanded;
                                                });
                                              },
                                              child: Text(
                                                isExpanded
                                                    ? "show less"
                                                    : "show more",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                SizedBox(width: 5),
                                                Text(
                                                  movie.voteAverage
                                                      ?.toString() ??
                                                      "No Rating",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Divider(color: Colors.grey.shade800),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Placeholder for the error message if details aren't available
                      return Container(
                        height: 250, // Adjust height as needed to match the size of the details section
                        child: Center(
                            child: Text("Unexpected state occurred",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))),
                      );
                    }
                  },
                ),
              ),
              BlocBuilder<MovieDetailsViewModel, MovieDetailsStates>(
                builder: (context, state) {
                  if (state is MovieSimilarDetailsLoadingState) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is MovieSimilarDetailsSuccessState) {
                    final similarDetails = state.similarDetails.results;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'More Like This',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarDetails!.length,
                            itemBuilder: (context, index) {
                              final similarDetail = similarDetails[index];
                              return Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      similarDetail.posterPath != null
                                          ? 'https://image.tmdb.org/t/p/w500${similarDetail.posterPath}'
                                          : 'https://via.placeholder.com/120x160?text=No+Image',
                                      width: 120,
                                      height: 160,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                            child:
                                            Text('Image failed to load'));
                                      },
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          similarDetail.voteAverage
                                              ?.toString() ??
                                              "No Rating",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  } else if (state is MovieSimilarDetailsErrorState) {
                    return Center(child: Text(state.errorMsg));
                  } else {
                    return Center(child: Text("Unexpected state occurred"));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}