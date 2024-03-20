class MyUserEntity {
  String userId;
  String email;
  String name;
  String phoneNumber;
  int age;
  bool gender;
  String surname;
  DateTime birthDate;
  String country;
  String city;
  String about;
  List<String> favorites;
  String favCountry;
  String favGenre;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.surname,
    required this.birthDate,
    required this.country,
    required this.city,
    required this.about,
    required this.favorites,
    required this.favCountry,
    required this.favGenre,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender,
      'surname': surname,
      'birthDate': birthDate,
      'country': country,
      'city': city,
      'about': about,
      'favorites': favorites,
      'favCountry': favCountry,
      'favGenre': favGenre,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'], 
      email: doc['email'], 
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      age: doc['age'],
      gender: doc['gender'],
      surname: doc['surname'],
      birthDate: doc['birthDate'] != null ? doc['birthDate'].toDate() : null,
      country: doc['country'],
      city: doc['city'],
      about: doc['about'],
      favorites: List<String>.from(doc['favorites'] ?? []),
      favCountry: doc['favCountry'],
      favGenre: doc['favGenre'],
    );
  }
}