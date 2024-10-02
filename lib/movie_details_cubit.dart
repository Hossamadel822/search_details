import 'package:bloc/bloc.dart';
import 'ApiDetailsManager.dart';
import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final MovieApiService apiService;

  MovieDetailsCubit(this.apiService) : super(MovieDetailsInitial());

  Future<void> fetchMovieDetails(int movieId) async {
    try {
      emit(MovieDetailsLoading());
      final movie = await apiService.fetchMovieDetails(movieId);
      emit(MovieDetailsLoaded(movie));
    } catch (e) {
      emit(MovieDetailsError('Failed to load movie details'));
    }
  }
}
