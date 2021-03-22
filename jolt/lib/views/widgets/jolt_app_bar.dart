import 'package:flutter/material.dart';
import 'package:jolt/models/messages_model.dart';
import 'package:jolt/views/messages_screen/messages_screen.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/notifications_screen/notifications_screen.dart';
import 'package:jolt/views/authentication_screen/login_signup_root.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/models/authentication_model.dart';
import 'package:jolt/models/interactions_model.dart';
import 'package:jolt/models/nearby_users_model.dart';

class JoltAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;
  final User currentUser;
  final Size preferredSize;

  @override
  JoltAppBar({
    @required this.title,
    @required this.child,
    @required this.onPressed,
    @required this.currentUser,
    this.onTitleTapped,
  }) : preferredSize = Size.fromHeight(60.0);

  void testWave() async {
    User sam = await DatabaseService().getUser('QoHNDTFfA7hpEywzeRg9Dhaadr62');
    User dan = await DatabaseService().getUser('Yf3bbbhTZvehRmT3KulBtYzgeSe2');
    DatabaseService().wave(sam.userId, dan.userId);
  }

  void testWink() async {
    User sam = await DatabaseService().getUser('QoHNDTFfA7hpEywzeRg9Dhaadr62');
    User dan = await DatabaseService().getUser('Yf3bbbhTZvehRmT3KulBtYzgeSe2');

    DatabaseService().wink(sam.userId, dan.userId);
  }

  void testText() async {
    User sam = await DatabaseService().getUser('QoHNDTFfA7hpEywzeRg9Dhaadr62');
    User dan = await DatabaseService().getUser('Yf3bbbhTZvehRmT3KulBtYzgeSe2');

    String messageText = 'Sending a test message';

    DatabaseService().sendMessage(sam.userId, dan.userId, messageText);
  }

  // Return a function to deal with menu item choices
  Function(String) getOnSelected(BuildContext context) {
    return (String choice) {
      String currentRoute = ModalRoute.of(context).settings.name;
      if (choice == MenuItems.logout) {
        Provider.of<InteractionsModel>(
          context,
          listen: false,
        ).unsubscribe();
        Provider.of<NearbyUsersModel>(
          context,
          listen: false,
        ).unsubscribe();
        Provider.of<MessagesModel>(
          context,
          listen: false,
        ).unsubscribe();
        Provider.of<AuthenticationModel>(
          context,
          listen: false,
        ).signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginSignupRoot.routeName,
          (route) => false,
        );
      } else if (choice == MenuItems.notifications &&
          currentRoute != NotificationsScreen.routeName) {
        Navigator.pushNamed(
          context,
          NotificationsScreen.routeName,
        );
      } else if (choice == MenuItems.messages &&
          currentRoute != MessagesScreen.routeName) {
        Navigator.pushNamed(
          context,
          MessagesScreen.routeName,
        );
      } else if (choice == MenuItems.testWave) {
        testWave();
      } else if (choice == MenuItems.testWink) {
        testWink();
      } else if (choice == MenuItems.testText) {
        testText();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.only(right: 30, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.home,
              size: 60,
            ),
            offset: Offset(
              0,
              100,
            ),
            onSelected: getOnSelected(context),
            itemBuilder: (BuildContext context) {
              return MenuItems.choices.map(
                (String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                },
              ).toList();
            },
          )
        ],
      ),
    );
  }
}

class MenuItems {
  static const String logout = 'Logout';
  static const String notifications = 'Notifications';
  static const String messages = 'Messages';
  static const String testWave = 'Test Wave';
  static const String testWink = 'Test Wink';
  static const String testText = 'Test Text';

  static const List<String> choices = <String>[
    logout,
    notifications,
    messages,
    testWave,
    testWink,
    testText,
  ];
}
