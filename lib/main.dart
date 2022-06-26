import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:snapchat_proj/global/blocs/user_bloc/user_bloc.dart';
import 'package:snapchat_proj/localization/localization.dart';
import 'package:snapchat_proj/screens/home/home.dart';
import 'package:snapchat_proj/data/repository/user_repository.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'global/theme/styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SnapchatApp());
}

class SnapchatApp extends StatefulWidget {
  const SnapchatApp();

  @override
  _SnapchatAppState createState() => _SnapchatAppState();
}

class _SnapchatAppState extends State<SnapchatApp> {
  _SnapchatAppState();

  @override
  void initState() {
    super.initState();
  }

  void _test() async {
    print("start");
    String value = await rootBundle.loadString('assets/json/country-codes.json',
        cache: true);
    print('end');
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    _test();
    return BlocProvider<UserBloc>(
      create: (context) {
        return UserBloc(UserRepository());
      },
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) =>
            DemoLocalizations.of(context).getTranslatedValue("appTitle"),
        localizationsDelegates: const [
          DemoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
        ],
        theme: ThemeData(
          primarySwatch: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Styles.whiteThemeColor,
        ),
        home: const HomePage(),
      ),
    );
  }
  // final ReceivePort _receivePort;
  // Isolate _isolate;

  // void _runCalculation() {
  //   // Load the JSON string. This is done in the main isolate because spawned
  //   // isolates do not have access to the root bundle. However, the loading
  //   // process is asynchronous, so the UI will not block while the file is
  //   // loaded.
  //   rootBundle.loadString('services/data.json').then<void>((String data) {
  //     if (isRunning) {
  //       final CalculationMessage message = CalculationMessage(data, _receivePort.sendPort);
  //       // Spawn an isolate to JSON-parse the file contents. The JSON parsing
  //       // is synchronous, so if done in the main isolate, the UI would block.
  //       Isolate.spawn<CalculationMessage>(_calculate, message).then<void>((Isolate isolate) {
  //         if (!isRunning) {
  //           isolate.kill(priority: Isolate.immediate);
  //         } else {
  //           _state = CalculationState.calculating;
  //           _isolate = isolate;
  //         }
  //       });
  //     }
  //   });
  // }
}
