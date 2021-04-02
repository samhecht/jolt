import 'package:flutter/material.dart';
import 'package:jolt/services/database_service.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/authentication_screen/login_signup_root.dart';
import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/widgets/jolt_app_bar.dart';
import 'package:jolt/views/messages_screen/messages_list_view.dart';
import 'package:jolt/models/authentication_model.dart';

class MessagesScreen extends StatelessWidget {
  static const routeName = '/messages';

  MessagesScreen();

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
        height: SizeConfig.blockSizeVertical * 100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: MessagesListView(
                  currentUser: currentUser,
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
