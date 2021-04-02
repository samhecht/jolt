import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/authentication_screen/login_signup_root.dart';
import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/widgets/jolt_app_bar.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/models/authentication_model.dart';

class ReceivedInteractionScreen extends StatelessWidget {
  static const routeName = 'received_interaction';

  final JoltNotification notification;

  ReceivedInteractionScreen({
    @required this.notification,
  });

  String buildNotificationText(
    User currentUser,
  ) {
    String myName = currentUser?.name;
    String from = notification.fromUser?.name;
    String type = JoltNotification.getStringFromType(notification.type);
    return 'Congratulations $myName, $from has ${type}ed at you! $type back?';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    User currentUser = Provider.of<AuthenticationModel>(
      context,
      listen: false,
    ).currentUser;

    return Scaffold(
      appBar: JoltAppBar(
        child: null,
        onPressed: () {},
        title: null,
        currentUser: currentUser,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: AssetImage('assets/images/headshot.jpg'),
                ),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 20, top: 20),
              child: Text(
                buildNotificationText(currentUser),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Schoolbell-Regular',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal * 22,
                  height: 100,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: RaisedButton(
                      onPressed: () {
                        DatabaseService().wave(
                          currentUser?.userId,
                          notification?.fromUser?.userId,
                        );
                      },
                      color: Color(0xfff8f157),
                      child: Image(
                        image: AssetImage('assets/images/wave.png'),
                      ),
                    ),
                  ),
                ),
                Container(width: SizeConfig.blockSizeHorizontal * 6),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 22,
                  height: 100,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: RaisedButton(
                      onPressed: () {
                        DatabaseService().wink(
                          currentUser?.userId,
                          notification?.fromUser?.userId,
                        );
                      },
                      color: Color(0xfff8f157),
                      child: Image(
                        image: AssetImage('assets/images/wink.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(bottom: 20),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 60),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
