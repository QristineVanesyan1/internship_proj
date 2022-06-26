part of 'password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

class CheckPassword extends PasswordEvent {
  const CheckPassword({required this.password});
  final String password;
}
