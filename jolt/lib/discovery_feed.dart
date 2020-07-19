import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './location_available.dart';
import './size_config.dart';
import './jolt_app_bar.dart';
import './jolter_list_view.dart';

class DiscoveryFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: JoltAppBar(
        onPressed: () {},
        child: null,
        title: null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: LocationAvailable(),
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
              )),
          Container(
            width: double.infinity,
            child: JolterListView(),
          )
        ],
      ),
    );
  }
}
