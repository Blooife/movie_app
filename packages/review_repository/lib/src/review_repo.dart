import 'models/models.dart';

abstract class ReviewRepo {
    Future<List<Review>> getReviewByMovieId(String movieId);
     Future<void> addReview(String movieId, String userId, String userName,
      String text, DateTime time);
}