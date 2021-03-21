import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './size_config.dart';
import './notifications_list_entry.dart';
import './database_service.dart';
import 'models/interactions_model.dart';

class NotificationsListView extends StatelessWidget {
  final List<JoltNotification> notifications = [];
  final User currentUser;

  NotificationsListView({
    @required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<InteractionsModel>(
      builder: (
        context,
        data,
        child,
      ) =>
          Container(
        width: double.infinity,
        height: SizeConfig.blockSizeVertical * 70,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: data.interactions.map(
            (notification) {
              return new NotificationsListEntry(
                notification: notification,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
