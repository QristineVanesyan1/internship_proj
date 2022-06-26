import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/rounded_button.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/screens/edit/edit.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  Profile({required this.user});
  UserModel user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserBloc authBloc;
  @override
  void initState() {
    authBloc = BlocProvider.of<UserBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(body: _renderUserPage(authBloc)));
  }

  BlocBuilder _renderUserPage(UserBloc authBloc) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _renderProfilePageUserBar(),
              _renderPersonalData(),
            ],
          ),
          _renderContinueButton(authBloc),
        ],
      );
    });
  }

  Widget _renderProfilePageUserBar() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Styles.headerColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 100,
          ),
          Text(
            widget.user.username ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _renderPersonalData() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "${DemoLocalizations.of(context).getTranslatedValue('fnameFieldLabel')}: ${widget.user.firstName}",
                style: Styles.userDataText,
              ),
            ],
          ),
          Text(
            "${DemoLocalizations.of(context).getTranslatedValue('lnameFieldLabel')}: ${widget.user.lastName}",
            style: Styles.userDataText,
          ),
          Text(
            "${DemoLocalizations.of(context).getTranslatedValue('bdayFieldLabel')}: ${fromIso8601String(widget.user.birthdate)}",
            style: Styles.userDataText,
          ),
          Text(
            "${DemoLocalizations.of(context).getTranslatedValue('emailFieldLabel')}: ${widget.user.email} ${DemoLocalizations.of(context).getTranslatedValue('phoneNumberFieldLabel')}: ${widget.user.phone}",
            style: Styles.userDataText,
          ),
          Text(
            "${DemoLocalizations.of(context).getTranslatedValue('passwordFieldLabel')}: ${widget.user.password}",
            style: Styles.userDataText,
          ),
        ],
      ),
    );
  }

  String fromIso8601String(String? isoStr) {
    final String languageCode = Localizations.localeOf(context).languageCode;
    final DateFormat dateFormat = DateFormat.yMMMMd(languageCode);
    return dateFormat.format(DateTime.parse(isoStr ?? ""));
  }

  Widget _renderContinueButton(UserBloc authBloc) {
    return Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.only(bottom: 15),
        //   child: RoundedButton(
        //     title: DemoLocalizations.of(context)
        //         .getTranslatedValue('delete account'),
        //     btnColor: Styles.errorMessageColor,
        //     onButtonClick: () => removeUser(),
        //   ),
        // ),
        Container(
          padding: const EdgeInsets.only(bottom: 15),
          child: RoundedButton(
            title: DemoLocalizations.of(context).getTranslatedValue('edit'),
            btnColor: Styles.cntButtonActiveColor,
            onButtonClick: () => editData(),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 15),
          child: RoundedButton(
              title:
                  DemoLocalizations.of(context).getTranslatedValue('logoutBtn'),
              btnColor: Styles.cntButtonActiveColor,
              onButtonClick: () async {
                authBloc.add(DestroySession());
                authBloc.add(CheckSession());
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ),
      ],
    );
  }

  void removeUser() {
    authBloc.add(DeleteUserEvent());
    authBloc.add(CheckSession());
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void editData() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditUserScreen(
                user: widget.user,
                usersRepository: authBloc.repository,
                loadUsers: () {
                  authBloc.add(const LoadUsersEvent());
                },
                getEditedUser: (UserModel userModel) {
                  widget.user = userModel;
                },
              )),
    );
  }
}
