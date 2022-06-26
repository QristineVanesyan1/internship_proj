import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/custom_textfield.dart';
import 'package:snapchat_proj/global/widgets/header.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/global/widgets/screen.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';

import 'package:snapchat_proj/screens/password/password.dart';
import 'package:snapchat_proj/screens/username/username_bloc/bloc/username_bloc.dart';

class Username extends StatefulWidget {
  const Username({required this.user, required this.userRepository});
  final UserModel user;
  final UserRepository userRepository;

  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  final TextEditingController _usernameTextFieldController =
      TextEditingController();

  String get _username => _usernameTextFieldController.text;
  set _username(String val) => widget.user.username = val;

  late UsernameBloc _usernameBloc;

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
        body: BlocProvider<UsernameBloc>(
          create: (context) {
            return _usernameBloc =
                UsernameBloc(widget.userRepository, ValidationRepository());
          },
          child: BlocListener<UsernameBloc, UsernameState>(
              listener: (context, state) {}, child: _render()),
        ));
  }

  BlocBuilder _render() {
    return BlocBuilder<UsernameBloc, UsernameState>(builder: (context, state) {
      return Screen([_renderUsernameForm(state)], _renderContinueButton(state));
    });
  }

  Widget _renderUsernameForm(UsernameState state) {
    return Column(
      children: [
        Header(
            text: DemoLocalizations.of(context)
                .getTranslatedValue('usrnamePageTitle')),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          child: Text(
            DemoLocalizations.of(context)
                .getTranslatedValue('usrnamePageSubTitle'),
            textAlign: TextAlign.center,
            style: Styles.subTitleStyle,
          ),
        ),
        CustomTextField(
          labelName: DemoLocalizations.of(context)
              .getTranslatedValue('usrnameFieldLabel')
              .toUpperCase(),
          onTextFieldChange: () {
            _usernameBloc.add(CheckUsernameIsAviable(username: _username));
            _username = _username;
          },
          customTextFieldController: _usernameTextFieldController,
          autovalidate: AutovalidateMode.disabled,
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: _renderMessage(state),
        )
      ],
    );
  }

  Widget _renderContinueButton(UsernameState state) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Center(
            child: Stack(children: <Widget>[
          Center(
            child: RoundedButton(
                title: DemoLocalizations.of(context)
                    .getTranslatedValue('cntButtonLabel'),
                onButtonClick: () {
                  setState(() {
                    if (state is AviableUsername) {
                      _username = _username;

                      _navigate(context);
                    }
                  });
                },
                btnColor: (state is AviableUsername)
                    ? Styles.cntButtonActiveColor
                    : Styles.cntButtonInactiveColor),
          )
        ])));
  }

  Future<void> _navigate(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return BlocProvider.value(
        value: BlocProvider.of<UserBloc>(context),
        child: Password(
          user: widget.user,
          userRepository: widget.userRepository,
        ),
      );
    }));
  }

  Widget _renderMessage(UsernameState state) {
    if (state is AviableUsername) {
      return Text(
          DemoLocalizations.of(context).getTranslatedValue('aviableMsg'),
          style: Styles.subTextStyle);
    }
    if (state is Checking) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.4,
            child: const CircularProgressIndicator(),
          ),
          Text(
            DemoLocalizations.of(context).getTranslatedValue('checkMsg'),
            style: Styles.subTextStyle,
          ),
        ],
      );
    }
    if (state is UsedUsername) {
      return Text(
        _username +
            DemoLocalizations.of(context).getTranslatedValue('takenMsg'),
        style: Styles.errorMessageStyle,
      );
    }
    if (state is NotEnoughSymbols) {
      return Text(
        DemoLocalizations.of(context).getTranslatedValue('shortUsernameMsg'),
        style: Styles.errorMessageStyle,
      );
    }
    return Text(
      " ",
      style: Styles.errorMessageStyle,
    );
  }

  @override
  void dispose() {
    _usernameBloc.close();
    super.dispose();
  }
}
