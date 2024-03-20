part of 'get_movie_bloc.dart';

sealed class GetMovieEvent extends Equatable {
  const GetMovieEvent();

  @override
  List<Object> get props => [];
}

class GetMovie extends GetMovieEvent{}

class AddRate extends GetMovieEvent{
  final String myUserId;
  final String movieId;
  final int rate;

  const AddRate(this.myUserId, this.movieId, this.rate);

  @override
  List<Object> get props => [myUserId, movieId, rate];
}