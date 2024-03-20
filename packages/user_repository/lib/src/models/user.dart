import '../entities/entities.dart';

class MyUser {
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

  MyUser({
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

  static final empty = MyUser(
    userId: '', 
    email: '', 
    name: '',
    phoneNumber: '',
    age: 0,
    gender: true,
    surname: '',
    birthDate: DateTime.now(),
    country: '',
    city: '',
    about: '',
    favorites: List.empty(growable: true),
    favCountry: 'None',
    favGenre: 'None',

  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId, 
      email: email, 
      name: name,
      phoneNumber: phoneNumber,
      age: age,
      gender: gender,
      surname: surname,
      birthDate: birthDate,
      country: country,
      city: city,
      about: about,
      favorites: favorites,
      favCountry: favCountry,
      favGenre: favGenre,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId, 
      email: entity.email, 
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      age: entity.age,
      gender: entity.gender,
      surname: entity.surname,
      birthDate: entity.birthDate,
      country: entity.country,
      city: entity.city,
      about: entity.about,
      favorites: entity.favorites,
      favCountry: entity.favCountry,
      favGenre: entity.favGenre,
    );
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $phoneNumber, $age, $gender, $surname, $birthDate, $country, $city, $about, $favorites';
  }
}
