import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:review_repository/review_repository.dart'; 

class ReviewsScreen extends StatefulWidget {
  final String movieId;
  ReviewsScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Review> reviews = []; // List to store fetched reviews
  bool isLoading = true; // Flag to track loading state
  TextEditingController reviewController = TextEditingController(); // Controller for review text field

  @override
  void initState() {
    super.initState();
    fetchReviews(); // Fetch reviews when the screen initializes
  }

  // Method to fetch reviews from FirebaseReviewRepo
  void fetchReviews() async {
    try {
      List<Review> fetchedReviews =
          await FirebaseReviewRepo().getReviewByMovieId(widget.movieId);
      fetchedReviews.sort((a, b) => b.time.compareTo(a.time));
      setState(() {
        reviews = fetchedReviews;
        isLoading = false; // Set loading flag to false after fetching
      });
    } catch (e) {
      // Handle error
      print('Error fetching reviews: $e');
    }
  }

  // Method to submit a review
  void submitReview() async {
    final user = context.read<AuthenticationBloc>().state.user!;
    String userId = user.userId; // Replace with actual user ID
    String userName = user.name; // Replace with actual user name
    String text = reviewController.text.trim();

    if (text.isNotEmpty) {
      try {
        await FirebaseReviewRepo().addReview(
          widget.movieId,
          userId,
          userName,
          text,
          DateTime.now(),
        );
        // Clear the text field and fetch reviews again
        reviewController.clear();
        fetchReviews();
      } catch (e) {
        // Handle error
        print('Error adding review: $e');
      }
    }
  }

  String _formatDate(DateTime dateTime) {
  // Добавляем ведущие нули перед днем и месяцем
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  return '$day.$month.${dateTime.year}'; // Формат даты: dd.MM.yyyy
}

String _formatTime(DateTime dateTime) {
  // Добавляем ведущие нули перед часом и минутой
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute'; // Формат времени: HH:mm
}


  Widget buildReviewCard(Review review) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_formatDate(review.time)} ${_formatTime(review.time)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.text,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Reviews'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: (){
              
              submitReview();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
                : reviews.isEmpty
                    ? const Center(child: Text('No reviews available')) // Show message if no reviews
                    : ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return buildReviewCard(reviews[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
