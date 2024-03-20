class ReviewEntity {
  String movieId;
  String userId;
  String userName;
  String text;
  DateTime time;


  ReviewEntity({
    required this.movieId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.time, 
  });

  Map<String, Object?> toDocument() {
    return {
      'movieId': movieId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'time': time,
    };
  }

  static ReviewEntity fromDocument(Map<String, dynamic> doc) {
    return ReviewEntity(
      movieId: doc['movieId'],
      userId: doc['userId'],
      userName: doc['userName'],
      text:doc['text'],
      time:doc['time'] != null ? doc['time'].toDate() : null,
    );
  }
}