part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class AddUserEvent extends UserEvent {
  const AddUserEvent({required this.user});
  final UserModel user;
}

class DeleteUserEvent extends UserEvent {}

class LoadUsersEvent extends UserEvent {
  const LoadUsersEvent();
}

class CheckSessionEvent extends UserEvent {}

class CreateSessionEvent extends UserEvent {}

class DestroySessionEvent extends UserEvent {}

class CheckSession extends UserEvent {}

class CreateSession extends UserEvent {}

class DestroySession extends UserEvent {}

class GetDeviceCurrentCode extends UserEvent {}
