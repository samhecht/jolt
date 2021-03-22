import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/received_interaction_screen/received_interaction_screen.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/main.dart';

class NotificationsListEntry extends StatelessWidget {
  final JoltNotification notification;
  final User currentUser;

  NotificationsListEntry({
    @required this.notification,
    @required this.currentUser,
  });

  Text notificationToString() {
    String name = notification?.fromUser?.name;
    DateTime timestamp = DateTime.parse(notification?.timestamp);
    int recency = DateTime.now().difference(timestamp).inMinutes;
    String action = '';
    switch (notification?.type) {
      case NotificationType.wave:
        {
          action = 'waved';
        }
        break;
      case NotificationType.wink:
        {
          action = 'winked';
        }
        break;
      case NotificationType.text:
        {
          action = 'texted';
        }
        break;
      default:
        {
          action = 'waved';
        }
        break;
    }
    String textBody = '$name just $action at you! $recency minutes ago';
    return Text(
      textBody,
      style: TextStyle(
        fontSize: 10,
        fontFamily: 'Schoolbell-Regular',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ReceivedInteractionScreen.routeName,
          arguments: Arguments(
            notification: notification,
          ),
        );
      },
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 80,
        height: 50,
        margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffeceff1),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          children: <Widget>[
            Container(
                width: 100,
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: CachedNetworkImageProvider(
                        notification.fromUser.pictureUrl),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(),
              child: notificationToString(),
            ),
          ],
        ),
      ),
    );
  }
}
