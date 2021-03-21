import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jolt/models/interactions_model.dart';
import 'package:jolt/models/nearby_users_model.dart';
import 'package:provider/provider.dart';

import './authentication.dart';
import './discovery_feed.dart';
import './login_signup_root.dart';
import './database_service.dart';
import 'main.dart';

class RootPage extends StatelessWidget {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final BaseAuth auth = Auth();

  @override
  Widget build(BuildContext context) {
    var logoutCallback = () {
      Provider.of<InteractionsModel>(context, listen: false).unsubscribe();
      Provider.of<NearbyUsersModel>(context, listen: false).unsubscribe();
      auth.signOut();
    };
    var loginCallback = () {
      auth.getCurrentUser().then(
        (user) async {
          if (user != null) {
            print('user id is: ' + user.uid);
            var currentUser = await DatabaseService().getUser(user.uid);
            Provider.of<InteractionsModel>(context, listen: false).userId =
                currentUser.userId;
            Provider.of<NearbyUsersModel>(context, listen: false).userId =
                currentUser.userId;
            Navigator.popAndPushNamed(
              context,
              DiscoveryFeed.routeName,
              arguments: Arguments(
                currentUser: currentUser,
                logoutCallback: logoutCallback,
              ),
            );
          }
        },
      );
    };

    auth.getCurrentUser().then(
      (user) async {
        if (user != null) {
          print('user id is: ' + user.uid);
          var currentUser = await DatabaseService().getUser(user.uid);
          Provider.of<InteractionsModel>(context, listen: false).userId =
              currentUser.userId;
          Provider.of<NearbyUsersModel>(context, listen: false).userId =
              currentUser.userId;
          Navigator.pushNamed(
            context,
            DiscoveryFeed.routeName,
            arguments: Arguments(
              currentUser: currentUser,
              logoutCallback: logoutCallback,
            ),
          );
        }
      },
    );

    return LoginSignupRoot(
      auth: auth,
      loginCallback: () {
        Navigator.pushNamed(
          context,
          DiscoveryFeed.routeName,
          arguments: Arguments(
            loginCallback: loginCallback,
          ),
        );
      },
    );
  }
}
