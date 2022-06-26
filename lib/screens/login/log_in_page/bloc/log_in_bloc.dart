import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/models/user.dart';

import 'package:snapchat_proj/data/repository/user_repository.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc(this._userRepository) : super(LogInInitial());
  final UserRepository _userRepository;

  @override
  Stream<LogInState> mapEventToState(
    LogInEvent event,
  ) async* {
    if (event is CheckUserEvent) {
      yield LoadingState();
      final UserModel user = (await _userRepository.isSignedUpUser(
          event.usernameOrEmail, event.password))!;
      if (user != null) {
        yield SuccessfullyLoggedIn(userToken: user);
      } else {
        yield UserNotFoundErrorState();
      }
    }
    if (event is CheckEnoughSymbols) {
      if (event.usernameOrEmail.isNotEmpty && event.password.isNotEmpty) {
        yield Valid();
      } else {
        yield Invalid();
      }
    }
  }
}
