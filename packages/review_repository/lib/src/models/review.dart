import '../entities/entities.dart';

class Review {
   String movieId;
  String userId;
  String userName;
  String text;
  DateTime time;


  Review({
    required this.movieId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.time,
  });

  ReviewEntity toEntity() {
    return ReviewEntity(
      movieId: movieId,
      userId: userId,
      userName: userName,
      text: text,
      time: time,
    );
  }

  static Review fromEntity(ReviewEntity entity) {
    return Review(
      movieId: entity.movieId,
      userId: entity.userId,
      userName: entity.userName,
      text: entity.text,
      time: entity.time,
    );
  }
}