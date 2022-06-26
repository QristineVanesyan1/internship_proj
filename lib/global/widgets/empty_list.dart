import "package:flutter/material.dart";

class EmptyListWidget extends StatelessWidget {
  Widget get _emptyListIcon => Image.asset(
        'assets/images/files.png',
        width: 120,
        height: 120,
      );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _emptyListIcon,
          const Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: Text(
              "Empty List!",
              style: TextStyle(fontSize: 23, color: Colors.grey),
            ),
          ),
          const Text(
            "You have no users at this moment.",
            style: TextStyle(fontSize: 16, color: Colors.black12),
          )
        ]),
      ],
    );
  }
}
