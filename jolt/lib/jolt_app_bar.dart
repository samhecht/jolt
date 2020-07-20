import 'package:flutter/material.dart';

class JoltAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;
  final VoidCallback logoutCallback;

  @override
  final Size preferredSize;
  JoltAppBar({
    @required this.title,
    @required this.child,
    @required this.onPressed,
    this.onTitleTapped,
    this.logoutCallback,
  }) : preferredSize = Size.fromHeight(60.0);

  void menuChoiceAction(String choice) {
    if (choice == MenuItems.LOGOUT) {
      print('User logging out');
      logoutCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.only(right: 20),
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
  static const String LOGOUT = 'Logout';

  static const List<String> choices = <String>[
    LOGOUT,
  ];
}
