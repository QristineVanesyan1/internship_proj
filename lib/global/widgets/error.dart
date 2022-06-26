import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  Widget get _warningIcon => Image.asset(
        'assets/images/warning.png',
        width: 120,
        height: 120,
      );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _warningIcon,
          const Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: Text(
              "ERROR",
              style: TextStyle(fontSize: 23, color: Colors.grey),
            ),
          ),
          const Text(
            "Please, try later",
            style: TextStyle(fontSize: 16, color: Colors.black12),
          )
        ]),
      ],
    );
  }
}
