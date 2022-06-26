import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
import 'package:uuid/uuid.dart';
part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc(this._userRepository, this._validateRepository)
      : super(EditInitial());

  final UserRepository _userRepository;
  final ValidationRepository _validateRepository;

  // ---> Function is too long, seperate it other functions
  @override
  Stream<EditState> mapEventToState(
    EditEvent event,
  ) async* {
    if (event is UpdateUserDataEvent) {
      yield Updating();
      final UserModel user =
          (await _userRepository.updateUserData(event.user))!;
      yield UserDataUpdatedState(user: user);
    } else if (event is ValidateFirstNameEvent) {
      String? error;
      if (!_validateRepository.isValidFirstName(event.firstName ?? "")) {
        error = "emptyFnameMsg";
      }
      yield InvalidFirstname(errorMsg: error ?? "");
    } else if (event is ValidateLastNameEvent) {
      String? error;
      if (!_validateRepository.isValidLastName(event.lastName ?? "")) {
        error = "emptyLnameMsg";
      }
      yield InvalidLastname(errorMsg: error ?? "");
    } else if (event is ValidateUsernameEvent) {
      String? error;
      if (!_validateRepository.isValidUsername(event.username)) {
        error = "shortUsernameMsg";
      }
      yield InvalidUsername(errorMsg: error ?? "");
    } else if (event is ValidateBirthdateEvent) {
      String? error;
      if (!_validateRepository.isValidBirthdate(event.date.toIso8601String())) {
        error = "unacceptableAgeMsg";
      }
      yield InvalidBirthdate(errorMsg: error ?? "");
    } else if (event is ValidateEmailEvent) {
      String? error;
      if (!_validateRepository.isValidEmail(event.email)) {
        error = "invalidEmailMsg";
      }
      yield InvalidEmailState(errorMsg: error ?? "");
    } else if (event is ValidatePhoneEvent) {
      String? error;
      if (!_validateRepository.isValidPhone(event.phone)) {
        error = "invalidPhoneNumberMsg";
      }
      yield InvalidPhoneNumberState(errorMsg: error ?? "");
    } else if (event is ValidatePasswordEvent) {
      String? error;
      if (!_validateRepository.isValidPassword(event.password)) {
        error = "shortPasswordMsg";
      }
      yield InvalidPassword(errorMsg: error ?? "");
    } else if (event is CheckForm) {
      final UserModel _beforeUpdate = event.userBeforeUpdate;
      final UserModel _current = event.user;
      final Map<Fields?, String?> invalidItems = {};

      if (!_validateRepository.isValidFirstName(_current.firstName ?? "")) {
        invalidItems[Fields.firstname] = "emptyFnameMsg";
      }
      if (!_validateRepository.isValidLastName(_current.lastName ?? "")) {
        invalidItems[Fields.lastname] = "emptyLnameMsg";
      }
      if (!_validateRepository.isValidBirthdate(_current.birthdate ?? "")) {
        invalidItems[Fields.birthdate] = "unacceptableAgeMsg";
      }
      if (!_validateRepository.isValidPassword(_current.password ?? "")) {
        invalidItems[Fields.password] = "shortPasswordMsg";
      }

      if (_beforeUpdate.username != _current.username) {
        if (!_validateRepository.isValidUsername(_current.username ?? "")) {
          invalidItems[Fields.username] = "shortUsernameMsg";
        } else if (!await _userRepository
            .isUsernameAviable(_current.username ?? "")) {
          invalidItems[Fields.username] = "takenMsgFull";
        }
      }

      if (_beforeUpdate.email != _current.email && _current.email!.isNotEmpty) {
        if (!_validateRepository.isValidEmail(_current.email!)) {
          invalidItems[Fields.email] = "invalidEmailMsg";
        } else if (!(await _userRepository.isUsedEmail(_current.email!))) {
          invalidItems[Fields.email] = "usedEmailMsg";
        }
      }
      if (_beforeUpdate.phone != _current.phone && _current.phone!.isNotEmpty) {
        if (!_validateRepository.isValidPhone(_current.phone!)) {
          invalidItems[Fields.mobile] = "invalidPhoneNumberMsg";
        } else if (await _userRepository.isUsedPhoneNumber(_current.phone!)) {
          invalidItems[Fields.mobile] = "usedPhoneNumberMsg";
        }
      }
      if (_current.email!.isEmpty && _current.phone!.isEmpty) {
        invalidItems[Fields.mobile] = "invalidPhoneNumberMsg";
        invalidItems[Fields.email] = "invalidEmailMsg";
      }
      yield CheckedState(invalidItems: invalidItems);
    }
  }
}
