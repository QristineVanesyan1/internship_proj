part of 'log_in_bloc.dart';

class LogInState extends Equatable {
  const LogInState();

  @override
  List<Object> get props => [];
}

class LogInInitial extends LogInState {}

class UserNotFoundErrorState extends LogInState {}

class SuccessfullyLoggedIn extends LogInState {
  const SuccessfullyLoggedIn({required this.userToken});
  final UserModel userToken;
}

class FailedLoggedIn extends LogInState {}

class LoadingState extends LogInState {}

class Valid extends LogInState {}

class Invalid extends LogInState {}

class Connected extends LogInState {}

class ConnectionFailed extends LogInState {}
