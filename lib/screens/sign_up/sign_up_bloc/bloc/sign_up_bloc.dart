import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._validationRepository) : super(SignUpInitial());
  final ValidationRepository _validationRepository;

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is CheckEnoughSymbols) {
      yield Loading();
      if (!_validationRepository.isValidFirstName(event.fname) &&
          !_validationRepository.isValidLastName(event.lname)) {
        yield BothEmpty();
      } else if (!_validationRepository.isValidFirstName(event.fname)) {
        yield EmptyFname();
      } else if (!_validationRepository.isValidLastName(event.lname)) {
        yield EmptyLname();
      } else {
        yield Valid();
      }
    }
  }
}
