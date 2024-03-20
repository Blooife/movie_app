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
  List<Review> reviews = []; 
  bool isLoading = true; 
  TextEditingController reviewController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    fetchReviews(); 
  }


  void fetchReviews() async {
    try {
      List<Review> fetchedReviews =
          await FirebaseReviewRepo().getReviewByMovieId(widget.movieId);
      fetchedReviews.sort((a, b) => b.time.compareTo(a.time));
      setState(() {
        reviews = fetchedReviews;
        isLoading = false; 
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }


  void submitReview() async {
    final user = context.read<AuthenticationBloc>().state.user!;
    String userId = user.userId; 
    String userName = user.name; 
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
        reviewController.clear();
        fetchReviews();
      } catch (e) {
        // Handle error
        print('Error adding review: $e');
      }
    }
  }

  String _formatDate(DateTime dateTime) {
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  return '$day.$month.${dateTime.year}'; 
}

String _formatTime(DateTime dateTime) {
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute'; 
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
                ? const Center(child: CircularProgressIndicator()) 
                : reviews.isEmpty
                    ? const Center(child: Text('No reviews available')) 
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
