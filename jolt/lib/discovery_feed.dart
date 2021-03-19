import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import './location_available.dart';
import './size_config.dart';
import './jolt_app_bar.dart';
import './jolter_list_view.dart';
import './authentication.dart';
import './database_service.dart';

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
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress;

  @override
  void initState() {
    () async {
      try {
        String address = await _getAddressFromLatLng();

        setState(() {
          _currentAddress = address;
        });
        writeAddressToDatabase();
      } catch (e) {
        print(e.message);
      }
    }();
    super.initState();
  }

  _getCurrentLocation() async {
    return await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<String> _getAddressFromLatLng() async {
    try {
      Position currentPosition = await _getCurrentLocation();
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      String address =
          '${place.subThoroughfare} ${place.thoroughfare}, ${place.locality}, ${place.administrativeArea}';
      return address;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void writeAddressToDatabase() async {
    try {
      if (!await DatabaseService().updateUserAddress(
        userId: widget.userId,
        newAddress: _currentAddress,
      )) {
        throw Exception('couldn\'t update user address');
      }
    } catch (e) {
      print('couldn\'t write address to database $e.message');
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
