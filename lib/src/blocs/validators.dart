import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:login_app/src/user_prefs/user_preferences.dart';

class Validators {
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) async {
    if (password.length >= 6) {
      sink.add(password);
    } else if (password.length > 0 && password.length < 6) {
      final prefs = UserPreferences();

      String data =
          await rootBundle.loadString('resources/lang/${prefs.language}.json');
      Map<String, dynamic> result = json.decode(data);
      sink.addError(result['password_error']);
    }
  });

  final validateConfirmPassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) async {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      final prefs = UserPreferences();

      String data =
          await rootBundle.loadString('resources/lang/${prefs.language}.json');
      Map<String, dynamic> result = json.decode(data);
      sink.addError(result['password_error']);
    }
  });

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink) async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      if (email != '') {
        final prefs = UserPreferences();

        String data = await rootBundle
            .loadString('resources/lang/${prefs.language}.json');
        Map<String, dynamic> result = json.decode(data);
        sink.addError(result['email_error']);
      }
    }
  });
}
