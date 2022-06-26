import 'package:country_codes/country_codes.dart';

class CountryCodeModel {
  CountryCodeModel(
      {this.id, this.code, this.fullName, this.shortName, this.flag});

  factory CountryCodeModel.fromJSON(Map<String, dynamic> json) {
    return CountryCodeModel(
        code: "+${json['e164_cc']}",
        fullName: json['name'],
        shortName: json['iso2_cc'],
        flag: json['iso2_cc'].toString().flagEmoji);
  }

  factory CountryCodeModel.fromMap(Map<String, dynamic> map) {
    return CountryCodeModel(
        code: map['e164_cc'],
        fullName: map['name'],
        shortName: map['iso2_cc'],
        flag: map['iso2_cc'].toString().flagEmoji);
  }

  factory CountryCodeModel.fromCountryDetails(CountryDetails country) {
    return CountryCodeModel(
        fullName: country.name ?? "United States",
        shortName: country.alpha2Code ?? "US",
        code: country.dialCode ?? "+1",
        flag: country.alpha2Code ?? "US".flagEmoji);
  }

  final String? id;
  final String? code;
  final String? fullName;
  final String? shortName;
  final String? flag;

  Map<String, dynamic> toMap() => {
        "id": id,
        "code": code,
        "fullName": fullName,
        "shortName": shortName,
        "flag": flag,
      };

  @override
  String toString() {
    return "Country Code Model -> [code: $code full name: $fullName short name: $shortName]";
  }
}

extension _Emoji on String {
  String get flagEmoji => toUpperCase().replaceAllMapped(RegExp('[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
}
