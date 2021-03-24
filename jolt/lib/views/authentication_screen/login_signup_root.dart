import 'package:flutter/material.dart';
import 'package:jolt/models/messages_model.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/authentication_screen/login.dart';
import 'package:jolt/views/authentication_screen/signup.dart';
import 'package:jolt/models/interactions_model.dart';
import 'package:jolt/models/nearby_users_model.dart';
import 'package:jolt/views/discovery_screen/discovery_feed.dart';
import 'package:jolt/models/authentication_model.dart';

// This class displays the login/signup pages
// In the case that a user is already authenticated
// it will redirect to the discovery feed screen
class LoginSignupRoot extends StatefulWidget {
  static const routeName = '/login';

  LoginSignupRoot();

  @override
  _LoginSignupRootState createState() => _LoginSignupRootState();
}

class _LoginSignupRootState extends State<LoginSignupRoot> {
  bool onLoginScreen = true;
  void toggleLoginScreen() {
    setState(
      () {
        onLoginScreen = !onLoginScreen;
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void checkAuth(BuildContext context) async {
    String userId = await Provider.of<AuthenticationModel>(
      context,
      listen: false,
    ).checkAuth();

    if (userId.isNotEmpty) {
      // something like subscribe or start would probably be more clear
      Provider.of<InteractionsModel>(
        context,
        listen: false,
      ).userId = userId;
      Provider.of<NearbyUsersModel>(
        context,
        listen: false,
      ).userId = userId;
      Provider.of<MessagesModel>(
        context,
        listen: false,
      ).userId = userId;
      Navigator.pushNamed(
        context,
        DiscoveryFeed.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAuth(context);

    if (onLoginScreen) {
      return LoginScreen(
        toggleLoginScreen: toggleLoginScreen,
      );
    } else {
      return SignUpScreen(
        toggleLoginScreen: toggleLoginScreen,
      );
    }
  }
}
