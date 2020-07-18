import 'package:login_app/src/blocs/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:login_app/src/pages/home_page.dart';

import 'package:login_app/src/user_prefs/user_preferences.dart';
import 'package:login_app/src/pages/login_page.dart';
import 'package:login_app/src/pages/signup_page_1.dart';
import 'package:login_app/src/internationalization/localizations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new UserPreferences();
  await prefs.initPrefs();

  runApp(MyApp(prefs));
}

class MyApp extends StatelessWidget {
  MyApp(this.prefs);

  final prefs;

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        supportedLocales: [const Locale('es', 'US'), const Locale('en', 'US')],
        localizationsDelegates: [
          const LocalizationsUtilDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          for (Locale supportedLocale in supportedLocales) {
            // print("supportedLocale.languageCode " +
            //     supportedLocale.languageCode +
            //     " locale.languageCode " +
            //     locale.languageCode);
            // print("supportedLocale.countryCode " +
            //     supportedLocale.countryCode +
            //     " locale.countryCode " +
            //     locale.countryCode);
            if (supportedLocale.languageCode == locale.languageCode) {
              prefs.language = locale.languageCode;
              // print(locale.languageCode);
              return supportedLocale;
            }
          }

          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'signup_1': (BuildContext context) => SignUpPage1(),
          'home': (BuildContext context) => HomePage(),
        },
        theme: ThemeData.dark(),
      ),
    );
  }
}
