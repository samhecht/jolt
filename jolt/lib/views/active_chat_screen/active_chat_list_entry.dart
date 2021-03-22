import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/services/database_service.dart';

class ActiveChatListEntry extends StatelessWidget {
  final JoltTextMessage message;
  final User currentUser;

  ActiveChatListEntry({
    @required this.message,
    @required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        print('tapped a message');
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
              margin: EdgeInsets.only(),
              width: SizeConfig.safeBlockHorizontal * 70,
              child: Text(
                '${message?.sentBy} : ${message?.text} : ${message.timestamp}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
