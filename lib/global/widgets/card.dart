import 'package:flutter/material.dart';
import 'package:snapchat_proj/data/models/country_code.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({required this.country});
  final CountryCodeModel country;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Text(country.flag ?? ""),
      title: Text(country.fullName ?? ""),
      trailing: Text(country.code ?? ""),
    ));
  }
}
