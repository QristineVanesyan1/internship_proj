part of 'password_bloc.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];
}

class PasswordInitial extends PasswordState {}

class AllowablePassword extends PasswordState {}

class UnallowablePassword extends PasswordState {}

class NotEnoughSymbols extends PasswordState {}
class EmptyPassword extends PasswordState {}