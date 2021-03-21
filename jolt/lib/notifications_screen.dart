import 'package:flutter/material.dart';
import 'package:jolt/notifications_list_view.dart';
import './jolt_app_bar.dart';
import './size_config.dart';
import 'database_service.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';
  final User currentUser;
  final VoidCallback logoutCallback;

  NotificationsScreen({
    @required this.currentUser,
    @required this.logoutCallback,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: JoltAppBar(
        child: null,
        onPressed: () {},
        title: null,
        logoutCallback: logoutCallback,
        currentUser: currentUser,
      ),
      body: Container(
        height: SizeConfig.blockSizeVertical * 100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: NotificationsListView(
                  currentUser: currentUser,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 60),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
