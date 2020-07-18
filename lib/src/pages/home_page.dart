import 'package:flutter/material.dart';
import 'package:login_app/src/services/authentication.dart';
import 'package:login_app/src/blocs/provider.dart';
import 'package:login_app/src/internationalization/localizations_util.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of(context);

    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              LocalizationsUtil.of(context).trans('hello_world'),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 35.0),
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                await _auth.signOut();

                _bloc.resetBloc();

                Navigator.pushReplacementNamed(context, 'login');
              },
              iconSize: 60.0,
            )
          ],
        )),
      ),
    );
  }
}
