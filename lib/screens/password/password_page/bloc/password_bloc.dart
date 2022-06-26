import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc(this._validationRepository) : super(PasswordInitial());
  final ValidationRepository _validationRepository;
  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is CheckPassword) {
      if (_validationRepository.isValidPassword(event.password)) {
        yield AllowablePassword();
      } else if (event.password.isNotEmpty) {
        yield NotEnoughSymbols();
      } else if (event.password.isEmpty) {
        yield EmptyPassword();
      }
    }
  }
}
