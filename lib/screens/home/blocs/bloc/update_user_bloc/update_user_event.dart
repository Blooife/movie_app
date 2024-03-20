part of 'update_user_bloc.dart';

sealed class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUser extends UpdateUserEvent {
  final MyUser user;

  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteUser extends UpdateUserEvent {
  final String myUserId;

  const DeleteUser(this.myUserId);

  @override
  List<Object> get props => [myUserId];
}
