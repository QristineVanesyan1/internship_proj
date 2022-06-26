part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class Valid extends SignUpState {}

class Loading extends SignUpState {}

class EmptyFname extends SignUpState {}

class EmptyLname extends SignUpState {}

class BothEmpty extends SignUpState {}
