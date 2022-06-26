import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen(this.scrollable, this.button);
  final List<Widget> scrollable;
  final Widget button;

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            bottom: 60,
            right: 0,
            left: 0,
            top: 0,
            child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.scrollable,
                  ),
                )),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(child: widget.button),
          ),
        ],
      ),
    );
  }
}
