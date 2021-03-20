import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jolt/notifications_screen.dart';

import './location_available.dart';
import './size_config.dart';
import './jolt_app_bar.dart';
import './jolter_list_view.dart';
import './authentication.dart';
import './database_service.dart';

class DiscoveryFeed extends StatefulWidget {
  final String username;
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  DiscoveryFeed({
    @required this.username,
    @required this.userId,
    @required this.auth,
    @required this.logoutCallback,
  });

  @override
  _DiscoveryFeedState createState() => _DiscoveryFeedState();
}

class _DiscoveryFeedState extends State<DiscoveryFeed> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress;
  List<JoltNotification> notifications = [];

  @override
  void initState() {
    // Update the address
    DatabaseService().updateUserAddress(
      userId: widget.userId,
      callback: (String address) => setState(
        () {
          _currentAddress = address;
        },
      ),
    );

    // Subscribe for wave updates
    DatabaseService().subscribe(
      JoltTopic.wave,
      (List<JoltNotification> waves) => setState(
        () {
          print('got some waves');
          notifications = [...notifications, ...waves];
        },
      ),
      {'userId': widget.userId},
    );

    // Subscribe for wink updates
    DatabaseService().subscribe(
      JoltTopic.wink,
      (List<JoltNotification> waves) => setState(
        () {
          print('got some winks');
          notifications = [...notifications, ...waves];
        },
      ),
      {'userId': widget.userId},
    );

    super.initState();
  }

  @override
  void dispose() {
    DatabaseService().unsubscribe(JoltTopic.wave);
    DatabaseService().unsubscribe(JoltTopic.wink);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: JoltAppBar(
        onPressed: () {},
        child: null,
        title: null,
        logoutCallback: widget.logoutCallback,
        notificationsCallback: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationsScreen(
                userId: widget.userId,
                notifications: notifications,
              ),
            ),
          );
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: LocationAvailable(),
          ),
          Text(_currentAddress != null ? '$_currentAddress' : ''),
          Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Jolters Near Me',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Schoolbell-Regular',
                ),
              )),
          Expanded(
            child: Container(
              width: double.infinity,
              child: JolterListView(
                myCurrentAddress: _currentAddress,
                userId: widget.userId,
              ),
            ),
          )
        ],
      ),
    );
  }
}
