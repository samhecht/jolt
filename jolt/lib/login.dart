import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import './authentication.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback loginCallback;
  final BaseAuth auth;
  final VoidCallback toggleLoginScreen;
  LoginScreen({
    @required this.loginCallback,
    @required this.auth,
    @required this.toggleLoginScreen,
  });
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discovery Feed'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: Text(
                'Login to Jolt!',
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.only(bottom: 10, top: 10),
            ),
            Padding(
              child: CupertinoTextField(
                onChanged: (value) {
                  username = value;
                },
              ),
              padding: EdgeInsets.only(bottom: 5),
            ),
            CupertinoTextField(
              onChanged: (value) {
                password = value;
              },
            ),
            CupertinoButton(
              child: Text('Submit'),
              onPressed: () async {
                try {
                  print('username: ' + username + ', password: ' + password);
                  String userId =
                      await widget.auth.signIn(username.trim(), password);
                  print('logging in ' + userId);
                  widget.loginCallback();
                } catch (e) {
                  print('Error logging in: ' + e.message);
                }
              },
            ),
            CupertinoButton(
              child: Text('Don\'t have an account? Sign up!'),
              onPressed: () {
                widget.toggleLoginScreen();
              },
            ),
          ],
        ),
      ),
    );
  }
}
