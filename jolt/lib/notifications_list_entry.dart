import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './size_config.dart';
import './database_service.dart';

class NotificationsListEntry extends StatelessWidget {
  final JoltNotification notification;

  NotificationsListEntry({@required this.notification});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        print('clicked a notification, should probably route to a screen');
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
              margin: EdgeInsets.only(left: 60),
              child: Text(
                notification.fromUser.name,
                style:
                    TextStyle(fontSize: 30, fontFamily: 'Schoolbell-Regular'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
