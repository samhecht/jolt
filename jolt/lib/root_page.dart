import 'package:flutter/material.dart';
import './authentication.dart';
import './discovery_feed.dart';
import './login_signup_root.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage({this.auth});
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      print('are we getting here?');
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  @override
  void initState() {
    print('in init state $authStatus');
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return Container();
        break;
      case AuthStatus.LOGGED_IN:
        return DiscoveryFeed(
          username: 'Sammy',
          userId: _userId,
          auth: widget.auth,
          logoutCallback: logoutCallback,
        );
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignupRoot(
          loginCallback: loginCallback,
          auth: widget.auth,
        );
        break;
      default:
        return Container();
    }
  }
}
