import 'package:flutter/material.dart';
import './size_config.dart';
import './jolt_app_bar.dart';

class ReceivedWaveScreen extends StatelessWidget {
  final String receivedFrom;
  final bool winked;
  final String name;

  ReceivedWaveScreen({
    @required this.receivedFrom,
    @required this.winked,
    @required this.name,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: JoltAppBar(
        child: null,
        onPressed: () {},
        title: null,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: AssetImage('assets/images/headshot.jpg'),
                ),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 20, top: 20),
              child: Text(
                'Congratulations $name, $receivedFrom has ' +
                    (winked ? 'winked' : 'waved') +
                    ' at you! ' +
                    (winked ? 'wink' : 'wave') +
                    ' back?',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Schoolbell-Regular',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal * 22,
                  height: 100,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: RaisedButton(
                      onPressed: () {
                        print('waved back at $name');
                      },
                      color: Color(0xfff8f157),
                      child: Image(
                        image: AssetImage('assets/images/wave.png'),
                      ),
                    ),
                  ),
                ),
                Container(width: SizeConfig.blockSizeHorizontal * 6),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 22,
                  height: 100,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: RaisedButton(
                      onPressed: () {
                        print('winked back at $name');
                      },
                      color: Color(0xfff8f157),
                      child: Image(
                        image: AssetImage('assets/images/wink.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(bottom: 20),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 60),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
