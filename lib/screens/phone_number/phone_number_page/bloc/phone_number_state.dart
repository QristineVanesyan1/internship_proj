part of 'phone_number_bloc.dart';

abstract class PhoneNumberState extends Equatable {
  const PhoneNumberState();

  @override
  List<Object> get props => [];
}

class PhoneNumberInitial extends PhoneNumberState {}

class ValidPhoneNumber extends PhoneNumberState {
  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class InvalidPhoneNumber extends PhoneNumberState {
  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class UsedPhoneNumber extends PhoneNumberState {}

class CheckingPhoneNumber extends PhoneNumberState {}

class CorrectPhoneNumber extends PhoneNumberState {}

class CheckingUsedPhoneEvent extends PhoneNumberState {}

class ValidEmail extends PhoneNumberState {
  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class InvalidEmail extends PhoneNumberState {
  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class UsedEmail extends PhoneNumberState {}

class CheckingEmail extends PhoneNumberState {}

class CheckingUsedEmailEvent extends PhoneNumberState {}

class CorrectEmail extends PhoneNumberState {}
