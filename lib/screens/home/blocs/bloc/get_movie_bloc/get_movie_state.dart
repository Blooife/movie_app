part of 'get_movie_bloc.dart';

sealed class GetMovieState extends Equatable {
  const GetMovieState();
  
  @override
  List<Object> get props => [];
}
final class GetMovieInitial extends GetMovieState {}

final class GetMovieFailure extends GetMovieState {}
final class GetMovieLoading extends GetMovieState {}
final class GetMovieSuccess extends GetMovieState {
  final List<Movie> movies;

  const GetMovieSuccess(this.movies);

  @override
  List<Object> get props => [movies];
}



