part of 'update_user_bloc.dart';

sealed class UpdateUserState extends Equatable {
  const UpdateUserState();
  
  @override
  List<Object> get props => [];
}

final class UpdateUserInitial extends UpdateUserState {}

final class UpdateUserSuccess extends UpdateUserState {}
final class UpdateUserLoading extends UpdateUserState {}
final class UpdateUserFailure extends UpdateUserState {}

final class DeleteUserSuccess extends UpdateUserState {}
final class DeleteUserLoading extends UpdateUserState {}
final class DeleteUserFailure extends UpdateUserState {}
