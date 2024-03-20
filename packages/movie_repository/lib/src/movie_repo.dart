import 'models/models.dart';

abstract class MovieRepo {
    Future<List<Movie>> getMovies();
    Future<List<Movie>> getMoviesByIds(List<String> movieIds);
    Future<void> addRate(String movieId, String userId, int rate);
}