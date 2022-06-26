part of 'username_bloc.dart';

abstract class UsernameState extends Equatable {
  const UsernameState();

  @override
  List<Object> get props => [];
}

class UsernameInitial extends UsernameState {}

class NotEnoughSymbols extends UsernameState {}

class AviableUsername extends UsernameState {}

class UsedUsername extends UsernameState {}

class Checking extends UsernameState {}
