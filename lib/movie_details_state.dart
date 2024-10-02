import 'Movie_model.dart';


abstract class MovieDetailsState  {
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final Movie movie;

  MovieDetailsLoaded(this.movie);

  @override
  List<Object?> get props => [movie];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  MovieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
