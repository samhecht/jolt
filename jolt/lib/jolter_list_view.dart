import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './jolter_list_entry.dart';
import './size_config.dart';
import './database_service.dart';
import './models/nearby_users_model.dart';

// this class displays a list of jolters in the same physical locaiton as you
class JolterListView extends StatelessWidget {
  final User currentUser;

  JolterListView({@required this.currentUser});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<NearbyUsersModel>(
      builder: (context, users, child) => Container(
        width: double.infinity,
        height: SizeConfig.blockSizeVertical * 70,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: users.nearbyUsers.map(
            (user) {
              return JolterListEntry(
                selectedUser: user,
                currentUser: currentUser,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
