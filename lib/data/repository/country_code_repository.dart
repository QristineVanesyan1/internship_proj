import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:snapchat_proj/data/models/country_code.dart';

class CountryCodeRepository {
  Future<String> loadCountryCodesFromJSON() async {
    return rootBundle.loadString('assets/json/country-codes.json');
  }

  Future<String> _loadACountryAsset() async {
    return rootBundle.loadString('assets/json/country-codes.json');
  }

  // Future<List<CountryCodeModel>> getCountryCodeList() async {
  //   final String jsonString = await loadCountryCodesFromJSON();
  //   final jsonResponse = json.decode(jsonString);
  //   print(jsonResponse);
  //   return [];
  // }

  Future<List<CountryCodeModel>> getCountryCodeList() async {
    print('start');
    String jsonString = '';
    try {
      jsonString = await _loadACountryAsset();
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(jsonString);
    return jsonResponse
        .map<CountryCodeModel>((json) => CountryCodeModel.fromJSON(json))
        .toList();
  }

  // Future<List<CountryCodeModel>> getFilteredCountryCodes(String country) async {
  //   final List<CountryCodeModel>? countries = await getCountryCodeList();
  //   final List<CountryCodeModel> searched = [];
  //   for (final CountryCodeModel country in countries!) {
  //     searched.add(country);
  //   }
  //   return searched;
  // }
  /*
  
  
  
  
  

  Future<String> _loadACountryAsset() async {
    return rootBundle.loadString('assets/country-codes.json');
  } */
}
