part of 'birthday_bloc.dart';

abstract class BirthdayState extends Equatable {
  const BirthdayState();

  @override
  List<Object> get props => [];
}

class BirthdayInitial extends BirthdayState {}

class UnacceptableAge extends BirthdayState {}

class AcceptableAge extends BirthdayState {}
