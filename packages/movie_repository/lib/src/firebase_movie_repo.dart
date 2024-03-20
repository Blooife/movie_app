import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_repository/movie_repository.dart';
import 'package:movie_repository/src/entities/entities.dart';

class FirebaseMovieRepo implements MovieRepo {
  final movieCollection = FirebaseFirestore.instance.collection('movies');


  @override
  Future<List<Movie>> getMovies() async {
    try {
      return await movieCollection
        .get()
        .then((value) => value.docs.map((e) => 
          Movie.fromEntity(MovieEntity.fromDocument(e.data()))
        ).toList());
        
        
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
Future<List<Movie>> getMoviesByIds(List<String> movieIds) async {
  try {
    final List<Movie> movies = [];

    // Iterate through each movieId and fetch movie details
    for (String movieId in movieIds) {
      final movieSnapshot = await movieCollection.doc(movieId).get();
      if (movieSnapshot.exists) {
        movies.add(Movie.fromEntity(MovieEntity.fromDocument(movieSnapshot.data()!)));
      }
    }
    return movies;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}


  @override
  Future<void> addRate(String movieId, String userId, int rate) async {
  try {
    // Проверяем, существует ли уже отметка для данного пользователя и фильма
    final movieSnapshot = await movieCollection.doc(movieId).get();
    if (movieSnapshot.exists) {
      final movieData = movieSnapshot.data();
      final List<Map<String, dynamic>> rates = List<Map<String, dynamic>>.from(movieData?['rates'] ?? []);

      // Ищем отметку данного пользователя
      int userRateIndex = -1;
      for (int i = 0; i < rates.length; i++) {
        if (rates[i]['userId'] == userId) {
          userRateIndex = i;
          break;
        }
      }

      // Если отметка уже существует, обновляем её
      if (userRateIndex != -1) {
        rates[userRateIndex]['rate'] = rate;
      } else {
        // Иначе добавляем новую отметку
        rates.add({'userId': userId, 'rate': rate});
      }

      // Обновляем отметки в Firestore
      await movieCollection.doc(movieId).update({'rates': rates});
    }
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

}