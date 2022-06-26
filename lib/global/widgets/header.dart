import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({this.text});
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    );
  }
}
