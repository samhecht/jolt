import 'package:flutter/material.dart';
import './jolter_list_entry.dart';
import './size_config.dart';
import './database_service.dart';

class JolterListView extends StatefulWidget {
  // current address used to find nearby users
  final String myCurrentAddress;
  final String userId;

  JolterListView({
    @required this.myCurrentAddress,
    @required this.userId,
  });
  @override
  _JolterListViewState createState() => _JolterListViewState();
}

// this class displays a list of jolters in the same physical locaiton as you
class _JolterListViewState extends State<JolterListView> {
  // keep a list of nearby users to display
  Map<String, User> nearbyUsers = new Map();

  // runs when the widget is updated with new parameters
  // for now, attach a listner to track nearby users
  @override
  void didUpdateWidget(covariant JolterListView oldWidget) {
    DatabaseService().listenForNearbyUsers(
      widget.myCurrentAddress,
      (Map<String, User> nearbyUsersReturned) => setState(() {
        nearbyUsers = nearbyUsersReturned;
      }),
    );
    DatabaseService().listenForChats(widget.userId,
        (Map<String, dynamic> chatMap) {
      print('chats changed');
      print(chatMap);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 70,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        children: nearbyUsers.entries.map((user) {
          return JolterListEntry(
            name: user.value.name,
            userId: user.value.userId,
            pictureUrl: user.value.pictureUrl,
            myUserId: widget.userId,
          );
        }).toList(),
      ),
    );
  }
}
