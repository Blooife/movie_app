class MovieEntity {
  String movieId;
  List<String> picture;
  String name;
  int year;
  String country;
  String genre;
  String description;
  List<Map<String, dynamic>>? rates;


  MovieEntity({
    required this.movieId,
    required this.picture,
    required this.name,
    required this.year,
    required this.country,
    required this.genre,
    required this.description,   
    required this.rates,  
  });

  Map<String, Object?> toDocument() {
    return {
      'movieId': movieId,
      'picture': picture,
      'name': name,
      'year': year,
      'country': country,
      'genre':genre,
      'description': description,
      'rates': rates!.map((rateMap) => {'userId': rateMap['userId'], 'rate': rateMap['rate']}).toList(),
    };
  }

  static MovieEntity fromDocument(Map<String, dynamic> doc) {
    return MovieEntity(
      movieId: doc['movieId'],
      picture: List<String>.from(doc['picture'] ?? []),
      name: doc['name'],
      year:doc['year'],
      country:doc['country'],
      genre:doc['genre'],
      description: doc['description'],
      rates: List<Map<String, dynamic>>.from(doc['rates'] ?? []).map((rateMap) => {
        'userId': rateMap['userId'],
        'rate': rateMap['rate'],
      }).toList(),
    );
  }
}