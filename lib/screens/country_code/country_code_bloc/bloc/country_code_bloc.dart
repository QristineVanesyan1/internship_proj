import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snapchat_proj/data/models/country_code.dart';
import 'package:snapchat_proj/data/repository/country_code_repository.dart';
import 'package:snapchat_proj/screens/edit/bloc/edit_bloc.dart';
import 'package:uuid/uuid.dart';

part 'country_code_event.dart';
part 'country_code_state.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState> {
  CountryCodeBloc({this.countryCodeRepository}) : super(CountryCodeInitial());
  final CountryCodeRepository? countryCodeRepository;
  @override
  Stream<CountryCodeState> mapEventToState(
    CountryCodeEvent event,
  ) async* {
    if (event is LoadloadCountryCodeList) {
      //yield Loading();

      final List<CountryCodeModel>? _loadedCountryCodeList =
          await countryCodeRepository?.getCountryCodeList();
      if (_loadedCountryCodeList != null) {
        yield CountryCodeLoadedState(loadedCountryCode: _loadedCountryCodeList);
      } else {
        print("ok");
      }
    } else if (event is SearchCountry) {
      // final List<CountryCodeModel> _items = await countryCodeRepository!
      //     .getFilteredCountryCodes(event.countryName);
      //  yield CountryCodeLoadedState(loadedCountryCode: _items);
    }
  }
}
