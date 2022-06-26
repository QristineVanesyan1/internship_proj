import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/models/user.dart';

import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/custom_textfield.dart';
import 'package:snapchat_proj/global/widgets/header.dart';
import 'package:snapchat_proj/global/widgets/link.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/screens/profile/profile.dart';
import 'package:snapchat_proj/global/widgets/screen.dart';

import 'log_in_page/bloc/log_in_bloc.dart';

class Login extends StatefulWidget {
  const Login({required this.usersRepository});
  final UserRepository usersRepository;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isclick = false;
  final TextEditingController _emailTextFieldController =
      TextEditingController();
  final TextEditingController _passwordTextFieldController =
      TextEditingController();

  String get _usernameOrEmail => _emailTextFieldController.text;
  String get _password => _passwordTextFieldController.text;

  late LogInBloc _loginBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.backIconColor),
        backgroundColor: Styles.whiteThemeColor,
        elevation: 0,
      ),
      body: BlocProvider<LogInBloc>(
        create: (context) {
          return _loginBloc = LogInBloc(widget.usersRepository);
        },
        child: BlocListener<LogInBloc, LogInState>(
          listener: (context, state) {
            if (state is SuccessfullyLoggedIn) {
              _navToLogin(context, state.userToken);
            }
            if (state is SuccessfullyLoggedIn) {
              _navToLogin(context, state.userToken);
            }
          },
          child: _render(),
        ),
      ),
    );
  }

  BlocBuilder _render() {
    return BlocBuilder<LogInBloc, LogInState>(builder: (context, state) {
      return Screen(
          [_renderForm(state)],
          _renderLogInButton(context, state,
              DemoLocalizations.of(context).getTranslatedValue('login')));
    });
  }

  Widget _renderForm(LogInState state) {
    return Column(children: [
      Header(text: DemoLocalizations.of(context).getTranslatedValue('login')),
      Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                labelName: DemoLocalizations.of(context)
                    .getTranslatedValue('usrnameOrEmailFieldLabel')
                    .toLowerCase(),
                onTextFieldChange: () => _toggle(),
                txtType: TextInputType.emailAddress,
                customTextFieldController: _emailTextFieldController,
                autovalidate: AutovalidateMode.disabled,
              ),
              CustomTextField(
                labelName: DemoLocalizations.of(context)
                    .getTranslatedValue('passwordFieldLabel')
                    .toLowerCase(),
                isVisible: false,
                onTextFieldChange: () => {_toggle()},
                customTextFieldController: _passwordTextFieldController,
                icon: const Icon(Icons.visibility_off_outlined),
                autovalidate: AutovalidateMode.disabled,
              ),
              Container(
                  padding: const EdgeInsets.only(top: 6),
                  child: _renderErrorMessage(state)),
            ],
          )),
      Center(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Link(
            title: DemoLocalizations.of(context)
                .getTranslatedValue('loginLinkLabel'),
          ),
        ),
      ),
    ]);
  }

  Widget setUpButtonChild(LogInState state, String _title) {
    if (state is LoadingState) {
      if (isclick) {
        return Center(
          child: Transform.scale(
            scale: 0.4,
            child: const CircularProgressIndicator(),
          ),
        );
      }
    }

    return const Text("");
  }

  Widget _renderLogInButton(
      BuildContext context, LogInState state, String _title) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Center(
          child: Stack(children: <Widget>[
            Center(
              child: RoundedButton(
                title: _title,
                onButtonClick: () async {
                  _checkUser(state, _title);
                },
                btnColor: (state is Valid)
                    ? Styles.cntButtonActiveColor
                    : Styles.cntButtonInactiveColor,
              ),
            ),
            setUpButtonChild(state, _title),
          ]),
        ));
  }

  Widget _renderErrorMessage(LogInState state) {
    if (state is LogInInitial) {
      return Text(
        "",
        style: Styles.errorMessageStyle,
      );
    }

    if (state is UserNotFoundErrorState) {
      return Text(
        DemoLocalizations.of(context).getTranslatedValue('usrnameIncorrectMsg'),
        style: Styles.errorMessageStyle,
      );
    }

    if (state is Connected) {
      return Text(
        DemoLocalizations.of(context).getTranslatedValue('offlineMsg'),
        style: Styles.errorMessageStyle,
      );
    } else {
      return Text(
        "",
        style: Styles.errorMessageStyle,
      );
    }
  }

  void _checkUser(LogInState state, String _title) {
    isclick = true;
    if (state is Valid) {
      _loginBloc.add(CheckUserEvent(
          usernameOrEmail: _usernameOrEmail, password: _password));
    }
  }

  void _toggle() {
    setState(() {
      _loginBloc.add(CheckEnoughSymbols(
          usernameOrEmail: _usernameOrEmail, password: _password));
    });
  }

  Future<void> _navToLogin(BuildContext context, UserModel user) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(user: user)),
    );
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}
