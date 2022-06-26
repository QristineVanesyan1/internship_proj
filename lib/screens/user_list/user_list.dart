import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/empty_list.dart';
import 'package:snapchat_proj/global/widgets/error.dart';

import 'package:snapchat_proj/global/widgets/progress_bar.dart';
import 'package:snapchat_proj/global/widgets/user_card.dart';

class UserList extends StatefulWidget {
  const UserList({required this.usersRepository});
  final UserRepository usersRepository;

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(const LoadUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    //TODO check
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(const LoadUsersEvent());
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                _userBloc.add(CheckSession());
                Navigator.of(context).pop();
              }),
          iconTheme: IconThemeData(color: Styles.backIconColor),
          backgroundColor: Styles.whiteThemeColor,
          elevation: 0,
        ),
        body: _render());
  }

  BlocBuilder _render() {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is LoadedUsersState) {
        if (state.loadedUsers.isNotEmpty) {
          return RefreshIndicator(
              onRefresh: () => _pullRefresh(),
              child: ListView.builder(
                  itemCount: state.loadedUsers.length,
                  itemBuilder: (context, index) => Card(
                        elevation: 5,
                        color: Styles.userCardColor,
                        child: ListTile(
                          title: UserCard(
                            user: state.loadedUsers[index],
                          ),
                          //trailing: const Icon(Icons.clear),
                        ),
                      )));
        } else {
          return EmptyListWidget();
        }
      } else if (state is LoadingState || state is UserNotInSession) {
        //TODO
        return const ProgressBar(
          size: 0.6,
        );
      } else {
        return WarningWidget();
      }
    });
  }

  Future<void> _pullRefresh() async {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(const LoadUsersEvent());
  }
}
