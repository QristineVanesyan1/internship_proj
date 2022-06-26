part of 'country_code_bloc.dart';

abstract class CountryCodeEvent extends Equatable {
  const CountryCodeEvent();

  @override
  List<Object> get props => [];
}

class LoadloadCountryCodeList extends CountryCodeEvent {}

class SearchCountry extends CountryCodeEvent {
  const SearchCountry({required this.countryName});
  final String countryName;
}
