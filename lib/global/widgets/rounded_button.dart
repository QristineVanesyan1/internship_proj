import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({this.title, this.btnColor, this.onButtonClick});

  final String? title;
  final Color? btnColor;
  final Function? onButtonClick;
  Color get _txtColor => const Color(0xFFffffff);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onButtonClick!(),
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.center,
          height: 40,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: btnColor),
          child: Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _txtColor,
              fontSize: 15,
            ),
          )),
    );
  }
}
