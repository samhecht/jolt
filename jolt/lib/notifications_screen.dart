import 'package:flutter/material.dart';
import 'package:jolt/notifications_list_view.dart';
import './jolt_app_bar.dart';
import './size_config.dart';
import 'database_service.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;
  final List<JoltNotification> notifications;

  NotificationsScreen({
    @required this.userId,
    @required this.notifications,
  }) {
    notifications.sort((a, b) {
      var timeA = DateTime.parse(a.timestamp);
      var timeB = DateTime.parse(b.timestamp);
      if (timeA.difference(timeB).inMinutes < 0) {
        return 1;
      } else {
        return -1;
      }
    });
  }

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

// this seems like it can be stateless
class _NotificationsScreenState extends State<NotificationsScreen> {
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
                  notifications: widget.notifications,
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
