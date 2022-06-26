import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:country_codes/country_codes.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat_proj/data/models/country_code.dart';
import 'package:snapchat_proj/data/models/user.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._repository) : super(const UserState());

  final UserRepository _repository;
  UserRepository get repository => _repository;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is AddUserEvent) {
      final UserModel user = (await _repository.addUser(event.user))!;
      yield UserAddedState(user: user);
    } else if (event is DeleteUserEvent) {
      await _repository.deleteUser();
      yield UserDeletedState();
    } else if (event is LoadUsersEvent) {
      yield LoadingState();
      final List<UserModel> loadedUsers = await _repository.users;
      yield LoadedUsersState(loadedUsers: loadedUsers);
    } else if (event is CheckSession) {
      yield Loading();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('userToken');
      if (userToken != null) {
        Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': userToken
        };
        final Response response = await get(
            'https://parentstree-server.herokuapp.com/me',
            headers: headers);

        final int statusCode = response.statusCode;

        final String body = response.body;
        var a = jsonDecode(body)["user"];
        yield UserInSession(user: UserModel.fromJSON(a));
      } else {
        yield UserNotInSession();
      }
    } else if (event is DestroySession) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('userToken');
      yield SessionDestroyed();
    } else if (event is GetDeviceCurrentCode) {
      CountryCodeModel _selectedCountry;
      if (!kIsWeb) {
        await CountryCodes.init();
        final CountryDetails country = CountryCodes.detailsForLocale();
        _selectedCountry = CountryCodeModel.fromCountryDetails(country);
      } else {
        _selectedCountry = CountryCodeModel(
            fullName: "United States", flag: "US", code: "+1", shortName: "US");
      }
      yield CurrentCodeLoadedState(loadedCountryCode: _selectedCountry);
    }
  }
}
