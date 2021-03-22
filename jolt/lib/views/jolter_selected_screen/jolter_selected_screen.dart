import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jolt/models/authentication_model.dart';
import 'package:jolt/views/authentication_screen/login_signup_root.dart';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/widgets/jolt_app_bar.dart';
import 'package:jolt/services/database_service.dart';
import 'package:provider/provider.dart';

class JolterSelectedScreen extends StatelessWidget {
  static const routeName = 'jolter_selected';

  final User selectedUser;

  JolterSelectedScreen({
    @required this.selectedUser,
  });

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthenticationModel>(
      context,
      listen: false,
    ).isNotSignedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginSignupRoot.routeName,
        (route) => false,
      );
    }

    User currentUser = Provider.of<AuthenticationModel>(
      context,
      listen: false,
    ).currentUser;

    SizeConfig().init(context);
    return Scaffold(
      appBar: JoltAppBar(
        child: null,
        onPressed: () {},
        title: null,
        currentUser: currentUser,
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
                  image: CachedNetworkImageProvider(selectedUser.pictureUrl),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 10,
              alignment: Alignment.center,
              child: Text(
                selectedUser.name,
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
                    DatabaseService().wave(
                      currentUser?.userId,
                      selectedUser?.userId,
                    );
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
                    DatabaseService().wink(
                      currentUser?.userId,
                      selectedUser?.userId,
                    );
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
