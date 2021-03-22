import 'package:flutter/material.dart';
import 'package:jolt/models/messages_model.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/messages_screen/messages_list_entry.dart';
import 'package:jolt/services/database_service.dart';

class MessagesListView extends StatelessWidget {
  final User currentUser;

  MessagesListView({
    @required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesModel>(
      builder: (
        context,
        data,
        child,
      ) =>
          Container(
        width: double.infinity,
        height: SizeConfig.blockSizeVertical * 70,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: data.conversations.map(
            (conversation) {
              return new MessagesListEntry(
                conversation: conversation,
                currentUser: currentUser,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
