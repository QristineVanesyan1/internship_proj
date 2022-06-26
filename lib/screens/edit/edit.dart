import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snapchat_proj/data/models/country_code.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/custom_textfield.dart';
import 'package:snapchat_proj/global/widgets/header.dart';
import 'package:snapchat_proj/global/widgets/progress_bar.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/screens/country_code/country_code.dart';
import 'package:snapchat_proj/screens/edit/bloc/edit_bloc.dart';
import 'package:snapchat_proj/global/widgets/screen.dart';
import 'package:snapchat_proj/screens/phone_number/phone_number_page/bloc/phone_number_bloc.dart';

//- - - > Use logical class name
class EditUserScreen extends StatefulWidget {
  EditUserScreen(
      {required this.user,
      required this.getEditedUser,
      required this.usersRepository,
      this.loadUsers});
  final Function? loadUsers;
  final Function(UserModel) getEditedUser;
  UserModel user;
  final UserRepository usersRepository;
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<EditUserScreen> {
  late DateTime _chosenDateTime;
  late CountryCodeModel _selectedCountry = CountryCodeModel();
  ValueNotifier<CountryCodeModel> _country =
      ValueNotifier<CountryCodeModel>(CountryCodeModel());

  // ---> Use functions for this propertys
  DateTime _selectedDate = DateTime(
      DateTime.now().year - 16, DateTime.now().month, DateTime.now().day);
  DateTime get _currentDate => DateTime.now();
  DateTime get _calendarFirstDate => DateTime(_currentDate.year - 110);
  DateTime get _calendarLastDate => DateTime.now();
  EditBloc? _editBloc;
  final _formKey = GlobalKey<FormState>();

  late UserBloc _userBloc;

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();

  String? _message(String? message) =>
      DemoLocalizations.of(context).getTranslatedValue(message ?? "");

  UserModel get currUser => widget.user;
  late UserModel userPrevUpdated;
//?
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initTextFieldsData(currUser);
    userPrevUpdated = currUser;
  }

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(const LoadUsersEvent());
  }

  @override
  void dispose() {
    _editBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              iconTheme: IconThemeData(color: Styles.backIconColor),
              backgroundColor: Styles.whiteThemeColor,
              elevation: 0,
            ),
            body: BlocProvider<EditBloc>(
              create: (context) {
                return _editBloc =
                    EditBloc(widget.usersRepository, ValidationRepository());
              },
              child: BlocListener<EditBloc, EditState>(
                listener: (context, state) {
                  if (state is CheckedState) {
                    if (state.invalidItems.isEmpty) {
                      _editBloc
                          ?.add(UpdateUserDataEvent(user: _initUserData()));
                    }
                  }
                  if (state is UserDataUpdatedState) {
                    widget.user = state.user;
                    final snackBar = SnackBar(
                      content: Text(DemoLocalizations.of(context)
                          .getTranslatedValue("updateSuccessMsg")),
                      action: SnackBarAction(
                        label: DemoLocalizations.of(context)
                            .getTranslatedValue("undo"),
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _userBloc.add(CheckSession());
                    widget.getEditedUser(widget.user);
                    Navigator.pop(context);
                  }
                },
                child: _render(),
              ),
            )));
  }
//---> Septerate 'build' function in functions

  BlocBuilder _render() {
    return BlocBuilder<EditBloc, EditState>(builder: (context, state) {
      return state is Updating
          ? _renderProgressBar()
          : _renderEditFormScreen(state);
    });
  }

  Widget _renderProgressBar() {
    return const ProgressBar(size: 0.6);
  }

  Widget _renderEditFormScreen(EditState state) {
    return Screen(
        [_renderForm(state)],
        _renderEditButton(context,
            DemoLocalizations.of(context).getTranslatedValue('edit'), state));
  }

  Widget _renderForm(EditState state) {
    return Column(children: [
      Header(text: DemoLocalizations.of(context).getTranslatedValue('edit')),
      Form(
          key: _formKey,
          child: Column(
            children: [
              _renderFirstnameTextField(state),
              _renderLastnameTextField(state),
              _renderBirthdateTextField(state),
              _renderUsernameTextField(state),
              _renderPasswordTextField(state),
              _renderEmailTextField(state),
              _renderMobileTextField(state),
            ],
          )),
    ]);
  }

