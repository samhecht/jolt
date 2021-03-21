import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './size_config.dart';
import './jolter_selected_screen.dart';
import './database_service.dart';

class JolterListEntry extends StatelessWidget {
  final User selectedUser;
  final User currentUser;

  JolterListEntry({
    @required this.selectedUser,
    @required this.currentUser,
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
              name: selectedUser.name,
              userId: selectedUser.userId,
              pictureUrl: selectedUser.pictureUrl,
              myUserId: currentUser.userId,
              currentUser: currentUser,
            ),
          ),
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
                    image: CachedNetworkImageProvider(selectedUser.pictureUrl),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(left: 60),
              child: Text(
                selectedUser.name,
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
