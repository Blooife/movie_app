import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:review_repository/review_repository.dart';


class FirebaseReviewRepo implements ReviewRepo {
  final reviewCollection = FirebaseFirestore.instance.collection('reviews');


  @override
  Future<List<Review>> getReviewByMovieId(String movieId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await reviewCollection
        .where('movieId', isEqualTo: movieId)
        .get();

    List<Review> reviews = [];
    snapshot.docs.forEach((doc) {
      reviews.add(Review.fromEntity(ReviewEntity.fromDocument(doc.data())));
    });
    return reviews;
  }

  @override
  Future<void> addReview(String movieId, String userId, String userName,
      String text, DateTime time) async {
    await reviewCollection.add({
      'movieId': movieId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'time': time,
    });
  }
}

