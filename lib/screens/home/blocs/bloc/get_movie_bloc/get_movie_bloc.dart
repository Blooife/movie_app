import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_repository/movie_repository.dart';

part 'get_movie_event.dart';
part 'get_movie_state.dart';


class GetMovieBloc extends Bloc<GetMovieEvent, GetMovieState> {
  final MovieRepo _movieRepo;

  GetMovieBloc(this._movieRepo) : super(GetMovieInitial()) {
    on<GetMovie>((event, emit) async {
      emit(GetMovieLoading());
      try {
        List<Movie> movies = await _movieRepo.getMovies();
        emit(GetMovieSuccess(movies));
      } catch (e) {
        emit(GetMovieFailure());
      }
    });

    on<AddRate>((event, emit) async{
      try {
        _movieRepo.addRate(event.movieId, event.myUserId, event.rate);
        }
       catch (e) {
        
      }
    });
    
  }
}