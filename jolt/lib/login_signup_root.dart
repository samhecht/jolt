import 'package:flutter/material.dart';
import './authentication.dart';
import './login.dart';
import './signup.dart';

// this class is a container for login and signup
// this ensures that root_page stays mounted for authentication
// ie, using Navigator.push mounts a new widget, and
// makes it so that root_page can't redirect on authentication
class LoginSignupRoot extends StatefulWidget {
  final VoidCallback loginCallback;
  final BaseAuth auth;

  LoginSignupRoot({
    this.loginCallback,
    this.auth,
  });

  @override
  _LoginSignupRootState createState() => _LoginSignupRootState();
}

class _LoginSignupRootState extends State<LoginSignupRoot> {
  // to check if we're on login screen or signup
  bool onLoginScreen = true;
  void toggleLoginScreen() {
    setState(() {
      onLoginScreen = !onLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onLoginScreen) {
      return LoginScreen(
        auth: widget.auth,
        loginCallback: widget.loginCallback,
        toggleLoginScreen: toggleLoginScreen,
      );
    }
    return SignUpScreen(
      auth: widget.auth,
      loginCallback: widget.loginCallback,
      toggleLoginScreen: toggleLoginScreen,
    );
  }
}
