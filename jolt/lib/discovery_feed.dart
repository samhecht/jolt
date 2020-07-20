import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './location_available.dart';
import './size_config.dart';
import './jolt_app_bar.dart';
import './jolter_list_view.dart';
import 'package:geolocator/geolocator.dart';
import './authentication.dart';

class DiscoveryFeed extends StatefulWidget {
  // we'll get the name from the db at some point, for now just set it to sammy
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
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress;
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
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
              child: JolterListView(),
            ),
          )
        ],
      ),
    );
  }
}
