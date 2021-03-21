import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:jolt/notifications_screen.dart';

import './location_available.dart';
import './size_config.dart';
import './jolt_app_bar.dart';
import './jolter_list_view.dart';
import './database_service.dart';
import 'main.dart';

class DiscoveryFeed extends StatelessWidget {
  static const routeName = '/discovery';

  final List<JoltNotification> notifications = [];

  final User currentUser;
  final VoidCallback logoutCallback;

  DiscoveryFeed({
    @required this.currentUser,
    @required this.logoutCallback,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: JoltAppBar(
        onPressed: () {},
        child: null,
        title: null,
        currentUser: currentUser,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: LocationAvailable(),
          ),
          Text(
            'address need to update',
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'Jolters Near Me',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Schoolbell-Regular',
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: JolterListView(
                currentUser: currentUser,
              ),
            ),
          )
        ],
      ),
    );
  }
}
