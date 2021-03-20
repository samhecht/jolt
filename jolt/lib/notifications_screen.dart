import 'package:flutter/material.dart';
import 'package:jolt/notifications_list_view.dart';
import './jolt_app_bar.dart';
import './size_config.dart';
import 'database_service.dart';

class NotificationsScreen extends StatelessWidget {
  final String userId;
  final List<JoltNotification> notifications = [];

  NotificationsScreen({
    @required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: JoltAppBar(
        child: null,
        onPressed: () {},
        title: null,
      ),
      body: Container(
        height: SizeConfig.blockSizeVertical * 100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: NotificationsListView(
                  notifications: notifications,
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
