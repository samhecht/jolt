import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './jolt_app_bar.dart';
import './size_config.dart';

class JolterSelectedScreen extends StatelessWidget {
  final String name;
  final String userId;
  final String pictureUrl;

  JolterSelectedScreen({
    @required this.name,
    @required this.userId,
    @required this.pictureUrl,
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
                  image: CachedNetworkImageProvider(pictureUrl),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                name,
                style:
                    TextStyle(fontSize: 40, fontFamily: 'Schoolbell-Regular'),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              height: 100,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: RaisedButton(
                  onPressed: () {
                    print('waved at ' + name);
                  },
                  color: Color(0xfff8f157),
                  child: Image(
                    image: AssetImage('assets/images/wave.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              height: 100,
              margin: EdgeInsets.only(top: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: RaisedButton(
                  onPressed: () {
                    print('winked at ' + name);
                  },
                  color: Color(0xfff8f157),
                  child: Image(
                    image: AssetImage('assets/images/wink.png'),
                  ),
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
