import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/custom_textfield.dart';
import 'package:snapchat_proj/global/widgets/header.dart';
import 'package:snapchat_proj/global/widgets/rich_link.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/screens/birthday/birthday.dart';
import 'package:snapchat_proj/global/widgets/screen.dart';
import 'package:snapchat_proj/screens/sign_up/sign_up_bloc/bloc/sign_up_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({required this.usersRepository});

  final UserRepository usersRepository;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _lnameFieldController = TextEditingController();
  final TextEditingController _fnameFieldController = TextEditingController();

  late SignUpBloc _fnameLnameBloc;
  final UserModel _user = UserModel();

  String get _firstname => _fnameFieldController.text;
  set _firstname(String val) => _user.firstName = val;

  String get _lastname => _lnameFieldController.text;
  set _lastname(String val) => _user.lastName = val;

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
        body: BlocProvider<SignUpBloc>(
          create: (context) {
            return _fnameLnameBloc = SignUpBloc(ValidationRepository());
          },
          child: BlocListener<SignUpBloc, SignUpState>(
              listener: (context, state) {
                if (state is CheckEnoughSymbols) {}
              },
              child: _render()),
        ));
  }

//[_renderForm(state), _renderContinueButton(state)]
  BlocBuilder _render() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Screen([_renderForm(state)], _renderContinueButton(state));
    });
  }

  Widget _renderForm(SignUpState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _renderTitle(),
          _renderFirstNameField(state),
          _renderLastNameField(state),
          _renderRichTextMessage(),
        ],
      ),
    );
  }

  Widget _renderTitle() {
    return Header(
      text: DemoLocalizations.of(context).getTranslatedValue('signupPageTitle'),
    );
  }

  Widget _renderFirstNameField(SignUpState state) {
    return CustomTextField(
      labelName: DemoLocalizations.of(context)
          .getTranslatedValue('fnameFieldLabel')
          .toUpperCase(),
      customTextFieldController: _fnameFieldController,
      validator: (String? value) {
        if (state is BothEmpty || state is EmptyFname) {
          return DemoLocalizations.of(context)
              .getTranslatedValue('emptyFnameMsg');
        }
        return null;
      },
      onTextFieldChange: () => {
        _fnameLnameBloc
            .add(CheckEnoughSymbols(fname: _firstname, lname: _lastname))
      },
      autovalidate: AutovalidateMode.disabled,
    );
  }

  Widget _renderLastNameField(SignUpState state) {
    return CustomTextField(
      labelName: DemoLocalizations.of(context)
          .getTranslatedValue('lnameFieldLabel')
          .toUpperCase(),
      customTextFieldController: _lnameFieldController,
      validator: (String? value) {
        if (state is BothEmpty || state is EmptyLname) {
          return DemoLocalizations.of(context)
              .getTranslatedValue('emptyLnameMsg');
        }
        return null;
      },
      onTextFieldChange: () => {
        _fnameLnameBloc
            .add(CheckEnoughSymbols(fname: _firstname, lname: _lastname))
      },
      autovalidate: AutovalidateMode.disabled,
    );
  }

  Widget _renderRichTextMessage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
      child: Center(
        child: RichLink(),
      ),
    );
  }

  Widget _renderContinueButton(SignUpState state) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Center(
            child: Stack(children: <Widget>[
          Center(
              child: RoundedButton(
            title:
                DemoLocalizations.of(context).getTranslatedValue('signUpBtn'),
            onButtonClick: () {
              if (_formKey.currentState!.validate() && state is Valid) {
                _navigate(context);
              }
            },
            btnColor: (state is BothEmpty || state is SignUpInitial)
                ? Styles.cntButtonInactiveColor
                : Styles.cntButtonActiveColor,
          ))
        ])));
  }

  Future<void> _navigate(BuildContext context) {
    _lastname = _lastname;
    _firstname = _firstname;
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return BlocProvider.value(
        value: BlocProvider.of<UserBloc>(context),
        child: Birthday(
          user: _user,
          usersRepository: widget.usersRepository,
        ),
      );
    }));
  }

  @override
  void dispose() {
    _fnameLnameBloc.close();
    super.dispose();
  }
}
