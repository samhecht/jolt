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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              size: 60,
            ),
            onPressed: () {
              if (logoutCallback != null) {
                print('logging out, this wont be desired behavior');
                logoutCallback();
              }
            },
          )
        ],
      ),
    );
  }
}
