import '../entities/entities.dart';

class Movie {
   String movieId;
  List<String> picture;
  String name;
  int year;
  String country;
  String genre;
  String description;
  List<Map<String, dynamic>>? rates;

  bool? isFav = false;

  Movie({
    required this.movieId,
    required this.picture,
    required this.name,
    required this.year,
    required this.country,
    required this.genre,
    required this.description,
    required this.rates,
  });

  MovieEntity toEntity() {
    return MovieEntity(
      movieId: movieId,
      picture: picture,
      name: name,
      year: year,
      country: country,
      genre:genre,
      description: description,
      rates: rates,
    );
  }

  static Movie fromEntity(MovieEntity entity) {
    return Movie(
      movieId: entity.movieId,
      picture: entity.picture,
      name: entity.name,
      year: entity.year,
      country: entity.country,
      genre: entity.genre,
      description: entity.description,
      rates: entity.rates,
    );
  }
}