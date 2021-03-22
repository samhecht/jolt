import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jolt/views/authentication_screen/login_signup_root.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/widgets/location_available.dart';
import 'package:jolt/views/widgets/jolt_app_bar.dart';
import 'package:jolt/views/discovery_screen/jolter_list_view.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/models/authentication_model.dart';

class DiscoveryFeed extends StatelessWidget {
  static const routeName = '/discovery';

  final List<JoltNotification> notifications = [];

  DiscoveryFeed();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (Provider.of<AuthenticationModel>(
      context,
      listen: false,
    ).isNotSignedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginSignupRoot.routeName,
        (route) => false,
      );
    }
    return Scaffold(
      appBar: JoltAppBar(
        onPressed: () {},
        child: null,
        title: null,
        currentUser: Provider.of<AuthenticationModel>(
          context,
          listen: false,
        ).currentUser,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: LocationAvailable(),
          ),
          Text(
            Provider.of<AuthenticationModel>(context, listen: false)
                .currentUser
                .location,
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
                currentUser:
                    Provider.of<AuthenticationModel>(context, listen: false)
                        .currentUser,
              ),
            ),
          )
        ],
      ),
    );
  }
}
