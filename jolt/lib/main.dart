import 'package:flutter/material.dart';
import 'package:jolt/discovery_feed.dart';
import 'package:jolt/notifications_screen.dart';
import 'package:provider/provider.dart';
import './root_page.dart';
import './authentication.dart';
import 'database_service.dart';
import 'login_signup_root.dart';
import 'models/interactions_model.dart';
import 'models/nearby_users_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NearbyUsersModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => InteractionsModel(),
        ),
      ],
      child: MaterialApp(
        home: RootPage(),
        onGenerateRoute: (settings) {
          final Arguments args = settings.arguments;
          if (settings.name == NotificationsScreen.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return NotificationsScreen(
                  currentUser: args.currentUser,
                  logoutCallback: args.logoutCallback,
                );
              },
            );
          } else if (settings.name == DiscoveryFeed.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return DiscoveryFeed(
                  currentUser: args.currentUser,
                  logoutCallback: args.logoutCallback,
                );
              },
            );
          } else if (settings.name == LoginSignupRoot.routeName) {
            return MaterialPageRoute(
              builder: (context) {
                return LoginSignupRoot(
                  auth: args.auth,
                  loginCallback: args.loginCallback,
                );
              },
            );
          } else {
            return MaterialPageRoute(
              builder: (context) {
                return RootPage();
              },
            );
          }
        },
      ),
    );
  }
}

class Arguments {
  final User currentUser;
  final VoidCallback logoutCallback;
  final Auth auth;
  final VoidCallback loginCallback;

  Arguments({
    this.currentUser,
    this.logoutCallback,
    this.auth,
    this.loginCallback,
  });
}
