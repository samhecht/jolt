import 'package:flutter/material.dart';
import './size_config.dart';

class JolterListEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      height: 100,
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffeceff1),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: 100,
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage('assets/images/headshot.jpg'),
                ),
              )),
          Container(
            margin: EdgeInsets.only(left: 60),
            child: Text(
              'Sammy',
              style: TextStyle(fontSize: 30, fontFamily: 'Schoolbell-Regular'),
            ),
          ),
        ],
      ),
    );
  }
}
