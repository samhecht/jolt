import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jolt/services/database_service.dart';

class ActiveChatForm extends StatefulWidget {
  final JoltConversation conversation;
  ActiveChatForm({this.conversation});

  @override
  _ActiveChatFormState createState() => _ActiveChatFormState();
}

class _ActiveChatFormState extends State<ActiveChatForm> {
  final _formKey = GlobalKey<FormState>();

  String currentText;

  @override
  Widget build(BuildContext context) {
    final fieldText = TextEditingController();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              currentText = value;
            },
            controller: fieldText,
          ),
          CupertinoButton(
            child: Text('Send'),
            onPressed: () {
              print('sending $currentText');
              String otherUser = widget?.conversation?.fromUser?.userId;
              String currUser =
                  widget?.conversation?.conversationId?.split('+')[0] ==
                          otherUser
                      ? widget?.conversation?.conversationId?.split('+')[1]
                      : widget?.conversation?.conversationId?.split('+')[0];
              DatabaseService().sendMessage(currUser, otherUser, currentText);
              fieldText.clear();
            },
          ),
        ],
      ),
    );
  }
}
