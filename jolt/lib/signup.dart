import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import './authentication.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback loginCallback;
  final BaseAuth auth;
  final VoidCallback toggleLoginScreen;
  SignUpScreen({
    @required this.loginCallback,
    @required this.auth,
    @required this.toggleLoginScreen,
  });
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String username = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: Text(
                'Sign up for Jolt!',
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
                      await widget.auth.signUp(username.trim(), password);
                  print('signed up user ' + userId);
                  widget.loginCallback();
                } catch (e) {
                  print(e);
                }
              },
            ),
            CupertinoButton(
              child: Text('Already have an account? Login!'),
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
