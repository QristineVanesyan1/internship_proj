import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/button.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/screens/edit/bloc/edit_bloc.dart';
import 'package:snapchat_proj/screens/login/log_in.dart';
import 'package:snapchat_proj/screens/profile/profile.dart';
import 'package:snapchat_proj/screens/sign_up/sign_up.dart';
import 'package:snapchat_proj/screens/user_list/user_list.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserBloc userBloc;
  late UserRepository _repository;
  Widget get _themeIcon => Image.asset(
        'assets/images/logo.png',
        width: 120,
        height: 120,
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    _repository = userBloc.repository;
    userBloc.add(CheckSession());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _render());
  }

  BlocBuilder _render() {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserInSession) {
        return Profile(user: state.user);
      } else if (state is UserNotInSession) {
        return Container(
          height: double.infinity,
          color: Styles.themeColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 120),
                child: _themeIcon,
              ),
              Column(
                children: [
                  Button(
                    title: DemoLocalizations.of(context)
                        .getTranslatedValue('users')
                        .toLowerCase(),
                    color: Styles.usersBtnColor,
                    toPage: UserList(usersRepository: _repository),
                  ),
                  Button(
                    title: DemoLocalizations.of(context)
                        .getTranslatedValue('login')
                        .toLowerCase(),
                    color: Styles.loginBtnColor,
                    toPage: Login(usersRepository: _repository),
                  ),
                  Button(
                    title: DemoLocalizations.of(context)
                        .getTranslatedValue('signUp')
                        .toLowerCase(),
                    toPage: SignUp(usersRepository: _repository),
                    color: Styles.signUpBtnColor,
                  )
                ],
              )
            ],
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
