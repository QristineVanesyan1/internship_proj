import 'package:flutter/material.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:intl/intl.dart';

class UserCard extends StatefulWidget {
  const UserCard({required this.user});
  final UserModel user;

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "${widget.user.lastName} ${widget.user.firstName}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Column(
          children: <Widget>[
            Text(
              "id: ${widget.user.id}",
              style: const TextStyle(color: Colors.red),
            ),
            Text(
              '${DemoLocalizations.of(context).getTranslatedValue('usrnameFieldLabel')}: ${widget.user.username}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              '${DemoLocalizations.of(context).getTranslatedValue('bdayFieldLabel')}: ${fromIso8601String(widget.user.birthdate)}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              '${DemoLocalizations.of(context).getTranslatedValue('emailFieldLabel')}: ${widget.user.email}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              '${DemoLocalizations.of(context).getTranslatedValue('phoneNumberFieldLabel')}: ${widget.user.phone}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              '${DemoLocalizations.of(context).getTranslatedValue('passwordFieldLabel')}: ${widget.user.password}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ],
    );
  }

  String? fromIso8601String(String? isoStr) {
    String dateStr = "";
    if (isoStr != null) {
      final DateTime myDatetime = DateTime.parse(isoStr);

      final String languageCode = Localizations.localeOf(context).languageCode;
      final DateFormat dateFormat = DateFormat.yMMMMd(languageCode);
      dateStr = dateFormat.format(myDatetime);
    }
    return dateStr;
  }
}
