part of 'log_in_bloc.dart';

abstract class LogInEvent extends Equatable {
  const LogInEvent();

  @override
  List<Object> get props => [];
}

class CheckUserEvent extends LogInEvent {
  const CheckUserEvent({required this.usernameOrEmail, required this.password});
  final String usernameOrEmail;
  final String password;
}

class CheckInputFieldsValid extends LogInEvent {
  const CheckInputFieldsValid(
      {required this.usernameOrEmail, required this.password});
  final String usernameOrEmail;
  final String password;
}

class CheckEnoughSymbols extends LogInEvent {
  const CheckEnoughSymbols(
      {required this.usernameOrEmail, required this.password});
  final String usernameOrEmail;
  final String password;
}

class CheckConnection extends LogInEvent {}

class Loading extends LogInEvent {}
