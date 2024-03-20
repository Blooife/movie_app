import 'models/models.dart';

abstract class UserRepository {
  Stream<MyUser?> get user;

  Future<void> deleteUserData(String myUserId);

	Future<MyUser> signUp(MyUser myUser, String password);

	Future<void> setUserData(MyUser user);

	Future<void> signIn(String email, String password);

	Future<void> logOut();

  Future<MyUser> getMyUser(String myUserId);

  Future<void> addToFavorites(String myUserId, String movieId);

  Future<void> deleteFromFavorites(String myUserId, String movieId);

}