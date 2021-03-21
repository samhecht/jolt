import 'package:flutter/material.dart';
import 'package:jolt/notifications_screen.dart';
import 'package:provider/provider.dart';
import './database_service.dart';
import 'authentication.dart';
import 'main.dart';
import 'models/interactions_model.dart';
import 'models/nearby_users_model.dart';

class JoltAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;
  final VoidCallback logoutCallback;
  final User currentUser;

  @override
  final Size preferredSize;
  JoltAppBar({
    @required this.title,
    @required this.child,
    @required this.onPressed,
    @required this.currentUser,
    this.onTitleTapped,
    this.logoutCallback,
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
            onSelected: (String choice) {
              String currentRoute = ModalRoute.of(context).settings.name;
              // a little messy
              if (choice == MenuItems.logout) {
                Provider.of<InteractionsModel>(context, listen: false)
                    .unsubscribe();
                Provider.of<NearbyUsersModel>(context, listen: false)
                    .unsubscribe();
                Auth().signOut();
                Navigator.pushNamed(
                  context,
                  'root',
                );
              } else if (choice == MenuItems.notifications &&
                  currentRoute != NotificationsScreen.routeName) {
                print('User selected notifications screen');
                Navigator.pushNamed(
                  context,
                  NotificationsScreen.routeName,
                  arguments: Arguments(
                    currentUser: currentUser,
                    logoutCallback: logoutCallback,
                  ),
                );
              } else if (choice == MenuItems.testWave) {
                testWave();
              } else if (choice == MenuItems.testWink) {
                testWink();
              } else if (choice == MenuItems.testText) {
                testText();
              }
            },
            itemBuilder: (BuildContext context) {
              return MenuItems.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
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
  static const String testWave = 'Test Wave';
  static const String testWink = 'Test Wink';
  static const String testText = 'Test Text';

  static const List<String> choices = <String>[
    logout,
    notifications,
    testWave,
    testWink,
    testText,
  ];
}
