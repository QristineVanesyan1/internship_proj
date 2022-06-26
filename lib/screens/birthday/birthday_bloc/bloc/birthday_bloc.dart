import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
part 'birthday_event.dart';
part 'birthday_state.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState> {
  BirthdayBloc(this._validationRepository) : super(BirthdayInitial());
  final ValidationRepository _validationRepository;

  @override
  Stream<BirthdayState> mapEventToState(
    BirthdayEvent event,
  ) async* {
    if (event is CheckAge) {
      if (_validationRepository
          .isValidBirthdate(event.selectedDate.toIso8601String())) {
        yield AcceptableAge();
      } else {
        yield UnacceptableAge();
      }
    }
  }
}
