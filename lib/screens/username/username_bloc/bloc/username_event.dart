part of 'username_bloc.dart';

abstract class UsernameEvent extends Equatable {
  const UsernameEvent();

  @override
  List<Object> get props => [];
}

class CheckUsernameIsAviable extends UsernameEvent {
  const CheckUsernameIsAviable({required this.username});
  final String username;
}
