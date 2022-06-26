import 'package:flutter/material.dart';

class Link extends StatefulWidget {
  const Link({this.title, this.func});
  final String? title;
  final Function? func;

  Color get _txtColor => const Color(0xFF02a9f4);

  @override
  _LinkState createState() => _LinkState();
}

class _LinkState extends State<Link> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.func,
      child: Text(
        widget.title ?? "",
        style: TextStyle(
          fontSize: 11,
          color: widget._txtColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
