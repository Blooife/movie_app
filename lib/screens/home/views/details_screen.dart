import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/screens/home/views/reviews_screen.dart';
import 'package:movie_repository/movie_repository.dart';

class DetailsScreen extends StatefulWidget {
  Movie movie;
  DetailsScreen(this.movie, {Key? key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final PageController _pageController = PageController();
  FirebaseMovieRepo movieRepo = FirebaseMovieRepo();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
    //updateMovie();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentPage = _pageController.page!.round();
    });
  }


  double calculateAverageRating(List<Map<String, dynamic>>? ratings) {
      if (ratings == null || ratings.isEmpty) {
        return 0.0;
      }

      double sum = 0.0;
      for (var rating in ratings) {
        sum += rating['rate'];
      }
      return sum / ratings.length;
    }

    int getNumberOfRatings(List<Map<String, dynamic>>? ratings) {
      return ratings?.length ?? 0;
    }

    void _addrate(String movieId, String userId, int rate) async {
    await movieRepo.addRate(movieId, userId, rate);
  }

  String getRatingForCurrentUser(List<Map<String, dynamic>>? ratings) {
    final userId = context.read<AuthenticationBloc>().state.user!.userId;    
    if (ratings == null || ratings.isEmpty) {
      return ''; // Return 0 if no ratings or empty list
    }

    for (var rating in ratings) {
      if (rating['userId'] == userId) {
        return rating['rate'].toString(); // Return the user's rating if found
      }
    }

    return ''; // Return 0 if the user's rating is not found
}

  void _showRateModal(BuildContext context, String userId) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 150, // Высота полосы с оценками
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(                      
                      children: List.generate(5, (index) {
                        int rating = index + 1;
                        return InkWell(
                          onTap: () async {                    
                            await movieRepo.addRate(widget.movie.movieId, userId, rating);                            
                            Navigator.pop(context); 
                            updateMovie(); // Ожидаем обновления данных и только потом обновляем UI
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              rating.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Расстояние между рядами оценок
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        int rating = index + 6; // Начинаем со 6, чтобы продолжить оценки с 6 до 10
                        return InkWell(
                          onTap: () async {    
                            await movieRepo.addRate(widget.movie.movieId, userId, rating);
                            Navigator.pop(context); 
                            updateMovie(); // Ожидаем обновления данных и только потом обновляем UI
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              rating.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void updateMovie() async {
    List<String> ids = [widget.movie.movieId];
      List<Movie> movies = await movieRepo.getMoviesByIds(ids);
      if (mounted) {
    setState(() {    
      widget.movie = movies[0];
    });}
  }

  Future<List<Movie>> getMovies() async {
      List<Movie> movies = await movieRepo.getMovies();
      return movies;
  }

  @override
Widget build(BuildContext context) {
  List<String> genres = widget.movie.genre.split('/');
  List<String> countries = widget.movie.country.split('/');
  double averageRating = calculateAverageRating(widget.movie.rates);
  int numberOfRatings = getNumberOfRatings(widget.movie.rates);
  //updateMovie();
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(widget.movie.name),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, getMovies());
        },
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width - 40,
              child: Stack(
                children: [
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.movie.picture.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.movie.picture[index],
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_currentPage + 1} / ${widget.movie.picture.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' (${numberOfRatings} ratings)',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () {
                    final userId = context.read<AuthenticationBloc>().state.user!.userId;
                    _showRateModal(context, userId);
                  },
                ),
                if (widget.movie.rates != null && widget.movie.rates!.isNotEmpty) ...[
                  Text(
                    'Your Rating: ${getRatingForCurrentUser(widget.movie.rates)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${widget.movie.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Year: ${widget.movie.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Countries: ${countries.join(", ")}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Genres: ${genres.join(", ")}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Description:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.movie.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(              
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewsScreen(movieId: widget.movie.movieId),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Reviews',
                ),
              ),
            ),

          ],
        ),
      ),
    ),
  );
}
}