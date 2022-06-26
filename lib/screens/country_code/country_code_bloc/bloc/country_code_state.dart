part of 'country_code_bloc.dart';

abstract class CountryCodeState extends Equatable {
  const CountryCodeState();

  @override
  List<Object> get props => [];
}

class CountryCodeInitial extends CountryCodeState {}

class CountryCodeLoadedState extends CountryCodeState {
  const CountryCodeLoadedState({required this.loadedCountryCode});
  final List<CountryCodeModel> loadedCountryCode;

  @override
  List<Object> get props => [loadedCountryCode, const Uuid().v4()];
}

class CountryCodeErrorState extends CountryCodeState {}

class Checking extends CountryCodeState {}

class Loading extends CountryCodeState {}