//  ---> Maybe use one function for render fields ?
  Widget _renderFirstnameTextField(state) => CustomTextField(
        autovalidate: AutovalidateMode.always,
        customTextFieldController: _firstname,
        labelName: DemoLocalizations.of(context)
            .getTranslatedValue('fnameFieldLabel')
            .toLowerCase(),
        onTextFieldChange: () {
          _editBloc?.add(ValidateFirstNameEvent(firstName: _firstname.text));
        },
        txtType: TextInputType.name,
        validator: (value) => _validatorFirstname(state),
      );
  Widget _renderLastnameTextField(state) => CustomTextField(
        autovalidate: AutovalidateMode.always,
        labelName: DemoLocalizations.of(context)
            .getTranslatedValue('lnameFieldLabel')
            .toLowerCase(),
        txtType: TextInputType.name,
        onTextFieldChange: () =>
            _editBloc?.add(ValidateLastNameEvent(lastName: _lastname.text)),
        customTextFieldController: _lastname,
        validator: (value) => _validatorLastname(state),
      );
  Widget _renderBirthdateTextField(state) => CustomTextField(
        autovalidate: AutovalidateMode.always,
        labelName: DemoLocalizations.of(context)
            .getTranslatedValue('bdayFieldLabel')
            .toLowerCase(),
        onTextFieldChange: () => _editBloc?.add(ValidateBirthdateEvent(
            date: DateFormat(Localizations.localeOf(context).languageCode)
                .parse(_birthday.text))),
        txtType: TextInputType.datetime,
        isTapable: true,
        isEnable: true,
        onTextFieldTap: () => _showDatePicker(context),
        validator: (value) => _validatorBirthdate(state),
        customTextFieldController: _birthday,
      );
  Widget _renderUsernameTextField(state) => CustomTextField(
        autovalidate: AutovalidateMode.always,
        labelName: DemoLocalizations.of(context)
            .getTranslatedValue('usrnameFieldLabel')
            .toLowerCase(),
        txtType: TextInputType.text,
        onTextFieldChange: () =>
            {_editBloc?.add(ValidateUsernameEvent(username: _username.text))},
        customTextFieldController: _username,
        validator: (value) => _validatorUsername(state),
      );
  Widget _renderPasswordTextField(state) => CustomTextField(
        autovalidate: AutovalidateMode.always,
        labelName: DemoLocalizations.of(context)
            .getTranslatedValue('passwordFieldLabel')
            .toLowerCase(),
        isVisible: false,
        isTapable: false,
        onTextFieldChange: () =>
            _editBloc?.add(ValidatePasswordEvent(password: _password.text)),
        customTextFieldController: _password,
        icon: const Icon(Icons.visibility_off_outlined),
        validator: (value) => _validatorPassword(state),
      );
  Widget _renderEmailTextField(state) => CustomTextField(
        autovalidate: AutovalidateMode.always,
        labelName: DemoLocalizations.of(context)
            .getTranslatedValue('emailFieldLabel')
            .toLowerCase(),
        onTextFieldChange: () =>
            _editBloc?.add(ValidateEmailEvent(email: _email.text)),
        txtType: TextInputType.emailAddress,
        customTextFieldController: _email,
        validator: (value) => _validatorEmail(state),
      );
  Widget _renderMobileTextField(EditState state) => CustomTextField(
        autovalidate: AutovalidateMode.always,
        labelName: DemoLocalizations.of(context)
            .getTranslatedValue('phoneNumberFieldLabel')
            .toLowerCase(),
        txtType: TextInputType.text,
        customTextFieldController: _mobile,
        prefixWidget: _countryCodePicker(),
        onTextFieldChange: () =>
            _editBloc?.add(ValidatePhoneEvent(phone: _mobile.text)),
        validator: (value) => _validatorPhoneNumber(state),
      );

  Widget _renderEditButton(
      BuildContext context, String _title, EditState state) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Center(
          child: Stack(children: <Widget>[
            Center(
              child: RoundedButton(
                title: _title,
                onButtonClick: () {
                  _editBloc?.add(CheckForm(
                      userBeforeUpdate: userPrevUpdated,
                      user: _initUserData()));
                },
                btnColor: Styles.cntButtonActiveColor,
              ),
            ),
          ]),
        ));
  }

  // ---> Is need ctx here, if need set argument type
  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 200,
        color: Styles.whiteThemeColor,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate,
                minimumDate: _calendarFirstDate,
                maximumDate: _calendarLastDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (val) => _pickSelectedDate(val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //---> Function argument type is missing
  void _pickSelectedDate(DateTime date) {
    setState(() {
      _chosenDateTime = date;
      if (_chosenDateTime != _selectedDate) {
        //_chosenDateTime!=null &&
        _selectedDate = _chosenDateTime;
      }
      _birthday.text = dateToString(_selectedDate);
      _editBloc?.add(ValidateBirthdateEvent(date: _selectedDate));
    });
  }

//TODO DataTime Extension
  String dateToString(DateTime dateTime) {
    final DateFormat dateFormat =
        DateFormat.yMMMMd(Localizations.localeOf(context).languageCode);
    return dateFormat.format(dateTime);
  }

  String fromIso8601String(String? isoStr) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final DateFormat dateFormat = DateFormat.yMMMMd(languageCode);
    return dateFormat.format(DateTime.parse(isoStr ?? ""));
  }

  void _initTextFieldsData(UserModel user) {
    _firstname.text = currUser.firstName ?? "";
    _lastname.text = currUser.lastName ?? "";
    _birthday.text = fromIso8601String(currUser.birthdate);
    _username.text = currUser.username ?? "";
    _password.text = currUser.password ?? "";
    _email.text = currUser.email ?? "";
    _mobile.text = currUser.phone ?? "";
  }

  void _navigateCountryCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return CountryCode(countryValueNotifier: _country);
      }),
    );
  }

  Widget _countryCodePicker() {
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

  UserModel _initUserData() {
    return UserModel(
        id: widget.user.id,
        firstName: _firstname.text,
        lastName: _lastname.text,
        birthdate: a(),
        username: _username.text,
        password: _password.text,
        phone: _mobile.text,
        email: _email.text);
  }

  String a() {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(_selectedDate);
    return formattedDate;
  }

  String? _validatorPhoneNumber(EditState? state) {
    if (state is InvalidPhoneNumberState) {
      return _message(state.errorMsg);
    } else if (state is CheckedState) {
      if (state.invalidItems.containsKey(Fields.mobile)) {
        return _message(state.invalidItems[Fields.mobile] ?? "");
      }
    }
    return null;
  }

  String? _validatorEmail(EditState state) {
    if (state is InvalidEmailState) {
      return _message(state.errorMsg);
    }
    if (state is CheckedState) {
      if (state.invalidItems.containsKey(Fields.email)) {
        return _message(state.invalidItems[Fields.email] ?? "");
      }
    }
    return null;
  }

  String? _validatorPassword(EditState state) {
    if (state is InvalidPassword) {
      return _message(state.errorMsg);
    } else if (state is CheckedState) {
      if (state.invalidItems.containsKey(Fields.password)) {
        return _message(state.invalidItems[Fields.password] ?? "");
      }
    }
    return null;
  }

  String? _validatorFirstname(EditState state) {
    if (state is InvalidFirstname) {
      return _message(state.errorMsg ?? "") ?? _message(state.errorMsg ?? "");
    } else if (state is CheckedState) {
      if (state.invalidItems.containsKey(Fields.firstname)) {
        return _message(state.invalidItems[Fields.firstname] ?? "");
      }
    }
    return null;
  }

  //---> All logical functions should be after render functions+
  String? _validatorLastname(EditState state) {
    if (state is InvalidLastname) {
      return _message(state.errorMsg);
    } else if (state is CheckedState) {
      return state.invalidItems.containsKey(Fields.lastname)
          ? _message(state.invalidItems[Fields.lastname] ?? "")
          : null;
    } else {
      return null;
    }
  }

  String? _validatorBirthdate(EditState state) {
    if (state is InvalidBirthdate) {
      return _message(state.errorMsg);
    } else if (state is CheckedState) {
      if (state.invalidItems.containsKey(Fields.birthdate)) {
        return _message(state.invalidItems[Fields.birthdate] ?? "");
      }
    }
    return null;
  }

  String? _validatorUsername(EditState state) {
    if (state is InvalidUsername) {
      return _message(state.errorMsg);
    } else if (state is CheckedState) {
      return state.invalidItems.containsKey(Fields.username)
          ? _message(state.invalidItems[Fields.username] ?? "")
          : null;
    } else {
      return null;
    }
  }

  //---> override methods should be in top, after that render functions+

}
