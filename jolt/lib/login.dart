import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import './authentication.dart';
import './signup.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback loginCallback;
  final BaseAuth auth;
  LoginScreen({@required this.loginCallback, @required this.auth});
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
                  print('signed up user ' + userId);
                  widget.loginCallback();
                } catch (e) {
                  print(e);
                }
              },
            ),
            CupertinoButton(
              child: Text('Don\'t have an account? Sign up!'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpScreen(
                            auth: widget.auth,
                            loginCallback: widget.loginCallback,
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
