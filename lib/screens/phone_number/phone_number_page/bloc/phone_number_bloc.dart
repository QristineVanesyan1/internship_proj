import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/models/country_code.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';

import 'package:uuid/uuid.dart';

part 'phone_number_event.dart';
part 'phone_number_state.dart';

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState> {
  PhoneNumberBloc(this._userRepository, this._validationRepository)
      : super(PhoneNumberInitial());
  final ValidationRepository _validationRepository;
  final UserRepository _userRepository;
  @override
  Stream<PhoneNumberState> mapEventToState(
    PhoneNumberEvent event,
  ) async* {
    if (event is CheckEmail) {
      yield CheckingEmail();
      if (_validationRepository.isValidEmail(event.email)) {
        yield ValidEmail();
      } else {
        yield InvalidEmail();
      }
    } else if (event is CheckPhoneNumber) {
      yield CheckingPhoneNumber();
      if (_validationRepository.isValidPhone(event.phoneNumber)) {
        yield ValidPhoneNumber();
      } else {
        yield InvalidPhoneNumber();
      }
    } else if (event is CheckUsedEmailEvent) {
      yield CheckingUsedEmailEvent();
      if (!await _userRepository.isUsedEmail(event.email) == true) {
        yield UsedEmail();
      } else {
        yield CorrectEmail();
      }
    } else if (event is CheckUsedPhoneEvent) {
      yield CheckingUsedPhoneEvent();
      if (await _userRepository.isUsedPhoneNumber(event.phoneNumber) == true) {
        yield UsedPhoneNumber();
      } else {
        yield CorrectPhoneNumber();
      }
    }
  }
}
