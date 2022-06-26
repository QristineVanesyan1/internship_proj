import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/models/country_code.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/custom_textfield.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/screens/phone_number/phone_number_page/bloc/phone_number_bloc.dart';
import 'package:snapchat_proj/screens/profile/profile.dart';
import 'package:snapchat_proj/screens/country_code/country_code.dart';
import 'package:snapchat_proj/global/widgets/screen.dart';

class PhoneNumber extends StatefulWidget {
  PhoneNumber({required this.user, required this.userRepository});

  UserModel user;
  final UserRepository userRepository;

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  //  ---> Property names should be logical, maybe _changeCountryNotifier?

  ValueNotifier<CountryCodeModel> _country =
      ValueNotifier<CountryCodeModel>(CountryCodeModel());
  late PhoneNumberBloc _phoneNumBloc;
  late CountryCodeModel _selectedCountry;
  String _localizedString(String str) =>
      DemoLocalizations.of(context).getTranslatedValue(str);
  bool phoneNumberScreen = true;

  final TextEditingController _phoneNumberTextFieldController =
      TextEditingController();
  final TextEditingController _emailTextFieldController =
      TextEditingController();

  String get phoneNumberTxt => _phoneNumberTextFieldController.text;
  String get emailTxt => _emailTextFieldController.text;
  late UserBloc userBloc;
  final _formKeyPhoneNumber = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.add(GetDeviceCurrentCode());
    _phoneNumBloc =
        PhoneNumberBloc(widget.userRepository, ValidationRepository());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneNumBloc.close();
  }

  //  ---> Seperate build function on other functions
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
        body: BlocProvider<PhoneNumberBloc>(
            create: (context) {
              return _phoneNumBloc;
            },
            child: MultiBlocListener(
                listeners: [
                  BlocListener<UserBloc, UserState>(listener: (context, state) {
                    if (state is CurrentCodeLoadedState) {
                      setState(() {
                        _selectedCountry = state.loadedCountryCode;
                      });

                      _country =
                          ValueNotifier<CountryCodeModel>(_selectedCountry);
                    }
                    if (state is UserAddedState) {
                      widget.user = state.user;
                      _navigateProfile(context, Profile(user: widget.user));
                    }
                  }),
                  BlocListener<PhoneNumberBloc, PhoneNumberState>(
                      listener: (context, state) {
                    checkWhileListen(state, userBloc);
                  }),
                ],
                child: Builder(builder: (BuildContext context) {
                  return _render(userBloc);
                }))));
  }

  BlocBuilder _render(UserBloc userBloc) {
    return BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
        builder: (context, state) {
      return Screen(
          [_renderForm(state, userBloc)], _renderContinueBtn(state, userBloc));
    });
  }

  Widget _renderForm(PhoneNumberState state, UserBloc userBloc) {
    return Column(
      children: [
        _renderTitle(),
        Center(child: _renderLink()),
        Visibility(
          visible: phoneNumberScreen,
          child: phoneForm(state),
        ),
        Visibility(
          visible: !phoneNumberScreen,
          child: emailForm(state, userBloc),
        ),
        _renderInscription(),
      ],
    );
  }

  Widget _renderTitle() {
    return Text(
      phoneNumberScreen
          ? _localizedString("phoneNumberPageTitle")
          : _localizedString("emailPageTitle"),
      style: Styles.pageTitleStyle,
    );
  }

  //---> Function names should be logical
  Widget _renderLink() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            phoneNumberScreen = !phoneNumberScreen;
            if (phoneNumberScreen) {
              _phoneNumBloc.add(CheckPhoneNumber(
                  phoneNumber:
                      "${_selectedCountry.code.toString()}$phoneNumberTxt"));
            } else {
              _phoneNumBloc.add(CheckEmail(email: emailTxt));
            }
          });
        },
        child: Text(
          phoneNumberScreen
              ? _localizedString("phoneNumberLinkLabel")
              : _localizedString("emailLinkLabel"),
          style: Styles.linkLabelStyle,
        ),
      ),
    );
  }

  // ---> Render functions names should be like this Widget _phoneForm(PhoneNumberState state)
  Widget phoneForm(PhoneNumberState state) {
    return Form(
        key: _formKeyPhoneNumber,
        child: CustomTextField(
          autovalidate: AutovalidateMode.always,
          labelName: phoneNumberScreen
              ? _localizedString("phoneNumberFieldLabel")
              : _localizedString("emailFieldLabel"),
          txtType: TextInputType.text,
          customTextFieldController: _phoneNumberTextFieldController,
          prefixWidget: _countryCodePicker(state),
          onTextFieldChange: () => addEventPhone(),
          validator: (_) => validatePhone(state),
        ));
  }

  //---> Is need context here ?
  Widget emailForm(PhoneNumberState state, UserBloc userBloc) {
    return Form(
      key: _formKeyEmail,
      child: CustomTextField(
        autovalidate: AutovalidateMode.always,
        labelName: _localizedString("emailFieldLabel").toUpperCase(),
        onTextFieldChange: () => addEventEmail(),
        txtType: TextInputType.emailAddress,
        customTextFieldController: _emailTextFieldController,
        validator: (_) => validateEmail(state),
      ),
    );
  }

  Widget _renderInscription() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        _localizedString('notificationMsg'),
        style: Styles.notificationMsgStyle,
      ),
    );
  }

  Widget _renderContinueBtn(PhoneNumberState state, UserBloc userBloc) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Center(
            child: Stack(children: <Widget>[
          Center(
              child: Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: RoundedButton(
                    title: _localizedString("cntButtonLabel"),
                    onButtonClick: () => checkUsed(userBloc, state),
                    btnColor: buttonStateCheck(state),
                  )))
        ])));
  }

  Widget _countryCodePicker(PhoneNumberState state) {
    return TextButton(
        onPressed: () async {
          _navigateCountryCode();
        },
        child: Column(
          children: [
            ValueListenableBuilder<CountryCodeModel>(
              builder: (BuildContext context, CountryCodeModel value,
                  Widget? child) {
                _selectedCountry = _country.value;
                return Text(
                  "${_selectedCountry.shortName} ${_selectedCountry.code.toString()}",
                  style: Styles.countryCodePickerStyle,
                );
              },
              valueListenable: _country,
            ),
          ],
        ));
  }

  void addEventPhone() {
    _phoneNumBloc.add(CheckPhoneNumber(
        phoneNumber: "${_selectedCountry.code.toString()}$phoneNumberTxt"));
  }

  void addEventEmail() {
    _phoneNumBloc.add(CheckEmail(email: emailTxt));
  }

  void checkUsed(UserBloc userBloc, PhoneNumberState state) {
    if (state is ValidEmail) {
      _phoneNumBloc.add(CheckUsedEmailEvent(email: emailTxt));
    }
    if (state is ValidPhoneNumber) {
      _phoneNumBloc.add(CheckUsedPhoneEvent(phoneNumber: phoneNumberTxt));
    }
  }

  String? validateEmail(PhoneNumberState state) {
    if (state is UsedEmail) {
      return _localizedString('usedEmailMsg');
    } else {
      return null;
    }
  }

  String? validatePhone(PhoneNumberState state) {
    if (state is UsedPhoneNumber) {
      return _localizedString('usedPhoneNumberMsg');
    } else {
      return null;
    }
  }

  Color buttonStateCheck(PhoneNumberState state) {
    if (state is ValidPhoneNumber || state is ValidEmail) {
      return Styles.cntButtonActiveColor;
    }
    return Styles.cntButtonInactiveColor;
  }

  void checkWhileListen(PhoneNumberState state, UserBloc userBloc) {
    if (state is CorrectEmail) {
      widget.user.email = emailTxt;
    }
    if (state is CorrectPhoneNumber) {
      widget.user.phone = "${_selectedCountry.code.toString()}$phoneNumberTxt";
    }
    if (state is CorrectEmail || state is CorrectPhoneNumber) {
      userBloc.add(AddUserEvent(user: widget.user));
    }
  }

  //---> Is need context here ?
  Future<void> _navigateProfile(BuildContext context, Widget toPage) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return BlocProvider.value(
          value: BlocProvider.of<UserBloc>(context), child: toPage);
    }));
  }

  void _navigateCountryCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return CountryCode(countryValueNotifier: _country);
      }),
    );
  }
}
