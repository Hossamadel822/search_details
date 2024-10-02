
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:search/searchViewModel.dart';


import 'movie_State.dart';
import 'movie_detail_screen.dart';

class Searchsceentab extends StatelessWidget {
  static const String routeName = 'search';

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchControllerText = TextEditingController();

    return BlocProvider<Searchtabviewmodel>(
      create: (context) => Searchtabviewmodel(),
      child: BlocBuilder<Searchtabviewmodel, Searchstates>(
        builder: (context, state) {
          final viewmodel = BlocProvider.of<Searchtabviewmodel>(context);

          return Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  TextField(
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                    controller: searchControllerText,
                    onChanged: (value) {
                      viewmodel.searchMovie(query: value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                  ),

                  // Display results or loading/error indicators
                  SizedBox(height: 20),
                  if (searchControllerText.text.isEmpty &&
                      state is searchSuccessState &&
                      viewmodel.searchlist.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_movies_sharp,
                              size: 200, color: Colors.white38),
                          Text('Nothing Found',
                              style: TextStyle(color: Colors.white60)),
                        ],
                      ),
                    )
                  else if (state is searchLoadingState)
                    Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    )
                  else if (state is searchSuccessState)
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewmodel.searchlist.length,
                          itemBuilder: (context, index) {
                            final movie = viewmodel.searchlist[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movieId: movie.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(bottom: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          '${'https://image.tmdb.org/t/p/w500/'}${movie.posterPath}',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                              Center(
                                                  child: Icon(Icons.error,
                                                      color: Colors.red)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    // Movie details with improved formatting
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            movie.releaseDate ?? '',
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else if (state is searchErrorState)
                        Center(
                          child: Text(
                            'Error',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}