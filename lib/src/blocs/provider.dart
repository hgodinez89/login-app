import 'package:flutter/material.dart';

import 'package:login_app/src/blocs/login_bloc.dart';
import 'package:login_app/src/blocs/signup_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final _signUpBloc = SignUpBloc();

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = Provider._internal(key: key, child: child);
    }

    return _instance;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static SignUpBloc signUpBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._signUpBloc;
  }
}
