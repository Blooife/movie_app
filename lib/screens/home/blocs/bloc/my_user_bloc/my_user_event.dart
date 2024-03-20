part of 'my_user_bloc.dart';

abstract class MyUserEvent extends Equatable {
  const MyUserEvent();

  @override
  List<Object> get props => [];
}

class GetMyUser extends MyUserEvent {
	final String myUserId;

	const GetMyUser({required this.myUserId});

	@override
  List<Object> get props => [myUserId];
}

class AddFavorite extends MyUserEvent{
  final String myUserId;
  final String movieId;

  const AddFavorite(this.myUserId, this.movieId);

  @override
  List<Object> get props => [myUserId, movieId];
}
