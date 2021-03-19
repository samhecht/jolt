import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './size_config.dart';
import './jolter_selected_screen.dart';

class JolterListEntry extends StatelessWidget {
  final String name;
  final String userId;
  final String pictureUrl;
  final String myUserId;

  JolterListEntry({
    @required this.name,
    @required this.userId,
    @required this.pictureUrl,
    @required this.myUserId,
  });
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JolterSelectedScreen(
                    name: name,
                    userId: userId,
                    pictureUrl: pictureUrl,
                    myUserId: myUserId,
                  )),
        );
      },
      child: Container(
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
                    image: CachedNetworkImageProvider(pictureUrl),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(left: 60),
              child: Text(
                name,
                style:
                    TextStyle(fontSize: 30, fontFamily: 'Schoolbell-Regular'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
