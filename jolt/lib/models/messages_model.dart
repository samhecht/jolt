import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:jolt/services/database_service.dart';

class MessagesModel extends ChangeNotifier {
  Map<String, JoltConversation> _conversations = {};
  int _quantityReturned = 20;
  String _userId;

  MessagesModel();

  set userId(String userId) {
    _userId = userId;
    _subscribeToMessages();
  }

  void _subscribeToMessages() async {
    User currUser = await DatabaseService().getUser(_userId);

    String conversationIds = currUser.conversations.join(';');

    DatabaseService().subscribe(
      JoltTopic.chats,
      updateConversations,
      {
        'myConversations': conversationIds,
      },
    );
  }

  void unsubscribe() {
    DatabaseService().unsubscribe(JoltTopic.chats);
  }

  UnmodifiableListView<JoltConversation> get conversations {
    List<JoltConversation> convs = _conversations.entries
        .map(
          (conversation) => conversation.value,
        )
        .toList();
    return UnmodifiableListView(convs);
  }

  JoltConversation conversation(String convId) {
    return _conversations[convId];
  }

  get quantityReturned => _quantityReturned;
  set quanitityReturned(int quantity) {
    _quantityReturned = quantity;
  }

  void updateConversations(JoltConversation conversation) async {
    if (_conversations.containsKey(conversation.conversationId)) {
      _conversations[conversation.conversationId].messages =
          conversation.messages;
    } else {
      _conversations[conversation.conversationId] = conversation;
    }

    if (_conversations[conversation.conversationId].fromUser ?? true) {
      List<String> ids = conversation.conversationId.split('+');
      String fromId = ids[0] == _userId ? ids[1] : ids[0];

      _conversations[conversation.conversationId].fromUser =
          await DatabaseService().getUser(fromId);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    DatabaseService().unsubscribe(JoltTopic.chats);
    super.dispose();
  }
}
