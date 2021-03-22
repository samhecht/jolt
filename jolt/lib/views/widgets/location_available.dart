import 'package:flutter/material.dart';

import 'package:jolt/views/utilities/size_config.dart';

class LocationAvailable extends StatefulWidget {
  @override
  _LocationAvailableState createState() => _LocationAvailableState();
}

class _LocationAvailableState extends State<LocationAvailable> {
  bool locationAvailable = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Container(
              width: SizeConfig.safeBlockHorizontal * 50,
              height: 50,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: locationAvailable
                    ? const Color(0xffb6e180)
                    : const Color(0xffe91919),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onTap: () async {
              setState(() {
                locationAvailable = !locationAvailable;
              });
            },
          ),
          Text(
            'Location available: ' + (locationAvailable ? 'Yes' : 'No'),
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Schoolbell-Regular',
            ),
          ),
        ],
      ),
    );
  }
}
