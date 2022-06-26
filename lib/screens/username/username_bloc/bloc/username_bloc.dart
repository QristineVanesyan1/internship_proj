import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';

part 'username_event.dart';
part 'username_state.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  UsernameBloc(this._userRepository, this._validationRepository)
      : super(UsernameInitial());
  final UserRepository _userRepository;
  final ValidationRepository _validationRepository;

  @override
  Stream<UsernameState> mapEventToState(
    UsernameEvent event,
  ) async* {
    if (event is CheckUsernameIsAviable) {
      yield Checking();
      if (!_validationRepository.isValidUsername(event.username)) {
        yield NotEnoughSymbols();
      } else if (await _userRepository.isUsernameAviable(event.username)) {
        yield AviableUsername();
      } else {
        yield UsedUsername();
      }
    }
  }
}
