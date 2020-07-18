import 'package:flutter/cupertino.dart';
import 'package:login_app/src/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:login_app/src/internationalization/localizations_util.dart';
import 'package:login_app/src/blocs/provider.dart';
import 'package:login_app/src/widgets/background_login.dart';
import 'package:login_app/src/services/authentication.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[BackgroundLogin(), _LoginForm()],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final Auth auth = Auth();

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 180),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                LocalizationsUtil.of(context).trans('welcome'),
                style: TextStyle(color: Colors.white, fontSize: 50.0),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              LocalizationsUtil.of(context).trans('please_login'),
              style: TextStyle(color: Colors.white, fontSize: 17.0),
            ),
            SizedBox(
              height: 35,
            ),
            _EmailField(bloc),
            SizedBox(
              height: 35,
            ),
            _PasswordField(bloc),
            SizedBox(
              height: 1,
            ),
            _ForgetPassword(),
            SizedBox(
              height: 20,
            ),
            LoginButton(bloc, auth),
            SizedBox(
              height: 20,
            ),
            _SignUp()
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField(this._bloc);

  final LoginBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.userNameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 55.0),
            child: TextField(
              autocorrect: false,
              style: TextStyle(fontSize: 16, color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                hintText: LocalizationsUtil.of(context).trans('email'),
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                prefixIcon: Icon(Icons.alternate_email, color: Colors.white),
                errorText: snapshot.error,
                errorStyle: TextStyle(color: Colors.red, fontSize: 16.0),
              ),
              onChanged: _bloc.changeUserName,
            ),
          );
        });
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField(this._bloc);

  final LoginBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 55.0),
            child: TextField(
              obscureText: true,
              autocorrect: false,
              style: TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                hintText: LocalizationsUtil.of(context).trans('password'),
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                errorText: snapshot.error,
                errorStyle: TextStyle(color: Colors.red, fontSize: 16.0),
              ),
              onChanged: _bloc.changePassword,
            ),
          );
        });
  }
}

class LoginButton extends StatefulWidget {
  const LoginButton(this._bloc, this._auth);

  final LoginBloc _bloc;
  final Auth _auth;

  @override
  _LoginButton createState() => _LoginButton();
}

class _LoginButton extends State<LoginButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget._bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 110.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9.0),
                height: 45.0,
                child: Text(
                  _isLoading
                      ? LocalizationsUtil.of(context).trans('loading') + '...'
                      : LocalizationsUtil.of(context).trans('log_in'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 10.0,
              color: _isLoading
                  ? Color.fromRGBO(111, 126, 136, 1)
                  : Color.fromRGBO(0, 149, 239, 0.8),
              textColor: Colors.white,
              onPressed: snapshot.hasData
                  ? () async {
                      setState(() {
                        _isLoading = true;
                      });
                      dynamic result;

                      try {
                        result = await widget._auth.signIn(
                            widget._bloc.userName, widget._bloc.password);
                        Navigator.pushReplacementNamed(context, 'home');
                      } catch (e) {
                        print(e.toString());
                        String errorCode = "error_operation_not_allowed";

                        if (e.code == 'ERROR_INVALID_EMAIL' ||
                            e.code == 'ERROR_WRONG_PASSWORD' ||
                            e.code == 'ERROR_USER_NOT_FOUND' ||
                            e.code == 'ERROR_USER_DISABLED' ||
                            e.code == 'ERROR_TOO_MANY_REQUESTS' ||
                            e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                          errorCode = e.code.toLowerCase();
                        }

                        if (Platform.isIOS) {
                          _showCupertinoDialog(context, 'embarrassing_error',
                              errorCode, 'try_again');
                        } else {
                          _showMaterialDialog(context, 'embarrassing_error',
                              errorCode, 'try_again');
                        }
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    }
                  : null,
            ),
          );
        });
  }
}

class _ForgetPassword extends StatelessWidget {
  const _ForgetPassword();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 177.0),
            child: Text(
              LocalizationsUtil.of(context).trans('forget_password'),
              style: TextStyle(
                  color: Color.fromRGBO(0, 149, 239, 0.8),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        if (Platform.isIOS) {
          _showCupertinoDialog(context, 'embarrassing_error',
              'error_operation_not_allowed', 'ok');
        } else {
          _showMaterialDialog(context, 'embarrassing_error',
              'error_operation_not_allowed', 'ok');
        }
      },
    );
  }
}

class _SignUp extends StatelessWidget {
  const _SignUp();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            LocalizationsUtil.of(context).trans('firs_time') + " ",
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          Text(
            LocalizationsUtil.of(context).trans('sign_up'),
            style: TextStyle(
                color: Color.fromRGBO(0, 149, 239, 0.8),
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () => Navigator.pushReplacementNamed(context, 'signup_1'),
    );
  }
}

_showMaterialDialog(
    BuildContext context, String title, String msj, String buttonLabel) {
  showDialog(
      context: context,
      builder: (context) {
        return Theme(
            data: ThemeData.light(),
            child: AlertDialog(
              title: Text(
                title != '' ? LocalizationsUtil.of(context).trans(title) : '',
                style: TextStyle(color: Colors.black),
              ),
              content: Text(LocalizationsUtil.of(context).trans(msj),
                  style: TextStyle(color: Colors.black87)),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    LocalizationsUtil.of(context).trans(buttonLabel),
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      });
}

_showCupertinoDialog(
    BuildContext context, String title, String msj, String buttonLabel) {
  showDialog(
      context: context,
      builder: (context) {
        return Theme(
            data: ThemeData.light(),
            child: CupertinoAlertDialog(
              title: Text(
                title != '' ? LocalizationsUtil.of(context).trans(title) : '',
                style: TextStyle(color: Colors.black),
              ),
              content: Text(LocalizationsUtil.of(context).trans(msj),
                  style: TextStyle(color: Colors.black87)),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    LocalizationsUtil.of(context).trans(buttonLabel),
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      });
}
