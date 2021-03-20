import 'package:flutter/material.dart';
import './size_config.dart';
import './notifications_list_entry.dart';
import './database_service.dart';

class NotificationsListView extends StatelessWidget {
  final List<JoltNotification> notifications;

  NotificationsListView({
    @required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 70,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        children: notifications.map((notification) {
          return new NotificationsListEntry(notification: notification);
        }).toList(),
      ),
    );
  }
}
