part of 'edit_bloc.dart';

abstract class EditState extends Equatable {
  const EditState();

  @override
  List<Object> get props => [];
}

class EditInitial extends EditState {}

class UserDataUpdatedState extends EditState {
  const UserDataUpdatedState({required this.user});
  final UserModel user;
}

class Updating extends EditState {}

class InvalidFirstname extends EditState {
  const InvalidFirstname({this.errorMsg});
  final String? errorMsg;

  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class InvalidLastname extends EditState {
  const InvalidLastname({required this.errorMsg});
  final String errorMsg;

  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class Loading extends EditState {
  const Loading();

  @override
  List<Object> get props => [];
}

class InvalidUsername extends EditState {
  const InvalidUsername({required this.errorMsg});
  final String errorMsg;

  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class InvalidEmailState extends EditState {
  const InvalidEmailState({required this.errorMsg});
  final String errorMsg;

  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class InvalidBirthdate extends EditState {
  const InvalidBirthdate({required this.errorMsg});
  final String errorMsg;

  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class InvalidPassword extends EditState {
  const InvalidPassword({required this.errorMsg});
  final String errorMsg;

  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class InvalidPhoneNumberState extends EditState {
  const InvalidPhoneNumberState({required this.errorMsg});
  final String errorMsg;

  @override
  List<Object> get props => [const Uuid().v4().toString()];
}

class CheckedState extends EditState {
  const CheckedState({required this.invalidItems});
  final Map<Fields?, String?> invalidItems;
}
