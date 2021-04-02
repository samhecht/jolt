import 'package:flutter/material.dart';
import 'package:jolt/models/messages_model.dart';
import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/views/active_chat_screen/active_chat_list_entry.dart';
import 'package:provider/provider.dart';

class ActiveChatListView extends StatelessWidget {
  final User currentUser;
  final JoltConversation conversation;
  final ScrollController _controller = new ScrollController();

  ActiveChatListView({
    @required this.currentUser,
    @required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesModel>(
      builder: (context, conversations, child) => Container(
        width: double.infinity,
        height: SizeConfig.blockSizeVertical * 70,
        child: ListView(
          shrinkWrap: true,
          reverse: true,
          padding: const EdgeInsets.all(8),
          controller: _controller,
          // need to make this more readable
          children:
              conversations.conversation(conversation?.conversationId) != null
                  ? conversations
                      .conversation(conversation.conversationId)
                      .messages
                      .map(
                      (message) {
                        return new ActiveChatListEntry(
                          message: message,
                          currentUser: currentUser,
                        );
                      },
                    ).toList()
                  : [Container()],
        ),
      ),
    );
  }
}
