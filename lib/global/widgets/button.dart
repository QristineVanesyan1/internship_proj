import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({this.color, this.title, required this.toPage});
  final Color? color;
  final String? title;
  final Widget toPage;

  Color get _txtColor => const Color(0xFFffffff);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: color,
          ),
          child: Text(
            title ?? "".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _txtColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 5),
          )),
    );
  }

  Future<void> _navigate(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => toPage),
    );
  }
}
