import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:jolt/views/active_chat_screen/active_chat_screen.dart';
import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/main.dart';

class MessagesListEntry extends StatelessWidget {
  final JoltConversation conversation;
  final User currentUser;

  MessagesListEntry({
    @required this.conversation,
    @required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ActiveChatScreen.routeName,
          arguments: Arguments(
            conversation: conversation,
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
                      conversation?.fromUser?.pictureUrl),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(),
              child: Text(
                '${conversation?.fromUser?.name} : ${conversation?.messages?.length} unread messages.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
