import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'package:login_app/src/user_prefs/user_preferences.dart';
import 'package:login_app/src/blocs/validators.dart';

class SignUpBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();

  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get confirmPasswordStream =>
      _confirmPasswordController.stream.transform(validatePassword);

  Stream<bool> get formValidStream2 => Observable.combineLatest3(
          emailStream, passwordStream, confirmPasswordStream, (e, p, cp) {
        if ((p != cp) || (e == '')) {
          final prefs = UserPreferences();

          Future<String> data =
              rootBundle.loadString('resources/lang/${prefs.language}.json');
          data.then((d) {
            Map<String, dynamic> result = json.decode(d);

            if (p != cp) {
              _confirmPasswordController.sink
                  .addError(result['password_dif_error']);
            }
            if (e == '') {
              _emailController.sink.addError(result['email_error']);
            }
          });

          return null;
        }
        return true;
      });

  // Get & Set
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword =>
      _confirmPasswordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get confirmPassword => _confirmPasswordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _confirmPasswordController?.close();
  }
}
