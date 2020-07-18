import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:login_app/src/internationalization/localizations_util.dart';
import 'package:login_app/src/services/authentication.dart';
import 'package:login_app/src/widgets/background_login.dart';
import 'package:login_app/src/blocs/signup_bloc.dart';
import 'package:login_app/src/blocs/provider.dart';

class SignUpPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SignUpBloc bloc = Provider.signUpBloc(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[BackgroundLogin(), SignUpForm(bloc)],
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm(this._bloc);

  final SignUpBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final Auth auth = Auth();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          _BackButton(),
          SizedBox(
            height: 35,
          ),
          _TitleSignUp(),
          SizedBox(
            height: 35,
          ),
          _EmailField(_bloc),
          SizedBox(
            height: 30,
          ),
          _PasswordField(_bloc),
          SizedBox(
            height: 30,
          ),
          _ConfirmPasswordField(_bloc),
          SizedBox(
            height: 50,
          ),
          CreateAccountButton(_bloc, auth),
          SizedBox(
            height: 20,
          ),
          _LogIn()
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33),
            child: IconButton(
              icon: Icon(Icons.keyboard_backspace, color: Colors.white),
              iconSize: 35.0,
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            )),
      ],
    );
  }
}

class _TitleSignUp extends StatelessWidget {
  const _TitleSignUp();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 45.0, right: 118.0),
          child: Text(
            LocalizationsUtil.of(context).trans('new') +
                '\n' +
                LocalizationsUtil.of(context).trans('account'),
            style: TextStyle(color: Colors.white, fontSize: 32.0),
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: Text(
                    ' / ',
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 26.0),
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                LocalizationsUtil.of(context).trans('steps'),
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField(this._bloc);

  final SignUpBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.emailStream,
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
              onChanged: _bloc.changeEmail,
            ),
          );
        });
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField(this._bloc);

  final SignUpBloc _bloc;

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

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField(this._bloc);

  final SignUpBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.confirmPasswordStream,
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
                hintText:
                    LocalizationsUtil.of(context).trans('confirm_password'),
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                errorText: snapshot.error,
                errorStyle: TextStyle(color: Colors.red, fontSize: 16.0),
              ),
              onChanged: _bloc.changeConfirmPassword,
            ),
          );
        });
  }
}

class CreateAccountButton extends StatefulWidget {
  const CreateAccountButton(this._bloc, this._auth);

  final SignUpBloc _bloc;
  final Auth _auth;

  @override
  _CreateAccountButton createState() => _CreateAccountButton();
}

class _CreateAccountButton extends State<CreateAccountButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget._bloc.formValidStream2,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9.0),
                height: 45.0,
                child: Text(
                  _isLoading
                      ? LocalizationsUtil.of(context).trans('loading') + '...'
                      : LocalizationsUtil.of(context).trans('create_account'),
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
                        result = await widget._auth
                            .signUp(widget._bloc.email, widget._bloc.password);

                        if (Platform.isIOS) {
                          _showCupertinoDialog(
                              'good_news', 'create_account_ok', 'ok', false);
                        } else {
                          _showMaterialDialog(
                              'good_news', 'create_account_ok', 'ok', false);
                        }
                      } catch (e) {
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
                          _showCupertinoDialog('embarrassing_error', errorCode,
                              'try_again', true);
                        } else {
                          _showMaterialDialog('embarrassing_error', errorCode,
                              'try_again', true);
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

  _showMaterialDialog(
      String title, String msj, String buttonLabel, bool error) {
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

                      if (!error) {
                        Navigator.pushReplacementNamed(context, 'login');
                      }
                    },
                  )
                ],
              ));
        });
  }

  _showCupertinoDialog(
      String title, String msj, String buttonLabel, bool error) {
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

                      if (!error) {
                        Navigator.pushReplacementNamed(context, 'login');
                      }
                    },
                  )
                ],
              ));
        });
  }
}

class _LogIn extends StatelessWidget {
  const _LogIn();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            LocalizationsUtil.of(context).trans('not_firs_time') + " ",
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
      onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
    );
  }
}
