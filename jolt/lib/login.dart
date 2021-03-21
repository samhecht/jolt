import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import './authentication.dart';
import './size_config.dart';

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
  String email = '';

  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        width: SizeConfig.blockSizeHorizontal * 80,
        margin: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 10,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'email@email.com',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'password',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                ),
                CupertinoButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        print('username: ' + email + ', password: ' + password);
                        String userId =
                            await widget.auth.signIn(email.trim(), password);
                        print('logging in ' + userId);
                        widget.loginCallback();
                      } catch (e) {
                        print('Error logging in: ' + e.message);
                      }
                    } else {
                      print('form invalid');
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
        ),
      ),
    );
  }
}
