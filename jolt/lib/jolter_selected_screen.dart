import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './jolt_app_bar.dart';
import './size_config.dart';
import './database_service.dart';

class JolterSelectedScreen extends StatelessWidget {
  final String name;
  final String userId;
  final String pictureUrl;
  final String myUserId;

  JolterSelectedScreen({
    @required this.name,
    @required this.userId,
    @required this.pictureUrl,
    @required this.myUserId,
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
        height: SizeConfig.blockSizeVertical * 100,
        child: Column(
          children: <Widget>[
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              height: SizeConfig.blockSizeVertical * 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: CachedNetworkImageProvider(pictureUrl),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 10,
              alignment: Alignment.center,
              child: Text(
                name,
                style:
                    TextStyle(fontSize: 40, fontFamily: 'Schoolbell-Regular'),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 50,
              height: SizeConfig.blockSizeVertical * 10,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: RaisedButton(
                  onPressed: () {
                    // wave(myUserId, userId)
                    print('waved at ' + name);
                    DatabaseService().wave(myUserId, userId);
                    DatabaseService()
                        .sendMessage(myUserId, userId, 'hey from marg');
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
              height: SizeConfig.blockSizeVertical * 10,
              margin: EdgeInsets.only(top: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: RaisedButton(
                  onPressed: () {
                    print('winked at ' + name);
                    DatabaseService().wink(myUserId, userId);
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
