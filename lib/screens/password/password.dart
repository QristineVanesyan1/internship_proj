import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snapchat_proj/data/models/user.dart';

import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/custom_textfield.dart';
import 'package:snapchat_proj/global/widgets/header.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/localization/localization.dart';

import 'package:snapchat_proj/screens/password/password_page/bloc/password_bloc.dart';
import 'package:snapchat_proj/screens/phone_number/phone_number.dart';
import 'package:snapchat_proj/global/widgets/screen.dart';

class Password extends StatefulWidget {
  const Password({required this.user, required this.userRepository});
  final UserModel user;
  final UserRepository userRepository;

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  late PasswordBloc _passwordBloc;

  final TextEditingController _passwordTextFieldController =
      TextEditingController();

  String get _userPassword => _passwordTextFieldController.text;
  set _userPassword(String val) => widget.user.password = val;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Styles.backIconColor,
        ),
        backgroundColor: Styles.whiteThemeColor,
        elevation: 0,
      ),
      body: BlocProvider<PasswordBloc>(
        create: (context) {
          return _passwordBloc = PasswordBloc(ValidationRepository());
        },
        child: BlocListener<PasswordBloc, PasswordState>(
          listener: (context, state) {},
          child: _render(),
        ),
      ),
    );
  }

  BlocBuilder _render() {
    return BlocBuilder<PasswordBloc, PasswordState>(builder: (context, state) {
      return Screen([_renderPasswordForm(state)], _renderContinueButton(state));
    });
  }

  Widget _renderPasswordForm(PasswordState state) {
    return Column(
      children: [
        Header(
          text: DemoLocalizations.of(context)
              .getTranslatedValue('passwordPageTitle'),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
              DemoLocalizations.of(context)
                  .getTranslatedValue('passwordPageSubtitle'),
              textAlign: TextAlign.center,
              style: Styles.subTitleStyle),
        ),
        Form(
          key: _formKey,
          child: CustomTextField(
            labelName: DemoLocalizations.of(context)
                .getTranslatedValue('passwordFieldLabel'),
            customTextFieldController: _passwordTextFieldController,
            isVisible: true,
            validator: (val) => (state is NotEnoughSymbols ||
                    state is PasswordInitial ||
                    state is EmptyPassword)
                ? DemoLocalizations.of(context)
                    .getTranslatedValue('shortPasswordMsg')
                : null,
            onTextFieldChange: () =>
                _passwordBloc.add(CheckPassword(password: _userPassword)),
            autovalidate: AutovalidateMode.disabled,
          ),
        ),
      ],
    );
  }

  Widget _renderContinueButton(PasswordState state) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Center(
            child: Stack(children: <Widget>[
          Center(
              child: RoundedButton(
            title: DemoLocalizations.of(context)
                .getTranslatedValue('cntButtonLabel'),
            onButtonClick: () async {
              _passwordBloc.add(CheckPassword(password: _userPassword));

              if (_formKey.currentState!.validate()) {
                if (state is NotEnoughSymbols || state is AllowablePassword) {
                  _userPassword = _userPassword;
                  _navigate();
                }
              }
            },
            btnColor: (state is NotEnoughSymbols || state is AllowablePassword)
                ? Styles.cntButtonActiveColor
                : Styles.cntButtonInactiveColor,
          ))
        ])));
  }

  Future<void> _navigate() {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return BlocProvider.value(
        value: BlocProvider.of<UserBloc>(context),
        child: PhoneNumber(
            user: widget.user, userRepository: widget.userRepository),
      );
    }));
  }

  @override
  void dispose() {
    _passwordBloc.close();
    super.dispose();
  }
}
