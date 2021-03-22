import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/jolter_selected_screen/jolter_selected_screen.dart';
import 'package:jolt/services/database_service.dart';

import 'package:jolt/main.dart';

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
        Navigator.pushNamed(
          context,
          JolterSelectedScreen.routeName,
          arguments: Arguments(
            selectedUser: selectedUser,
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
