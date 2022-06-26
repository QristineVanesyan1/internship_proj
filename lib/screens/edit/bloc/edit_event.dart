part of 'edit_bloc.dart';

abstract class EditEvent extends Equatable {
  const EditEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserDataEvent extends EditEvent {
  const UpdateUserDataEvent({required this.user});
  final UserModel user;
}

class ValidateFirstNameEvent extends EditEvent {
  const ValidateFirstNameEvent({this.firstName});
  final String? firstName;
}

class ValidateLastNameEvent extends EditEvent {
  const ValidateLastNameEvent({ this.lastName});
  final String? lastName;
}

class ValidateUsernameEvent extends EditEvent {
  const ValidateUsernameEvent({required this.username});
  final String username;
}

class ValidatePhoneEvent extends EditEvent {
  const ValidatePhoneEvent({required this.phone});
  final String phone;
}

class ValidateEmailEvent extends EditEvent {
  const ValidateEmailEvent({required this.email});
  final String email;
}

class ValidatePasswordEvent extends EditEvent {
  const ValidatePasswordEvent({required this.password});
  final String password;
}

class ValidateBirthdateEvent extends EditEvent {
  const ValidateBirthdateEvent({required this.date});
  final DateTime date;
}

class CheckForm extends EditEvent {
  const CheckForm({required this.user, required this.userBeforeUpdate});
  final UserModel user;
  final UserModel userBeforeUpdate;
}
