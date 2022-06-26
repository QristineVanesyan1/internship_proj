part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class LoadedUsersState extends UserState {
  const LoadedUsersState({required this.loadedUsers});
  final List<UserModel> loadedUsers;
  @override
  List<Object> get props => [];
}

class UserAddedState extends UserState {
  const UserAddedState({required this.user});
  final UserModel user;
  @override
  List<Object> get props => [const Uuid().v4()];
}

class UserDeletedState extends UserState {}

class UserNotInSessionState extends UserState {}

class LoadingState extends UserState {}

class SessionDestroyedState extends UserState {}

class SessionCreatedState extends UserState {}

class CurrentCodeLoadedState extends UserState {
  const CurrentCodeLoadedState({required this.loadedCountryCode});
  final CountryCodeModel loadedCountryCode;
}

class UserInSessionState extends UserState {
  const UserInSessionState({required this.user});
  final UserModel user;
  @override
  List<Object> get props => [];
}

class UserNotInSession extends UserState {}

class Loading extends UserState {}

class SessionDestroyed extends UserState {}

class SessionCreated extends UserState {}

class UserInSession extends UserState {
  const UserInSession({required this.user});
  final UserModel user;
  @override
  List<Object> get props => [];
}
