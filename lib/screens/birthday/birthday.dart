import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/data/repository/validation_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/custom_textfield.dart';
import 'package:snapchat_proj/global/widgets/header.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/global/widgets/screen.dart';
import 'package:snapchat_proj/screens/username/username.dart';

import 'birthday_bloc/bloc/birthday_bloc.dart';

class Birthday extends StatefulWidget {
  const Birthday({required this.user, required this.usersRepository});
  final UserModel user;
  final UserRepository usersRepository;

  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  late DateTime _chosenDateTime;
  final TextEditingController _birthdayTextFieldController =
      TextEditingController();

  late BirthdayBloc _birthdayBloc;

  DateTime get _calendarFirstDate => DateTime(_currentDate.year - 110);
  DateTime get _calendarLastDate => DateTime.now();

  DateTime _selectedDate = DateTime(
      DateTime.now().year - 16, DateTime.now().month, DateTime.now().day);

  DateTime get _currentDate => DateTime.now();

  DateTime get _userBirthday => _selectedDate;
  set _userBirthday(DateTime val) {
    widget.user.birthdate = _selectedDate.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String languageCode = Localizations.localeOf(context).languageCode;
    final DateFormat dateFormat = DateFormat.yMMMMd(languageCode);
    _birthdayTextFieldController.text = dateFormat.format(_selectedDate);
  }

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
        body: BlocProvider<BirthdayBloc>(
          create: (context) {
            return _birthdayBloc = BirthdayBloc(ValidationRepository());
          },
          child: BlocListener<BirthdayBloc, BirthdayState>(
              listener: (context, state) {}, child: _render(context)),
        ));
  }

  BlocBuilder _render(BuildContext ctx) {
    return BlocBuilder<BirthdayBloc, BirthdayState>(builder: (context, state) {
      _birthdayBloc.add(CheckAge(selectedDate: _selectedDate));
      return Screen(
          [
            _renderBirthDayForm(state),
          ],
          Column(
            children: [
              _renderContinue(state),
              Container(
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
                          onDateTimeChanged: (val) {
                            setState(() {
                              _chosenDateTime = val;
                              if ( //_chosenDateTime != null &&
                                  _chosenDateTime != _selectedDate) {
                                _selectedDate = _chosenDateTime;
                              }
                              final String languageCode =
                                  Localizations.localeOf(context).languageCode;
                              final DateFormat dateFormat =
                                  DateFormat.yMMMMd(languageCode);
                              _birthdayTextFieldController.text =
                                  dateFormat.format(
                                      _selectedDate); //TODO Set in extension
                              _birthdayBloc
                                  .add(CheckAge(selectedDate: _userBirthday));
                            });
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }

  Widget _renderBirthDayForm(BirthdayState state) {
    return Column(
      children: [
        Header(
          text:
              DemoLocalizations.of(context).getTranslatedValue('bdayPageTitle'),
        ),
        CustomTextField(
          onTextFieldChange: () {},
          labelName: DemoLocalizations.of(context)
              .getTranslatedValue('bdayFieldLabel')
              .toUpperCase(),
          isTapable: true,
          isEnable: true,
          onTextFieldTap: () {
            //_showDatePicker(context);
            //  _selectDate(context);
          },
          customTextFieldController: _birthdayTextFieldController,
          autovalidate: AutovalidateMode.disabled,
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: _renderMessage(state),
        )
      ],
    );
  }

  Widget _renderMessage(BirthdayState state) {
    if (state is UnacceptableAge) {
      return Text(
        DemoLocalizations.of(context).getTranslatedValue('unacceptableAgeMsg'),
        style: Styles.errorMessageStyle,
      );
    }
    return const Text("");
  }

  Widget _renderContinue(BirthdayState state) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Center(
            child: Stack(children: <Widget>[
          Center(
            child: RoundedButton(
                title: DemoLocalizations.of(context)
                    .getTranslatedValue('cntButtonLabel'),
                onButtonClick: () {
                  if (state is AcceptableAge) {
                    _userBirthday = _selectedDate;
                    _navigate(context);
                  } //TODO GENERATE USERNAME
                },
                btnColor: (state is AcceptableAge)
                    ? Styles.cntButtonActiveColor
                    : Styles.cntButtonInactiveColor),
          )
        ])));
  }

  Future<void> _navigate(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return BlocProvider.value(
        value: BlocProvider.of<UserBloc>(context),
        child: Username(
          user: widget.user,
          userRepository: widget.usersRepository,
        ),
      );
    }));
  }

  @override
  void dispose() {
    _birthdayBloc.close();
    super.dispose();
  }
}
