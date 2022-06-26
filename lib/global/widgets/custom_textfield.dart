import 'package:flutter/material.dart';
import 'package:snapchat_proj/localization/localization.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      this.labelName,
      this.icon,
      this.onTextFieldChange,
      this.onTextFieldTap,
      this.validator,
      this.txtType,
      this.isTapable,
      required this.autovalidate,
      this.isVisible,
      this.prefixWidget,
      this.isEnable,
      required this.customTextFieldController})
      : super(key: key);

  final String? labelName;
  final Icon? icon;
  final Function? onTextFieldChange;
  final Function? onTextFieldTap;
  final FormFieldValidator<String>? validator;
  final bool? isVisible;
  final bool? isTapable;
  final AutovalidateMode? autovalidate;
  final bool? isEnable;
  final Widget? prefixWidget;
  final TextInputType? txtType;
  final TextEditingController customTextFieldController;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: TextFormField(
          autovalidateMode: widget.autovalidate,
          validator: (s) => widget.validator!(s),
          keyboardType: widget.txtType,
          obscureText: _obscureOfPassword(),

          ///TODO ternary operator delete
          // ignore: avoid_bool_literals_in_conditional_expressions
          readOnly: (widget.isEnable == null || widget.isEnable == false)
              ? false
              : true,

          enableInteractiveSelection:
              // ignore: avoid_bool_literals_in_conditional_expressions
              (widget.isEnable == null || widget.isEnable == false)
                  ? false
                  : true,

          controller: widget.customTextFieldController,
          decoration: InputDecoration(
              prefixIcon: widget.prefixWidget,
              labelText: widget.labelName!.toUpperCase(),
              labelStyle: const TextStyle(
                  fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w500),
              suffixIcon: _showAndHideWidget()),
          onChanged: (text) => widget.onTextFieldChange!(),
          onTap: () =>
              (widget.isTapable == true) ? widget.onTextFieldTap!() : "",
        ),
      ),
    ]);
  }

  bool _obscureOfPassword() {
    if (widget.isVisible == null) {
      return false;
    } else if (widget.isVisible == true) {
      return !_obscureText;
    } else {
      return _obscureText;
    }
  }

  Widget? _showAndHideWidget() {
    if (widget.isVisible == null) {
      //TODO you can do this more readable
      return null;
    } else if (widget.isVisible == true) {
      return TextButton(
          onPressed: _toggle,
          child: Text(_obscureText
              ? DemoLocalizations.of(context).getTranslatedValue('hide')
              : DemoLocalizations.of(context).getTranslatedValue('show')));
    } else {
      return GestureDetector(
        onTap: _toggle,
        child:
            _obscureText ? const Icon(Icons.visibility_outlined) : widget.icon,
      );
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
