import 'package:flutter/material.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/views/active_chat_screen/active_chat_form.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/authentication_screen/login_signup_root.dart';
import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/widgets/jolt_app_bar.dart';
import 'package:jolt/views/active_chat_screen/active_chat_list_view.dart';
import 'package:jolt/models/authentication_model.dart';

class ActiveChatScreen extends StatelessWidget {
  static const routeName = '/active_chat';

  final JoltConversation conversation;

  ActiveChatScreen({
    this.conversation,
  });

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
        title: conversation?.fromUser?.name,
        currentUser: currentUser,
      ),
      body: Container(
        height: SizeConfig.blockSizeVertical * 80,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: ActiveChatListView(
                  currentUser: currentUser,
                  conversation: conversation,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: SizeConfig.blockSizeVertical * 20,
              padding: EdgeInsets.only(top: 10),
              child: ActiveChatForm(
                conversation: conversation,
              ),
            ),
            Container(
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 20,
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
