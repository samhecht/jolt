import 'package:flutter/material.dart';

class JoltAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;
  final VoidCallback logoutCallback;
  final VoidCallback notificationsCallback;

  @override
  final Size preferredSize;
  JoltAppBar({
    @required this.title,
    @required this.child,
    @required this.onPressed,
    this.onTitleTapped,
    this.logoutCallback,
    this.notificationsCallback,
  }) : preferredSize = Size.fromHeight(60.0);

  void menuChoiceAction(String choice) {
    if (choice == MenuItems.logout) {
      print('User logging out');
      logoutCallback();
    } else if (choice == MenuItems.notifications) {
      print('User selected notifications screen');
      notificationsCallback();
    }
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
            onSelected: menuChoiceAction,
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

  static const List<String> choices = <String>[
    logout,
    notifications,
  ];
}
