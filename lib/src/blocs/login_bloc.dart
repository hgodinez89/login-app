import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:login_app/src/blocs/validators.dart';

class LoginBloc with Validators {
  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get userNameStream =>
      _userNameController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get formValidStream =>
      Observable.combineLatest2(userNameStream, passwordStream, (e, p) => true);

  // Get & Set
  Function(String) get changeUserName => _userNameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  String get userName => _userNameController.value;
  String get password => _passwordController.value;

  dispose() {
    _userNameController?.close();
    _passwordController?.close();
  }

  resetBloc() {
    _userNameController.value = "";
    _passwordController.value = "";
  }
}
