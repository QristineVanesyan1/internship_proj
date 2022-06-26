import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
class RichLink extends StatefulWidget {
  @override
  _RichLinkState createState() => _RichLinkState();
}

class _RichLinkState extends State<RichLink> {
  final String _privacyPolicyUrl =
      'https://snap.com/en-US/privacy/privacy-policy';
  final String _termsUrl = 'https://snap.com/en-US/terms';
  @override
  Widget build(BuildContext context) {
    return RichText(
          text: TextSpan(
            text: DemoLocalizations.of(context)
                .getTranslatedValue('linkSubSentence1'),
            style: Styles.subTextStyle,
            children: <TextSpan>[
              TextSpan(
                  text: DemoLocalizations.of(context)
                      .getTranslatedValue('linkSubSentence2'),
                  style: Styles.subTextLinkStyle,
                  recognizer: TapGestureRecognizer()..onTap = () {
                      _launchURL(_privacyPolicyUrl);
                    }),
              TextSpan(
                text: DemoLocalizations.of(context)
                    .getTranslatedValue('linkSubSentence3'),
              ),
              TextSpan(
                  text: DemoLocalizations.of(context)
                      .getTranslatedValue('linkSubSentence4'),
                  style: Styles.subTextLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL(_termsUrl);
                    }),
              TextSpan(
                text: DemoLocalizations.of(context)
                    .getTranslatedValue('linkSubSentence5'),
              )
            ],
          ),
        );
  }
    Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}