part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class CheckEnoughSymbols extends SignUpEvent {
  const CheckEnoughSymbols({required this.fname, required this.lname});
  final String fname;
  final String lname;
}

// class LoadURL extends FnameLnameEvent {
//   final String URL;
//   const LoadURL({@required this.URL});
// }
